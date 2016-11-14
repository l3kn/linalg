macro define_vector_op(op, components)
  def {{op.id}}(other : {{@type}})
    {{@type}}.new(
      {% for c in components %}
      {{c.id}} {{op.id}} other.{{c.id}},
      {% end %}
    )
  end
end

macro define_op(op, components, type)
  def {{op.id}}(other : {{type.id}})
    {{@type}}.new(
      {% for c in components %}
      {{c.id}} {{op.id}} other,
      {% end %}
    )
  end
end

macro define_dot(components)
  def dot(other : {{@type}})
    {% for c in components[0..-1] %}
      {{c.id}} * other.{{c.id}} + 
    {% end %}
    {{components[-1].id}} * other.{{components[-1].id}} 
  end
end

macro define_length(components)
  def length
    Math.sqrt({% for c in components[0..-1] %} {{c.id}} * {% end %} {{components[-1].id}})
  end

  def squared_length
    {% for c in components[0..-1] %} {{c.id}} * {% end %} {{components[-1].id}}
  end

  def normalize
    {% if components.size == 1 %}
      self / length
    {% else %}
      self * (1.0 / length)
    {% end %}
  end
end
