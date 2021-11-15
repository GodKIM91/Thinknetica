require_relative 'manufacturer'
require_relative 'validation'
require_relative 'accessors'

class Vagon
  include Manufacturer
  include Validation
  include Acсessors

  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  attr_reader :type, :used_place
  strong_attr_accessor :total_place, Integer

  validate :type, :format, TYPE_PATTERN

  def initialize(type, total_place)
    @number = Random.rand(100..999)
    @type = type
    @total_place = total_place
    @used_place = 0
    validate!
  end

  def free_place
    @total_place - @used_place
  end

  def to_s
    "Вагон #{@number}, тип #{@type}, мест(а) #{@total_place}, мест(а) занято #{used_place}, мест(а) свободно #{free_place}"
  end
end
