# encoding: utf-8

require 'webook'
require 'webook/core'
require 'webook/project'
require 'webook/config'
require 'webook/version'
require 'thor'


module Webook
  class CLI < Thor

    desc "build [webookfile]", "Build the book"
    def build(webookfile="./Webookfile")
      say "[Webook] Build start", :green
      say "[Webook] Webookfile path: #{webookfile}", :yellow
      config = Webook::Config.new
      config.init webookfile
      core = Webook::WebookCore.new
      core.build config
      say "[Webook] Build end", :green
    end


    desc "create [name]", "Create webook project"
    def create(name)
      say "[Webook] Create Webook project, name: #{name}", :green
      Webook::Project.new().generate name
      say "[Webook] Project has been created", :green
    end


    desc "version", "Put version number to stdout"
    def version()
      say "webook vesion #{Webook::VERSION}"
    end
  end
end
