require 'digest/sha2'

require 'www-library/syntaxHighlighting'

require_relative 'Function'
require_relative 'GeneralSectionFunction'
require_relative 'latex'

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
      error 'Tables may not be empty'
    end
    firstRow = @children.first
    if firstRow.class != Row
      error "Encountered an invalid top level class in a table: #{firstRow.class}"
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

class Group < Function
  def html
    if @arguments == nil
      error 'nil argument in a group function'
    end
    return "<span class=\"#{@arguments}\">#{childHTML}</span>"
  end

  def latex
    return childLaTeX
  end
end

class Code < Function
  Languages = [
    ['assembly', 'masm', 'Assembly'],
    ['assembly-fasm', 'fasm', 'FASM Assembly'],
    ['assembly-gas', 'asm', 'gas Assembly'],
    ['assembly-masm', 'masm', 'MASM Assembly'],
    ['assembly-nasm', 'nasm', 'NASM Assembly'],
    ['cplusplus', 'cpp', 'C++'],
    ['plain', nil, nil],
  ]

  def setup
    @isCode = true
    @escape = false
    if @arguments == nil
      error 'No code type specified for a code section'
    end
    Languages.each do |name, script, title|
      if name == @arguments
        @script = script
        @title = title
        return
      end
    end
    error "Unknown programming language: #{@arguments}"
  end

  def html
    output = @title == nil ? '' : "<span class=\"codeTitle\">#{@title}</span>\n"
    output += WWWLib.getHighlightedList(@script, childHTML)
    return output
  end

  def latex
    return latexEnvironment('lstlisting')
  end
end

class LaTeXMath < Function
  def setup
    @centered = false
  end

  def html
    if @children.empty? || @children.size != 1 || @children.first.class != String
      @document.error 'Invalid content in a math function'
    end
    latex = @children.first
    hash = Digest::SHA256.hexdigest(latex)
    imagePath = "images/#{hash}.png"
    fullImagePath = Nil.joinPaths(@document.outputDirectory, imagePath)
    LaTeX.generateImage(latex, 'temporary', fullImagePath)
    classString = @centered ? 'class="centeredMath" ' : ''
    imageMarkup = "<img src=\"#{imagePath}\" #{classString}alt=\"#{@document.escapeString(latex, :html)}\" />"
    return imageMarkup
  end

  def latex
    return @centered ? "$$#{childLaTeX}$$" : "$#{childLaTeX}$"
  end
end

class CenteredLaTeXMath < LaTeXMath
  def setup
    @centered = true
  end
end

class Link < Function
  def html
    description = childHTML
    if @arguments == nil
      link = description
    else
      link = @arguments
    end
    return "<a href=\"#{link}\">#{description}</a>"
  end

  def latex
    if @arguments == nil
      return "\\url{#{childLaTeX}}"
    else
      return "\\href{#{@arguments}}{#{childLaTeX}}"
    end
  end
end
