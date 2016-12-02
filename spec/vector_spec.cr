require "minitest/autorun"
require "../src/linalg"

module LA
  class VectorTest < Minitest::Test
    def test_componets_for_basic_types
      assert_equal Vector1::COMPONENTS, [:x]
      assert_equal Vector2::COMPONENTS, [:x, :y]
      assert_equal Vector3::COMPONENTS, [:x, :y, :z]
      assert_equal Vector4::COMPONENTS, [:x, :y, :z, :w]
    end

    def test_constants
      assert_equal Vector3.x.x, 1.0
      assert_equal Vector3.x.y, 0.0
      assert_equal Vector3.x.z, 0.0

      assert_equal Vector3.x + Vector3.y + Vector3.z, Vector3.one
    end

    def test_length
      a = Vector3.new(1.0, 2.0, 3.0)
      assert_in_delta a.squared_length, 14.0

      b = a.normalize
      assert_in_delta b.length, 1.0
    end

    def test_random_normalize
      assert_in_delta Vector3.new(rand, rand, rand).normalize.length, 1.0
    end

    def test_arithmetic
      a = Vector2.new(1.0, 2.0)
      b = Vector2.new(1.5, 0.0)

      assert_equal (a + b), Vector2.new(2.5, 2.0)
      assert_equal ((a / 10.0) * 20.0 + b - (b + a)), a
    end

    def test_dot
      a = Vector4.new(1.0, 2.0, 3.0, 4.0)
      b = Vector4.new(2.0, 3.0, 5.0, 7.0)

      assert_equal a.dot(b), b.dot(a)
      assert_in_delta a.dot(b), 51.0 
    end

    def test_negation
      a = Vector3.new(838.11, 13.23, 234.3)

      assert_equal a, -(-a)
      assert_equal -a, a * -1.0
    end

    def test_cross_product
      a = Vector3.new(32.234, 123.1, 6.2)
      b = Vector3.new(13.56, 234.1, 7.1)

      c = a.cross(b)

      assert_in_delta a.dot(c), 0.0
      assert_in_delta b.dot(c), 0.0
    end
  end
end
