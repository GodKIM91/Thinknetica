require_relative 'vagon'

class CargoVagon < Vagon

  def initialize(space)
    super('cargo')
    @space = space
    @free_space = space
  end

  def reduce_space(value)
    @free_space -= value
  end

  def busy_space
    @space - @free_space
  end

  def free_space
    @free_space
  end

  def to_s
    "Вагон #{@number}, тип #{@type}, объем вагона #{@space} куб.м, занятый объем #{busy_space} куб.м, свободный объем #{free_space} куб.м"
  end
  
end