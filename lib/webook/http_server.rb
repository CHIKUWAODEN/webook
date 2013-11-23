# encoding: utf-8

require 'webrick'


module Webook
  class HttpServer
    def initialize()
      @server = nil
      @thread = nil
    end

    def start_server(document_root)
      root = File.expand_path document_root
      @server = WEBrick::HTTPServer.new(
        BindAddress: '127.0.0.1',
        Port: 9999,
        DocumentRoot: root
      )

      # [ :INT, :TERM ].each { |signal|
      #   Signal.trap signal, self.end_server
      # }

      @thread = Thread.new do
        @server.start()
      end
    end

    def end_server()
      puts '[Webook] Shutdown HTTP server...'
      @server.shutdown()
      Thread.new do
        while @server.status != :Stop
          sleep 100
        end
      end
      puts '[Webook] Done' 
    end
  end
end
