require_relative 'manufacturer'
require_relative 'validation'

class Vagon
  include Manufacturer
  include Validation
  
  TYPE_PATTERN = /^cargo$|^passenger$/

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  protected

  def validate!
    raise 'Wrong vagon type' if @type !~ TYPE_PATTERN
  end
  
end