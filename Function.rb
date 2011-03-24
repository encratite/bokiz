class Function
  attr_reader :isCode, :printable
  attr_accessor :children

  def initialize(document, arguments)
    @document = document
    @arguments = arguments
    @children = []
    @isCode = false
    @printable = true
    @escape = true
    setup
  end

  def setup
    #empty by default
  end

  def getChildContent(type)
    output = ''
    @children.each do |child|
      if child.class == String
        output += @escape ? @document.escapeString(child, type) : child
      else
        output += child.method(type).call
      end
    end
    return output
  end

  def childHTML
    return getChildContent(:html)
  end

  def childLaTeX
    return getChildContent(:latex)
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

  def error(message)
    @document.error(message)
  end
end
