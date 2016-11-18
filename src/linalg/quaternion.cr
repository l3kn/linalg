require "./vector"

module LA
  abstract struct AQuaternion < AVector4
    def +(other : self)
      self.class.new(@x + other.x, @y + other.y, @z + other.z, @w + other.w)
    end

    def *(other : self)
      self.class.new(
        @x*other.x - @y*other.y - @z*other.z - @w*other.w,
        @x*other.y + @y*other.x + @z*other.w - @w*other.z,
        @x*other.z + @z*other.x + @w*other.y - @y*other.w,
        @x*other.w + @w*other.x + @y*other.z - @z*other.y,
      )
    end
  end

  struct Quaternion < AQuaternion; end
end
