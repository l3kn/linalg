require "./vector_macros"

module LA
  struct Vector1(T)
    getter x : T

    def initialize(@x)
    end

    define_vector_op(:+, [:x])
    define_vector_op(:-, [:x])
    define_op(:*, [:x], T)
    define_dot([:x])
    define_length([:x])
  end

  struct Vector2(T)
    getter x : T
    getter y : T

    def initialize(@x, @y)
    end

    def initialize(default)
      initialize(default, default) 
    end

    define_vector_op(:+, [:x, :y])
    define_vector_op(:-, [:x, :y])
    define_op(:*, [:x, :y], T)
    define_dot([:x, :y])
    define_length([:x, :y])
  end

  struct Vector3(T)
    getter x : T
    getter y : T
    getter z : T

    def initialize(@x, @y, @z)
    end

    def initialize(default)
      initialize(default, default, default) 
    end

    define_vector_op(:+, [:x, :y, :z])
    define_vector_op(:-, [:x, :y, :z])

    define_op(:*, [:x, :y, :z], T)
    define_dot([:x, :y, :z])
    define_length([:x, :y, :z])
  end
end
