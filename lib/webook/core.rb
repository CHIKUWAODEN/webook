# encoding: utf-8

require 'erb'
require 'kramdown'
require 'systemu' # deprecated
require 'open3'

require 'webook/http_server'
require 'webook/config'
require 'webook/erb_helpers'


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


      # Load ERB Helper
      if File.exist?(config.helper)
        puts "Load helper: #{config.helper}"
        require config.helper
      else
        puts "Helper not found: #{config.helper}"
      end


      # Convert source files to HTML
      @temp_files = []
      config.source().each { |src|
        src = "#{config.directory}/#{src}"
        ext = File.extname src

        if (ext == '.md') or (ext == '.markdown')
          # Markdown ERB processing
          puts "ERB"
          erb = ERB.new(
            File.read(
              src,
              :encoding => Encoding::UTF_8
            )
          )

          puts "Markdown"
          doc = Kramdown::Document.new(erb.result(binding))


          ext_path = "#{config.tmp_dir()}/_#{File.basename src, ext}.html"
          File.open(ext_path, 'w') { |file|
            file.write doc.to_html
          }
          @temp_files << ext_path
        end
      }


      puts "combine all HTML files"
      marge = []
      html = @temp_files.each do |file|
        marge << File.read(
          file,
          :encoding => Encoding::UTF_8
        )
      end
      content = marge.join ''

      puts "ERB"
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
      # [todo] - この処理は毎回は必要なさそう
      # command = "wkhtmltopdf --dump-outline --dump-default-toc-xsl > #{config.out_dir}/#{config.title}.xsl"
      # status, stdout, stderr = systemu command
      # puts [ status, stdout, stderr ]


      command = [
        "wkhtmltopdf",
        # Global option
        [
          config.option,
          "--title", config.title,  
          "--encoding UTF-8",
          "--header-html", config.page_header,
          "--footer-html", config.page_footer
        ], [
          # TOC Option
          "toc",
          # [todo] - Webookfile に含めたいが、wkhtmltopdf　固有のオプションなので隔離する方法を考える（将来的にレンダラを切り替えるようなことも考える）
          "--xsl-style-sheet", "./template/toc.xsl", 
          # doesn't work 
          # "--toc-header-text", "TABLE OF CONTENTS",
        ], [
          # Page option
          # "--disable-smart-shrinking",
          # "--user-style-sheet", config.stylesheet,
          "#{config.out_dir}/#{config.title}.html",
          "#{config.out_dir}/#{config.title}.pdf",
        ]
      ].join(' ')
      puts command
      status, stdout, stderr = systemu command
      puts [ status, stdout, stderr ]

      # End server
      server.end_server()

      # Google Chrome を Headless モードで起動してプリントアウトする
      # command = "google-chrome-unstable --headless --disable-gpu --print-to-pdf=\"#{config.out_dir}/#{config.title}_chrome.pdf\" #{config.out_dir}/#{config.title}.html"
      # puts command
      # status, stdout, stderr = Open3.capture3 command
      # puts [ status, stdout, stderr ]


      # viola-savepdf
      # command = "savepdf -s JIS-B5 -o #{config.out_dir}/#{config.title}_viola.pdf #{config.out_dir}/#{config.title}.html"
      # puts command
      # status, stdout, stderr = Open3.capture3 command
      # puts [ status, stdout, stderr ]
    end
  end
end
