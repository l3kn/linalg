# TODO: Is there a way to implement these
# in the abstract class?

macro define_class_methods
  def self.one
    self.new(1.0)
  end

  def self.zero
    self.new(0.0)
  end

  # Generate some utility constants like
  # `Vector3::Y => Vector3(0.0, 1.0, 0.0)`
  {% for i in 0...COMPONENTS.size %}
  def self.{{COMPONENTS[i].id}}
    self.new(
      {% for j in 0...COMPONENTS.size %} {{ i == j ? 1.0 : 0.0 }}, {% end %}
    )
  end
  {% end %}
end

macro define_vector
  {% for c in COMPONENTS %}
    property {{ c.id }} : Float64
  {% end %}

  def initialize({{ COMPONENTS.map { |c| "@#{c.id}".id }.join(", ").id }})
  end

  def initialize(default = 0.0)
    {% for c in COMPONENTS %}
      @{{c.id}} = default
    {% end %}
  end

  define_vector_op(:+)
  define_vector_op(:-)
  define_unop(:-)
  define_op(:*)
  define_op(:/)
  define_dot
  define_length

  define_class_methods
end

macro define_vector_op(op, other_class = self, result_class = self.class)
  def {{op.id}}(other : {{other_class.id}})
    {{result_class.id}}.new(
      {% for c in COMPONENTS %}
        {{c.id}} {{op.id}} other.{{c.id}},
    {% end %}
    )
  end
end

macro define_op(op, other_class = Float64, result_class = self.class)
  def {{op.id}}(other : {{other_class.id}})
    {{result_class.id}}.new(
      {% for c in COMPONENTS %}
        {{c.id}} {{op.id}} other,
    {% end %}
    )
  end
end

macro define_unop(op)
  def {{op.id}}
    self.class.new(
      {% for c in COMPONENTS %}
        {{op.id}} {{c.id}},
    {% end %}
    )
  end
end

macro define_dot(other_class = self)
  def dot(other : {{other_class.id}})
    {% for c in COMPONENTS[0...-1] %}
      {{c.id}} * other.{{c.id}} + 
    {% end %}
      {{COMPONENTS[-1].id}} * other.{{COMPONENTS[-1].id}} 
  end
end

macro define_length
  def length
    Math.sqrt(
      {% for c in COMPONENTS[0...-1] %}
        {{c.id}} * {{c.id}} + 
    {% end %}
        {{COMPONENTS[-1].id}} * {{COMPONENTS[-1].id}} 
    )
  end

  def squared_length
    {% for c in COMPONENTS[0...-1] %}
      {{c.id}} * {{c.id}} + 
    {% end %}
      {{COMPONENTS[-1].id}} * {{COMPONENTS[-1].id}} 
  end

  # If the vector has just one component
  # precalculating the inverse would not improve the performance
  # TODO: validate if precalculating is faster for 2 components
  def normalize
    {% if COMPONENTS.size == 1 %}
      self / length
    {% else %}
      self * (1.0 / length)
    {% end %}
  end
end
