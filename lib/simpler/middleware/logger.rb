require 'logger'

module Simpler
  class SimplerLogger

    def initialize(app, **options)
      @logger = Logger.new(options[:logdev] || STDOUT)
      @app = app
    end
    
    def call(env)
      request = Rack::Request.new(env)

      @logger.info request_logger(request)
      @logger.info handler_logger(request)
      @logger.info params_logger(request)
      
      byebug
      status, headers, body = @app.call(env)
 
      @logger.info response_logger(status, headers, request)

      [status, headers, body]
    end
    
    private

    def request_logger(request)
      "Request: #{[request.request_method, request.path_info].join(' ')} "
    end
    
    def handler_logger(request)
      route = @app.router.route_for(request.env)
      controller = route.controller
      action = route.action
      
      "Handler: #{controller}##{action}"
    end
    
    def params_logger(request)
      "Parameters: #{request.env['simpler.parameters']}" #request.params
    end

    def response_logger(status, headers, request)
      name_template =  [request.env['simpler.controller'].name, request.env['simpler.action']].join('/')

      "Response: #{status} #{headers['Content-Type']} #{name_template}.html.erb"
    end

  end
end
