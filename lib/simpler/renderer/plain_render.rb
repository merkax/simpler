class PlainRenderer

  attr_reader :header

  def initialize(template)
    @template = template
    @header = 'text/plain'
  end
  
  def render
    @template.values.join
  end
end

