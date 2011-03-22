require_relative 'Function'
require_relative 'Section'

class GeneralSectionFunction < Function
  def processSection(tag, depth = 0)
    content = childHTML
    id = content[/[A-Za-z]/]
    @document.sections << Section.new(name, id)
    return "<#{tag} id=#{id.inspect}>#{name}</#{tag}>"
  end

  def getSectionContainer(container, remainingDepth)
    if remainingDepth == 0
      return container
    end
    if container.empty?
      @document.error 'Invalid section nesting'
    end
    return getSectionContainer(container.last.children, remainingDepth - 1)
  end

  def html
    return processSection(@htmlTag, @sectionDepth)
  end

  def latex
    return latexFunction(@latexFunction)
  end
end
