module LA
  macro define_vector_op(op, components)
    def {{op.id}}(other : self)
      self.new(
        {% for c in components %}
        {{c.id}} {{op.id}} other.{{c.id}},
        {% end %}
      )
    end
  end

  macro define_op(op, components, type)
    def {{op.id}}(other : {{type.id}})
      self.new(
        {% for c in components %}
        {{c.id}} {{op.id}} other,
        {% end %}
      )
    end
  end

  macro define_dot(components)
    def dot(other : self)
      {% for c in components[0..-1] %}
        {{c.id}} * other.{{c.id}} + 
      {% end %}
      {{components[-1].id}} * other.{{components[-1].id}} 
    end
  end

  macro define_length(components)
    def length
      Math.sqrt({% for c in components[0..-1] %} c * {% end %} {{components[-1].id}})
    end

    def squared_length
      {% for c in components[0..-1] %} c * {% end %} {{components[-1].id}}
    end

    def normalize
      {% if components.size == 1 %}
        self / length
      {% else %}
        self * (1.0 / length)
      {% end %}
    end
  end

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
