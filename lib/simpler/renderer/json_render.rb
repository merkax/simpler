require 'json'

class JsonRenderer

  attr_reader :header

  def initialize(template)
    @template = template
    @header = 'application/json'
  end
  
  def render
    @template.values.to_json
  end
end


