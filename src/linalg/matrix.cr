# require "./vector"

macro define_matrix
  # Use the same trick as before (in the vector macros)
  # to create a list of variables like (in the case of DIM = 2)
  # v00, v01, v10, v11
  {% components = (0...(DIM**2)).map { |v| "v#{v / DIM}#{v % DIM}" } %}

  # Define properties for all components
  {% for c in components %}
  property {{c.id}} : Float64
  {% end %}

  def initialize({{ components.map { |c| "@#{c.id}" }.join(", ").id }})
  end

  {% transposed_components = (0...(DIM**2)).map { |v| "v#{v % DIM}#{v / DIM}" } %}
  def transpose
    self.class.new(
      {{ transposed_components.join(" ,").id }}
    )
  end

  def *(other : self)
    self.class.new(
    {% for i in (0...DIM) %}
      {% for j in (0...DIM) %}
        {%
          own_components = (0...DIM).map { |j_| "v#{i}#{j_}".id }
          other_components = (0...DIM).map { |i_| "other.v#{i_}#{j}".id }
          full_components = (0...DIM).map { |x| "#{own_components[x]}*#{other_components[x]}" }.join(" + ")
        %}
        {{full_components.id}},
      {% end %}
    {% end %}
    )
  end
end

macro define_matrix_vector_multiplication(other_class = LA::Vector3, other_components = [:x, :y, :z])
  def *(other : {{other_class.id}})
    {{other_class.id}}.new(
    {% for i in (0...DIM) %}
      {%
        own_components = (0...DIM).map { |j_| "v#{i}#{j_}".id }
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
    {% components = (0...(DIM**2)).map { |v| "v#{v / DIM}#{v % DIM}" } %}
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
end

a = LA::Matrix3.new(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
p a * 2.0
p a / 2.0
b = LA::Matrix3.new(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
c = LA::Vector3.new(1.0, 2.0, 3.0)
p a * b
p a * c
# p a.transpose
