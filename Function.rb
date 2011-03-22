class Function
  attr_reader :isCode, :printable
  attr_writer :children

  def initialize(document, arguments)
    @document = document
    @arguments = arguments
    @children = []
    @isCode = false
    @printable = true
    setup
  end

  def setup
    #empty by default
  end

  def getChildContent(function)
    output = ''
    @children.each do |child|
      if child.class == String
        output += child
      else
        output += function(child)
      end
    end
    return output
  end

  def childHTML
    return getChildContent(lambda { |x| x.html })
  end

  def childLaTeX
    return getChildContent(lambda { |x| x.latex })
  end

  def htmlTag(tag)
    return "<#{tag}>#{childHTML}</#{tag}>"
  end

  def latexFunction(function)
    return "\\#{function}{#{childLaTeX}}"
  end
end
