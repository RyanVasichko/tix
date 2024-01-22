module Middleware
  class LoggingSilencer
    def initialize(app, paths = [])
      @app = app
      @paths = paths
    end

    def call(env)
      if silence_request?(env)
        Rails.logger.silence do
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end

    private

    def silence_request?(env)
      @paths.include?(env['PATH_INFO'])
    end
  end
end
