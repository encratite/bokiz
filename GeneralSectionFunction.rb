require_relative 'Function'
require_relative 'Section'

class GeneralSectionFunction < Function
  def processSection(tag)
    name = childHTML
    id = nameToId(name)
    container = getSectionContainer(@document.sections, @sectionDepth)
    container << Section.new(name, id)
    return "<#{tag} id=#{id.inspect}>#{name}</#{tag}>"
  end

  def nameToId(name)
    output = ''
    name.each_char do |char|
      if char.match(/[A-Za-z0-9]/)
        output += char
      end
    end
    return output
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
    return processSection(@htmlTag)
  end

  def latex
    return latexFunction(@latexFunction)
  end
end
