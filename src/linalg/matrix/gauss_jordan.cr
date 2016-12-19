module LA::GaussJordan
  def self.swap_rows(array, r1, r2)
    tmp = array[r1]
    array[r1] = array[r2]
    array[r2] = tmp
  end

  def self.invert(matrix)
    dim = matrix.dimension

    indxc = Array(Int32).new(dim, 0)
    indxr = Array(Int32).new(dim, 0)
    ipiv  = Array(Int32).new(dim, 0)

    inverse = matrix.to_a

    (0...dim).each do |i|
      irow = 0
      icol = 0
      big = 0.0

      # Chose pivot
      (0...dim).each do |j|
        if ipiv[j] != 1
          (0...dim).each do |k|
            if ipiv[k] == 0
              if inverse[j][k].abs >= big
                big = inverse[j][k].abs
                irow = j
                icol = k
              end
            elsif ipiv[k] > 1
              raise "Singular Matrix"
            end
          end
        end
      end

      ipiv[icol] += 1

      swap_rows(inverse, irow, icol) if irow != icol

      indxr[i] = irow
      indxc[i] = icol

      raise "Singular Matrix" if inverse[icol][icol] == 0.0

      # set A[icol, icol] to one by scaling row `icol` appropriately
      pivinv = 1.0 / inverse[icol][icol]
      (0...dim).each do |j|
        inverse[icol][j] = inverse[icol][j] * pivinv
      end

      # subtract this row from others to zero out their columns
      (0...dim).each do |j|
        if j != icol
          save = inverse[j][icol]
          inverse[j][icol] = 0.0

          (0...dim).each do |k|
            inverse[j][k] = inverse[j][k] - inverse[icol][k] * save
          end
        end
      end
    end

    # swap columns to reflect permutation
    (0...dim).reverse_each do |j|
      if indxr[j] != indxc[j]
        (0...dim).each do |k|
          tmp = inverse[k][indxr[j]]
          inverse[k][indxr[j]] = inverse[k][indxc[j]]
          inverse[k][indxc[j]] = tmp
        end
      end
    end

    matrix.class.from_a(inverse)
  end
end
