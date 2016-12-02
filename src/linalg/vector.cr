require "./macros/vector"
require "./macros/swizzling"

module LA
  abstract struct AVector1
    COMPONENTS = [:x]
    define_vector
  end

  struct Vector1 < AVector1
  end

  abstract struct AVector2
    COMPONENTS = [:x, :y]
    define_vector
  end

  struct Vector2 < AVector2
  end

  abstract struct AVector3
    COMPONENTS = [:x, :y, :z]
    define_vector

    def cross(other : self)
      self.class.new(
        @y * other.z - @z * other.y,
        @z * other.x - @x * other.z,
        @x * other.y - @y * other.x
      )
    end
  end

  struct Vector3 < AVector3
  end

  abstract struct AVector4
    COMPONENTS = [:x, :y, :z, :w]
    define_vector
  end

  struct Vector4 < AVector4
  end
end
