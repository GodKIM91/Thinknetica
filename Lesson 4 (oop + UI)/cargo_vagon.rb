require_relative 'vagon'

class CargoVagon < Vagon

  def initialize(total_place)
    super('cargo', total_place)
  end

  def reduce_place(value)
    @used_place += value
  end
  
end