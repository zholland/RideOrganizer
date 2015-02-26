require 'test/unit'
require_relative '../../app/classes/elliptical_area'

class EllipticalAreaTest < Test::Unit::TestCase
  def setup
    @ellipse1 = EllipticalArea.new(2, 2, 4, 4, 1)
    @ellipse2 = EllipticalArea.new(-10.321412, -17.296910, 9.324234, -56.123489, 5.234513)
  end

  def teardown
    @ellipse1 = nil
    @ellipse2 = nil
  end

  def test_point_in_ellipse
    assert_false(@ellipse1.send(:point_in_ellipse?, 3, 3), "Mid point of ellipse")
    assert_true(@ellipse1.send(:point_in_ellipse?, 2, 4.7), "Point near inside edge of ellipse")
    assert_false(@ellipse1.send(:point_in_ellipse?, 4, 0), "Point just outside of ellipse")

    assert_true(@ellipse2.send(:point_in_ellipse?, -19.0501, -30), "Point near inside edge of ellipse")
    assert_false(@ellipse2.send(:point_in_ellipse?, 5, -17), "Point just outside of ellipse")
  end

  def test_calculate_expansion_using_point
    assert_equal(1.4142135623730947, @ellipse1.send(:calculate_expansion_using_point, 5, 5), "Incorrect expansion")
    assert_equal(67.12363407774295, @ellipse2.send(:calculate_expansion_using_point, -80, -70), "Incorrect expansion")
  end

  def test_to_s
    assert_equal("Equation of the ellipse: \n1 = ((x - 3.0) * cos(-2.3562) + (y - 3.0) * sin(-2.3562))^2 / ((1.4142 + 1.0)^2) + ((x - 3.0) * sin(-2.3562) - (y - 3.0) * cos(-2.3562))^2 / ((1.4142 + 1.0)^2 - 1.4142^2)", @ellipse1.to_s, "Incorrect output equation")
    assert_equal("Equation of the ellipse: \n1 = ((x - -0.4986) * cos(2.0392) + (y - -36.7102) * sin(2.0392))^2 / ((21.7569 + 5.2345)^2) + ((x - -0.4986) * sin(2.0392) - (y - -36.7102) * cos(2.0392))^2 / ((21.7569 + 5.2345)^2 - 21.7569^2)", @ellipse2.to_s, "Incorrect output equation")
  end
end