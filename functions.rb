require_relative 'Function'
require_relative 'GeneralSectionFunction'

class BoldText < Function
  def html
    return htmlTag('b')
  end

  def latex
    return latexFunction('textbf')
  end
end

class SectionFunction < GeneralSectionFunction
  def setup
    @htmlTag = 'h1'
    @latexFunction = 'section'
    @sectionDepth = 0
  end
end

class SubsectionFunction < GeneralSectionFunction
  def setup
    @htmlTag = 'h2'
    @latexFunction = 'subsection'
    @sectionDepth = 1
  end
end

class SubsubsectionFunction < GeneralSectionFunction
  def setup
    @htmlTag = 'h3'
    @latexFunction = 'subsubsection'
    @sectionDepth = 2
  end
end

class Paragraph < Function
  def html
    return htmlTag('p')
  end

  def latex
    return latexFunction('par')
  end
end

class List < Function
  def html
    return htmlTag('ul', true)
  end

  def latex
    return latexEnvironment('itemize')
  end
end

class Element < Function
  def html
    return htmlTag('li')
  end

  def latex
    return "\\item #{childLaTeX}"
  end
end

class Monospace < Function
  def html
    return "<span class=\"monospace\">#{childHTML}</span>"
  end

  def latex
    return latexFunction('texttt')
  end
end
