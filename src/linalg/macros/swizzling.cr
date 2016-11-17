# Define methods like `.xyz`, `.yyz`, etc
# This macro is a little bit complicated!
#
# Basically we are rebuilding
# `Array.repeated_permutations`
# using only stuff available in macros.
#
# Let's say the source vector has three components
# and the target vector has two componets.
#
# Then there are 3^2 = 9 possible swizzled methods:
# `.xx`, `.xy`, `.xz`, `.yx`, `.yy`, `.yz`, `.zx`, `.zy`, `.zz` 
#
# All these permutations can be encoded as base-n numbers
# (in the example base-3) ranging  0..(source_size ^ target_size)
# of length target_size:
#
# 00, 01, 02, 10, 11, 12, 20, 21, 22
#
# To get the "swizzled" components back,
# we need to split those numbers into target_size digits
#
# i = 5 # 12 in base-3 notation 
# digit_1 = i % source_size = 5 % 3 = 2
# digit_2 = (i / source_size) % source_size = (5 / 3) % 3 = 1 % 3 = 1
#
# If signed is true, we do a similar thing (this time encoded in binary)
# to generate all possible combinations of signs for the components
# (2^target_size in total)

macro define_vector_swizzling(target_size, target = :tuple, signed = false)
  {%
    component_permutations = (0...(COMPONENTS.size ** target_size)).map do |p|
       (0...target_size).map { |j|
         index = (p / (COMPONENTS.size ** j)) % COMPONENTS.size
         COMPONENTS[index]
       }
    end

    sign_permutations = [[0, 0, 0]]
    if signed
      sign_permutations = (0...(2 ** target_size)).map do |p|
         (0...target_size).map { |j| (p / (2 ** j)) % 2 }
      end
    end
  %}

  {%
    tags = {"#{target}.new(", ")"}
    if target == :array
      tags = {"[", "]"}
    elsif target == :tuple
      tags = {"{", "}"}
    end
  %}

  {% for components in component_permutations %}
  {% for signs in sign_permutations %}
  {%
    method_name = (0...target_size).map { |j|
      "#{(signs[j] == 1 ? "_" : "").id}#{components[j].id}"
    }.join("")

    method_body = (0...target_size).map { |j|
      "#{(signs[j] == 1 ? "-" : "").id}@#{components[j].id}"
    }.join(", ")
  %}
  def {{method_name.id}}
    {{tags[0].id}}
      {{method_body.id}}
    {{tags[1].id}}
  end
  {% end %}
  {% end %}
end
