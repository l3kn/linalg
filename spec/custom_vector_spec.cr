require "minitest/autorun"
require "../src/linalg"

module LA
  struct Color
    COMPONENTS = [:r, :g, :b]

    define_class_methods
    # `define_vector` defines all the vector methods
    # (see: __Example 1__) at once
    define_vector

    # Multiplication of two vectors is not defined by default,
    # but here it is handy to blend two colors
    define_vector_op(:*)
  end

  class CustomVectorTest < Minitest::Test
    def test_main
      red = Color.r
      other = Color.new(0.8, 0.2, 0.7)

      assert_equal red * other, Color.new(0.8, 0.0, 0.0)
    end
  end
end


