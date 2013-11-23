require 'json'


module Webook
  class Config
    def initialize()
      @path = ''
      @directory = ''
      @json = ''
    end
    attr_reader :path
    attr_reader :directory

    def init(path)
      # Save file path
      @path = path

      # Load project file
      File.open(path, 'r') do |file|
        @directory = File.dirname file
        @json = JSON.load file
      end
    end

    def page_header
      "#{@directory}/#{@json['header']}"
    end

    def option
      @json["option"].join "\s"
    end

    def title
      @json["title"].gsub /\s/, '\ '
    end

    def title_unescaped
      @json["title"]
    end

    def page_footer
      "#{@directory}/#{@json['footer']}"
    end

    def stylesheet()
      "#{@directory}/#{@json['stylesheet']}"
    end

    def source()
      @json['source']
    end

    def template
      "#{@directory}/#{@json['template']}"
    end
  
    def tmp_dir
      "#{@directory}/#{@json['tmp_dir']}"
    end

    def out_dir
      "#{@directory}/#{@json['out_dir']}"
    end
  end
end
