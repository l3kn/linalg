require "minitest/autorun"
require "../src/linalg"

module LA
  struct Vec2 < LA::AVector2
    # By default, the swizzled methods return a tuple with the values
    define_vector_swizzling(2)
  end

  struct Vec3 < LA::AVector3
    # The other valid options are to pass `:array` or a class name as the `target`
    define_vector_swizzling(3, target: :array)

    # If `signed` is set to `true`,
    # in addition to methods like `vector.xyz`
    # the macro will create “signed” methods
    # like `vector._x_y_z` or `.vector.x_zy`
    define_vector_swizzling(2, target: Vec2, signed: true)
  end

  class SwizzlingSpec < Minitest::Test
    def test_tuple_swizzling
      a = Vec2.new(1.0, 2.0)
      assert_equal a.xy, {1.0, 2.0}
      assert_equal a.yy, {2.0, 2.0}
    end

    def test_array_swizzling
      a = Vec3.new(1.0, 2.0, 3.0)
      assert_equal a.yyy, [2.0, 2.0, 2.0]
      assert_equal a.zyx, [3.0, 2.0, 1.0]

      assert_equal a._x_y, Vec2.new(-1.0, -2.0)
      assert_equal a._y_y, Vec2.new(-2.0, -2.0)
    end
  end
end
