require_relative 'manufacturer'
require_relative 'validation'

class Vagon
  include Manufacturer
  include Validation
  
  TYPE_PATTERN = /^cargo$|^passenger$/

  attr_reader :type

  def initialize(type, total_place)
    @number = Random.rand(100..999)
    @type = type
    @total_place = total_place
    @used_place = 0
    validate!
  end

  def used_place
    @used_place
  end

  def free_place
    @total_place - @used_place
  end

  def to_s
    "Вагон #{@number}, тип #{@type}, мест(а) #{@total_place}, мест(а) занято #{used_place}, мест(а) свободно #{free_place}"
  end

  protected

  def validate!
    raise 'Wrong vagon type' if @type !~ TYPE_PATTERN
  end
  
end