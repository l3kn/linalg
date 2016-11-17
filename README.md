# LinAlg

Struct based linear algebra library

## Vectors

### Basic usage

This library includes some predefined vector structs:

* `LA::Vector1`
* `LA::Vector2`
* `LA::Vector3`
* `LA::Vector4`

These structs implement a basic set of functionality
(let's take `LA::Vector2` as an example):

``` crystal
require "linalg"
include LA # so we can use `Vector2` instead of `LA::Vector2`

# Predefined constants:
# * `COMPONENTS` (needed by the macros)
# * `ZERO`, `ONE`
# * one for each component

p Vector2::COMPONENTS # => [:x, :y]
p Vector2::ZERO       # => LA::Vector2(@x = 0.0, @y = 0.0)
p Vector2::ONE        # => LA::Vector2(@x = 1.0, @y = 1.0)
p Vector2::X          # => LA::Vector2(@x = 1.0, @y = 0.0)
p Vector2::Y          # => LA::Vector2(@x = 0.0, @y = 1.0)

a = Vector2.new(1.0, 2.0)
b = Vector2.new(3.0, 4.0)

p -b                  # => LA::Vector2(@x = -3.0, @y = -4.0)

p a + b               # => LA::Vector2(@x = 4.0, @y = 6.0)
p a - b               # => LA::Vector2(@x = -2.0, @y = -2.0)

p b.length            # => 5.0
p b.squared_length    # => 25.0

p b * 2.0             # => LA::Vector2(@x = 6.0, @y = 8.0)
p b / 2.0             # => LA::Vector2(@x = 1.5, @y = 2.0)

p a.dot(b)            # => 11.0

# The cross product is only implemented for Vector3
x = Vector3::X
y = Vector3::Y

p x.cross(y)          # => LA::Vector3(@x = 0.0, @y = 0.0, @z = 1.0)

```


### Custom Structs

Because it is (currently?)
not possible for structs to inherit from non-abstract structs
(like `LA::Vector3`), there are abstract versions of all the `VectorN` structs:

* `LA::AVector1`
* `LA::AVector2`
* `LA::AVector3`
* `LA::AVector4`

These implement all of the `VectorN` functions,
only the constanst are missing.

In fact the “implementation” von `LA::Vector3` looks like this:

``` crystal
struct Vector3 < AVector3
  define_constants(Vector3)
end
```

#### Example 1

``` crystal
require "linalg"

struct Normal < LA::AVector3
  # Usually we would need to call
  # `define_constants(Normal)` here,
  # but `ZERO` and `ONE` would make no sense,
  # because they are not 1.0 units long

  # The methods of `LA::AVectors3` are defined
  # using the following macros
  # `define_vector_op(:+)`
  # `define_vector_op(:-)`
  # `define_unop(:-)`
  # `define_op(:*)`
  # `define_op(:/)`
  # `define_dot`
  # `define_length` (defines `.length`, `.squared_length` and `.normalize`)

  # In this example, we need to overwrite some of those,
  # because the result of (e.g.) adding two normals
  # is not neccessarily a “valid” normal.
  # 
  # Luckily there are extended forms of the macros from before
  # that we can use overwrite the old methods
  # and specify a new type for the result

  define_vector_op(:+, other_class: Normal, result_class: LA::Vector3)
  define_vector_op(:-, other_class: Normal, result_class: LA::Vector3)

  define_op(:*, result_class: LA::Vector3)
  define_op(:/, result_class: LA::Vector3)

  # Additionally we could define those ops with types other than `Float64`

  define_op(:*, other_class: Int32, result_class: LA::Vector3)
  define_op(:/, other_class: Int32, result_class: LA::Vector3)
end
```

#### Example 2

Let's make an even more “custom” struct!

``` crystal
require "linalg"

# In this case we can not inherit from `LA::Vector3`,
# because our components have names other than `.x`, `.y`, `.z`.

struct Color
  COMPONENTS = [:r, :g, :b]

  define_constants(Color)
  # `define_vector` defines all the vector methods
  # (see: __Example 1__) at once
  define_vector

  # Multiplication of two vectors is not defined by default,
  # but here it is handy to blend two colors
  define_vector_op(:*)
end

red = Color::R
other = Color.new(0.8, 0.2, 0.7)

p red * other # => Color(@r=0.8, @g=0.0, @b=0.0)
```

### Swizzling

[Swizzling](https://en.wikipedia.org/wiki/Swizzling_(computer_graphics))
is not „enabled“ (the macros are not included) for the default vector structs,
but it can be included via the `define_swizzling(target_size, target = :tuple, signed = false)` macro.

``` crystal
struct Vec2 < LA::AVector2
  # By default, the swizzled methods return a tuple with the values
  define_vector_swizzling(2)
end

struct Vec3 < LA::AVector3
  # The other valid options are to pass `:array` or a class name as the `target`
  define_vector_swizzling(3, target: :array)

  # If `signed` is set to `true`,
  # in addition to methods like `vector.xyz`
  # the macro will create “signed” methods
  # like `vector._x_y_z` or `.vector.x_zy`
  define_vector_swizzling(2, target: Vec2, signed: true)
end

a = Vec2.new(1.0, 2.0)
p a.xy # => {1.0, 2.0}
p a.yx # => {2.0, 1.0}
p a.yy # => {2.0, 2.0}

b = Vec3.new(1.0, 2.0, 3.0)
p b.xxz # => [1.0, 1.0, 3.0]
p b.xy  # => Vec2(@x = 1.0, @y = 2.0)
p b._y_y  # => Vec2(@x = -2.0, @y = -2.0)
```


