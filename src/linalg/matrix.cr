require "./matrix/gauss_jordan"

macro define_matrix
  # Use the same trick as before (in the vector macros)
  # to create a list of variables like (in the case of DIM = 2)
  # v00, v01, v10, v11
  {% components = (0...(DIM**2)).map { |v| "a#{v / DIM}#{v % DIM}" } %}

  # Define properties for all components
  {% for c in components %}
  property {{c.id}} : Float64
  {% end %}

  def initialize
    {% for c in components %}
      {{"@#{c.id}".id}} = 0.0
    {% end %}
  end

  def initialize({{ components.map { |c| "@#{c.id}" }.join(", ").id }})
  end

  {% transposed_components = (0...(DIM**2)).map { |v| "a#{v % DIM}#{v / DIM}" } %}
  def transpose
    self.class.new(
      {{ transposed_components.join(" ,").id }}
    )
  end

  def invert
    GaussJordan.invert(self)
  end

  def *(other : self)
    self.class.new(
    {% for i in (0...DIM) %}
      {% for j in (0...DIM) %}
        {%
          own_components = (0...DIM).map { |j_| "a#{i}#{j_}".id }
          other_components = (0...DIM).map { |i_| "other.a#{i_}#{j}".id }
          full_components = (0...DIM).map { |x| "#{own_components[x]}*#{other_components[x]}" }.join(" + ")
        %}
        {{full_components.id}},
      {% end %}
    {% end %}
    )
  end

  def to_a
    [
      {% for i in (0...DIM) %}
        [
        {% for j in (0...DIM) %}
          {{"a#{i}#{j}".id}},
        {% end %}
        ],
      {% end %}
    ]
  end

  def self.from_a(array)
    self.new(
    {% for i in (0...DIM) %}
      {% for j in (0...DIM) %}
        {{"array[#{i}][#{j}]".id}}{{ i != (DIM-1) || j != (DIM-1) ? ",".id : ")".id}}
      {% end %}
    {% end %}
  end
end

macro define_matrix_vector_multiplication(other_class = LA::Vector3, other_components = [:x, :y, :z])
  def *(other : {{other_class.id}})
    {{other_class.id}}.new(
    {% for i in (0...DIM) %}
      {%
        own_components = (0...DIM).map { |j_| "a#{i}#{j_}".id }
        other_components_ = (0...DIM).map { |i_| "other.#{other_components[i_].id}".id }
        full_components = (0...DIM).map { |x| "#{own_components[x]}*#{other_components_[x]}" }.join(" + ")
      %}
      {{full_components.id}},
    {% end %}
    )
  end
end

macro define_matrix_op(op, other_class = Float64, result_class = self.class)
  def {{op.id}}(other : {{other_class.id}})
    {% components = (0...(DIM**2)).map { |v| "a#{v / DIM}#{v % DIM}" } %}
    {{result_class.id}}.new(
      {{ components.map { |c| "#{c.id} #{op.id} other" }.join(", ").id }}
    )
  end
end

module LA
  abstract struct AMatrix3
    DIM = 3
    define_matrix
    define_matrix_vector_multiplication
    define_matrix_op(:*)

    def /(other : Float64)
      self * (1.0 / other)
    end
  end

  struct Matrix3 < AMatrix3
  end

  abstract struct AMatrix4
    DIM = 4
    define_matrix
    define_matrix_vector_multiplication
    define_matrix_op(:*)

    def dimension
      DIM
    end

    def /(other : Float64)
      self * (1.0 / other)
    end
  end

  struct Matrix4 < AMatrix4
  end
end
