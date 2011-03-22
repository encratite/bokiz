require_relative 'Function'

class BoldText < Function
  def html
    return "<b>#{childHTML}</b>"
  end

  def latex
    return "\\textbf#{childLaTeX}"
  end
end
