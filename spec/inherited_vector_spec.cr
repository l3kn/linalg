require "minitest/autorun"
require "../src/linalg"

module LA
  struct Normal < LA::AVector3
    define_vector_op(:+, other_class: Normal, result_class: LA::Vector3)
    define_vector_op(:-, other_class: Normal, result_class: LA::Vector3)

    define_op(:*, result_class: LA::Vector3)
    define_op(:/, result_class: LA::Vector3)

    define_op(:*, other_class: Int32, result_class: LA::Vector3)
    define_op(:/, other_class: Int32, result_class: LA::Vector3)
  end
  class InheritedVectorTest < Minitest::Test
    def test_vector_ops
      a = Normal.new(1.0, 0.0, 0.0)
      b = Normal.new(0.0, 1.0, 0.0)

      assert_equal (a + b), LA::Vector3.new(1.0, 1.0, 0.0)
      assert_equal (a - b), LA::Vector3.new(1.0, -1.0, 0.0)
    end

    def test_ops
      a = Normal.new(1.0, 0.0, 0.0)

      assert_equal (a * 10.0), LA::Vector3.new(10.0, 0.0, 0.0)
      assert_equal (a / 10.0), LA::Vector3.new(0.1, 0.0, 0.0)
    end

    def test_other_class_ops
      a = Normal.new(1.0, 0.0, 0.0)

      assert_equal (a * 10), LA::Vector3.new(10.0, 0.0, 0.0)
      assert_equal (a / 10), LA::Vector3.new(0.1, 0.0, 0.0)
    end
  end
end
