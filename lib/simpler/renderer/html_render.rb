require 'sanitize'

class HtmlRenderer

  attr_reader :header

  def initialize(template)
    @template = template
    @header = 'text/html'
  end
  
  def render
    html = @template.values.join #.html_safe - как или не стоит?
    Sanitize.fragment(html)
  end
end
