class Section
  attr_reader :name, :id
  attr_accessor :children

  def initialize(name, id)
    @name = name
    @id = id
    @children = []
  end
end
