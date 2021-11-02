require_relative 'manufacturer'

class Vagon
  include Manufacturer

  attr_reader :type

  def initialize(type)
    @type = type
  end
  
end