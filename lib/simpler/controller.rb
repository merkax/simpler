require_relative 'view'
#require_relative 'renderer/renderer'

module Simpler
  class Controller

    TYPE_HEADERS = {
                      html:   'text/html',
                      plain:  'text/plain',
                      inline: 'text/inline',
                      json:   'text/json'
                    }.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

      #byebug
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.parameters'] = parameters(@request.env)

      set_default_headers
      send(action)
      write_response
      
      @response.finish
    end
    
    private
    
    def parameters(env)
      path = env['PATH_INFO']
      path_params = path.split('/')
      { id: path_params[2].to_i }
       byebug
    end
    
    def params
      @request.env['simpler.parameters']
      # byebug
      # @request.params.merge(@request.env['simpler.parameters'])
    end
    
    def set_status(status)
      @response.status = status.to_i
    end
    
    def set_default_headers
      @response['Content-Type'] = TYPE_HEADERS[:html]
    end
    
    def set_headers(headers, type)
      @response['headers'] = TYPE_HEADERS[type.to_sym]
    end
    
    def write_response
      body = @request.env['simpler.body'] || render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      template.is_a?(Hash) ? set_special_body(template) : set_default_body(template)
    end
    
    def set_default_body(template)
      @request.env['simpler.template'] = template
    end
    
    def set_special_body(template)
      require_renderer
      
      renderer = BaseRenderer.new(template).call
      byebug
      @response['Content-Type'] = renderer.header
      @request.env['simpler.body'] = renderer.render
    end
    
    def require_renderer
      Dir["#{__dir__}/renderer/*.rb"].each { |file| require file }
    end
    
    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end
  end
end
