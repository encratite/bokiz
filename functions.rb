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

class Paragraph< Function
  def html
    return htmlTag('p')
  end

  def latex
    return latexFunction('par')
  end
end
