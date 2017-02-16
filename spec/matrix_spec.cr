require "minitest/autorun"
require "../src/linalg"

module LA
  class MatrixTest < Minitest::Test
    def test_matrix_inversion
      # Generate a few random matrizes
      # and check if m * m.invert = id
      10.times do 
        m = Matrix4.new(
          rand, rand, rand, rand,
          rand, rand, rand, rand,
          rand, rand, rand, rand,
          rand, rand, rand, rand
        )
        res = (m * m.invert).to_a

        (0...4).each do |i|
          (0...4).each do |j|
            if i == j
              assert_in_delta res[i][j], 1.0
            else
              assert_in_delta res[i][j], 0.0
            end
          end
        end
      end
    end
  end
end
