# encoding: utf-8

require 'erb'
require 'kramdown'
require 'systemu'

require 'webook/http_server'
require 'webook/config'


module Webook
  class WebookCore
    def initialize()
    end

    def build (config)
      # create directory
      [ config.tmp_dir(), config.out_dir() ].each do |dir|
        status, stdout, stderr = systemu "mkdir #{dir}"
        puts [ status, stdout, stderr ]
      end

      # Convert source files to HTML
      @temp_files = []
      config.source().each { |src|
        src = "#{config.directory}/#{src}"
        ext = File.extname src

        if (ext == '.md') or (ext == '.markdown')
          doc = Kramdown::Document.new(
            File.read(
              src,
              :encoding => Encoding::UTF_8
            )
          )
          ext_path = "#{config.tmp_dir()}/_#{File.basename src, ext}.html"
          File.open(ext_path, 'w') { |file|
            file.write doc.to_html
          }
          @temp_files << ext_path
        end
      }


      marge = []
      html = @temp_files.each do |file|
        marge << File.read(
          file,
          :encoding => Encoding::UTF_8
        )
      end
      content = marge.join ''
      html = ERB.new(
        File.read(
          config.template,
          :encoding => Encoding::UTF_8
        )
      ).result binding

      # start server
      server = Webook::HttpServer.new
      server.start_server("#{config.directory}/src")

      # Write to output html
      File.open("#{config.out_dir}/#{config.title_unescaped}.html", 'w') { |file|
        file.write html
      }
      command = "wkhtmltopdf --dump-default-toc-xsl > #{config.out_dir}/#{config.title}.xsl"
      status, stdout, stderr = systemu command
      puts [ status, stdout, stderr ]


      command = "wkhtmltopdf #{config.option} --title '#{config.title}' --user-style-sheet #{config.stylesheet} --header-html #{config.page_header} --footer-html #{config.page_footer} toc --xsl-style-sheet #{config.out_dir}/#{config.title}.xsl #{config.out_dir}/#{config.title}.html #{config.out_dir}/#{config.title}.pdf"
      puts command
      status, stdout, stderr = systemu command
      puts [ status, stdout, stderr ]

      # End server
      server.end_server()
    end
  end
end
