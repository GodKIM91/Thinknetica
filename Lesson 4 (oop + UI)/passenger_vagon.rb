require_relative 'vagon'

class PassengerVagon < Vagon

  def initialize(total_place)
    super('passenger', total_place)
  end

  def book_seat
    @used_place += 1
  end

end