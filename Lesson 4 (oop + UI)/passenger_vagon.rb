require_relative 'vagon'

class PassengerVagon < Vagon

  def initialize(seats)
    super('passenger')
    @seats = seats
    @free_seats = seats
  end

  def book_seat
    @free_seats -= 1
  end

  def busy_seats
    @seats - @free_seats
  end

  def free_seats
    @free_seats
  end

  def to_s
    "Вагон #{@number}, тип #{@type}, число мест #{@seats}, мест занято #{busy_seats}, мест свободно #{free_seats}"
  end

end