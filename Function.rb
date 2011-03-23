class Function
  attr_reader :isCode, :printable
  attr_accessor :children

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
        output += function.call(child)
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

  def htmlTag(tag, newlines = false)
    newlineString = newlines ? "\n" : ''
    return "<#{tag}>#{newlineString}#{childHTML}</#{tag}>"
  end

  def latexFunction(function)
    return "\\#{function}{#{childLaTeX}}"
  end

  def latexEnvironment(function)
    return "\\begin{#{function}}\n#{childLaTeX}\\end{#{function}}"
  end
end
