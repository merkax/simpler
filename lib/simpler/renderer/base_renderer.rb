module Simpler
  class BaseRenderer

    def initialize(template)
      @template = template
    end
    
    def call
      byebug
      result = Object.const_get("#{@template.keys.join.capitalize}Renderer")
      result.new(@template)
    end
  end
end
