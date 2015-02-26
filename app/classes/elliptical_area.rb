class EllipticalArea
  attr_writer :expansion

  def initialize(x1, y1, x2, y2, expansion = nil)
    @focalLength = Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2) / 2
    @rotationAngle = Math.atan2((y1 - y2), (x1 - x2))
    @horizontalShift = (x1 + x2) / 2
    @verticalShift = (y1 + y2) / 2
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2

    if expansion.nil?
      @expansion = @focalLength / 100
    else
      @expansion = expansion
    end

    if ((x1 - x2).abs > (y1 - y2).abs)
      @majorAxisDenominator = ((@focalLength + @expansion) ** 2) - @focalLength ** 2
      @minorAxisDenominator = (@focalLength + @expansion) ** 2
      @rotationAngle += Math::PI / 2
    else
      @majorAxisDenominator = (@focalLength + @expansion) ** 2
      @minorAxisDenominator = ((@focalLength + @expansion) ** 2) - @focalLength ** 2
    end

  end

  private
  def point_in_ellipse?(x, y)
    value = ((((x - @horizontalShift) * Math.cos(@rotationAngle) + (y - @verticalShift) * Math.sin(@rotationAngle)) ** 2) / @majorAxisDenominator) \
        + ((((x - @horizontalShift) * Math.sin(@rotationAngle) - (y - @verticalShift) * Math.cos(@rotationAngle)) ** 2) / @minorAxisDenominator)

    return value <= 1
  end

  public
  def calculate_expansion_using_point(x, y)
    t = @focalLength
    o = ((x - @horizontalShift) * Math.cos(@rotationAngle) + (y - @verticalShift) * Math.sin(@rotationAngle)) ** 2
    p = ((x - @horizontalShift) * Math.sin(@rotationAngle) - (y - @verticalShift) * Math.cos(@rotationAngle)) ** 2

    t1 = (t * t)
    t2 = (t1 * t1)
    t7 = (o * o)
    t10 = (p * p)
    t12 = Math.sqrt((t2 - 2 * o * t1 + 2 * t1 * p + t7 + 2 * o * p + t10))
    b = Array.new
    b << -t + Math.sqrt(2) * Math.sqrt(t1 + o + p + t12) / 2
    b << -t - Math.sqrt(2) * Math.sqrt(t1 + o + p + t12) / 2
    b << -t + Math.sqrt(2) * Math.sqrt(t1 + o + p - t12) / 2
    b << -t - Math.sqrt(2) * Math.sqrt(t1 + o + p - t12) / 2

    return b.max
  end

  public
  def to_s
    digits = 4
    majorAxisDenominatorString = ""
    minorAxisDenominatorString = ""

    if ((@x1 - @x2).abs > (@y1 - @y2).abs)
      majorAxisDenominatorString = "((#{@focalLength.round(digits)} + #{@expansion.round(digits)})^2 - #{@focalLength.round(digits)}^2)"
      minorAxisDenominatorString = "((#{@focalLength.round(digits)} + #{@expansion.round(digits)})^2)"
    else
      majorAxisDenominatorString = "((#{@focalLength.round(digits)} + #{@expansion.round(digits)})^2)"
      minorAxisDenominatorString = "((#{@focalLength.round(digits)} + #{@expansion.round(digits)})^2 - #{@focalLength.round(digits)}^2)"
    end

    return "Equation of the ellipse: \n1 = ((x - #{@horizontalShift.round(digits)}) * cos(#{@rotationAngle.round(digits)}) + (y - #{@verticalShift.round(digits)}) * sin(#{@rotationAngle.round(digits)}))^2 / " + majorAxisDenominatorString + " + ((x - #{@horizontalShift.round(digits)}) * sin(#{@rotationAngle.round(digits)}) - (y - #{@verticalShift.round(digits)}) * cos(#{@rotationAngle.round(digits)}))^2 / " + minorAxisDenominatorString
  end
end