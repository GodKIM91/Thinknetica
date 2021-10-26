class Route
  attr_reader :first_point, :last_point

  def initialize(first_point, last_point)
    @first_point = first_point
    @last_point = last_point
    @between_points = []
  end

  def add_between_point(point)
    @between_points << point
  end

  def delete_between_point(point)
    @point.delete(point)
  end

  def route_points
    [first_point] + @between_points + [last_point]
  end

  def to_s
    "Маршрут: #{first_point} - #{last_point}"
  end
end