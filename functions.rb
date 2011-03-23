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

class Table < Function
  def html
    classString = @arguments == nil ? '' : " class=\"#{@arguments}\""
    return "<table#{classString}>\n#{childHTML}</table>"
  end

  def getTableString
    if @children.empty?
      @document.error 'Tables may not be empty'
    end
    firstRow = @children.first
    if firstRow.class != Row
      @document.error "Encountered an invalid top level class in a table: #{firstRow.class}"
    end
    width = firstRow.children.size
    orientation = []
    width.times { orientation << 'l' }
    separator = '|'
    tableString = separator + orientation.join(separator) + separator
  end

  def latex
    return "\\begin{tabular}{#{getTableString}}\n\\hline\n#{childLaTeX}\\end{tabular}"
  end
end

class Row < Function
  def html
    return htmlTag('tr')
  end

  def latex
    columns = @children.map { |x| x.class == String ? @document.escapeString(x, :latex) : x.latex }
    columns.reject! { |x| x == "\n" }
    columnString = columns.join(' & ')
    output = columnString + " \\\\ \\hline"
    output = output.gsub("\n", '')
    output = output
    return output
  end
end

class Column < Function
  def html
    return htmlTag('td')
  end

  def latex
    return childLaTeX
  end
end
