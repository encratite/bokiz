class Section
  attr_writer :children

  def initialize(name, id)
    @name = name
    @id = id
    @children = []
  end
end
