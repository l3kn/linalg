struct Point1(T)
  getter x : T

  def initialize(@x)
  end
end

struct Point2(T)
  getter x : T
  getter y : T

  def initialize(@x, @y)
  end
end

struct Point3(T)
  getter x : T
  getter y : T
  getter z : T

  def initialize(@x, @y, @z)
  end
end
