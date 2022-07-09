defmodule Xairo.RadialGradient do
  @moduledoc """
  Models a radial gradient that can be set as a drawing surface's
  color source.

  A radial gradient requires two pieces of data:

  * two circles, each defined by a center coordinate and radius in userspace,
  defining the radial along which the gradient is drawn
  * a list of pairs of an offset value and `Xairo.Rgba` color, defining the
  color stops along the gradient's path.

  ### Color stops

  Every color stop defines a point along the gradient's path where the associated color
  will be rendered. Between twe color stops, their respective colors are interpolated to
  provide a smooth transition from one to the other.

  The offset values are given as floats in the range [0, 1], where 0 is the location of the starting
  circle defined for the gradient, and 1 is the location of the ending circle.

  ## Example

  This example defines a simple radial gradient that radiates from the center of a 100x100
  image to the outer edges, starting purple at the center and transitioning to
  blue at the outer edges.

  First we create the gradient with the center and radius values for its starting
  and ending circles

  ```
  gradient = RadialGradient.new(
    Point.new(50, 50), 10, # starting circle, centered with a radius of 10
    Point.new(50, 50), 80  # ending circle, centered with a radius of 80
  )
  ```

  then we add the inner purple color stop

  ```
  gradient = RadialGradient.add_color_stop(
    0,                   # position along the gradient's radius (will be stored as 0.0, or 0%)
    Rgba.new(0.5, 0, 1), # color
  )
  ```

  and the outer blue color stop

  ```
  gradient = RadialGradient.add_color_stop(
    1,                # position along the gradient's radius (will be stored as 1.0, or 100%)
    Rgba.new(0, 0, 1) # color
  )
  ```

  Then we can use that gradient as the color source via

  ```
  Context.set_source(context, gradient)
  ```

  and any subsequent paths drawn, until the color source is changed again, will pull their
  color at every point from this gradient.

  ## Miscellani

  * a gradient with no color stops results in a completely transparent color source
  * a gradient with a single color stop set, no matter where on the path, will result in a solid color source
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.{Point, Rgba}

  @type circle :: {Point.t(), number()}
  @type color_stop :: {number(), Rgba.t()}

  @typedoc """
  The Elixir model of a linear gradient. Stores a reference to the in-memory
  native representation of the gradient.
  """
  @type t :: %__MODULE__{
          pattern: reference()
        }

  @doc """
  Initializes a radial gradient from the given circle definitions.

  ## Example

  This creates a small radial gradient in the upper left hand corner of an image.

      iex> RadialGradient.new(
      ...>   Point.new(20, 20), 2,
      ...>   Point.new(20, 20), 20
      ...> )

  """
  @spec new(Point.t(), number(), Point.t(), number) :: __MODULE__.t()
  def new(%Point{} = start, start_radius, %Point{} = stop, stop_radius) do
    %__MODULE__{
      pattern: N.radial_gradient_new(start, start_radius / 1, stop, stop_radius / 1)
    }
  end

  @doc """
  Returns the definitions for the start and stop circles of the gradient.

  ## Example

      iex> gradient = RadialGradient.new(Point.new(10, 10), 20, Point.new(50, 50), 30)
      iex> RadialGradient.radial_circles(gradient)
      {{%Point{ x: 10.0, y: 10.0 }, 20.0}, {%Point{ x: 50.0, y: 50.0 }, 30.0}}
  """
  @spec radial_circles(__MODULE__.t()) :: Xairo.or_error({circle(), circle()})
  def radial_circles(%__MODULE__{pattern: pattern}) do
    with {:ok, circles} <- N.radial_gradient_radial_circles(pattern), do: circles
  end

  @doc """
  Returns the number of color stops currently set on the gradient

  ## Example

      iex> gradient = RadialGradient.new(Point.new(50, 50), 10, Point.new(50, 50), 80)
      ...> |> RadialGradient.add_color_stop(0.5, Rgba.new(0,0,0))
      ...> |> RadialGradient.add_color_stop(0.2, Rgba.new(0, 0, 1, 0.5))
      iex> RadialGradient.color_stop_count(gradient)
      2

  """
  @spec color_stop_count(__MODULE__.t()) :: Xairo.or_error(integer())
  def color_stop_count(%__MODULE__{pattern: pattern}) do
    with {:ok, count} <- N.radial_gradient_color_stop_count(pattern), do: count
  end

  @doc """
  Sets a color stop on the gradient with the offset and color value passed in.
  """
  @spec add_color_stop(__MODULE__.t(), number(), Rgba.t()) :: __MODULE__.t()
  def add_color_stop(%__MODULE__{pattern: pattern} = radial_gradient, offset, %Rgba{} = rgba) do
    N.radial_gradient_add_color_stop(pattern, offset / 1, rgba)
    radial_gradient
  end

  @doc """
  Returns the color stop at the given index in the list of color stops defined
  for the gradient, or an error if no color stop exists at the index.

  The index is an integer index into the list of color stops, not the offset
  of the color stop. This list is sorted internally by the value of the offset,
  not the order in which the color stops are added to the gradient.

  ## Example

  In this example, even though the color at offset 0.2 was added second, because
  its offset is lower than the first added color stop, it is stored at index 0
  when the list of color stops is queried.

    iex> gradient = RadialGradient.new(Point.new(50, 50), 10, Point.new(50, 50), 80)
    ...> |> RadialGradient.add_color_stop(0.5, Rgba.new(0,0,0))
    ...> |> RadialGradient.add_color_stop(0.2, Rgba.new(0, 0, 1, 0.5))
    iex> RadialGradient.color_stop_rgba(gradient, 0)
    {0.2, %Rgba{ red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5}}

  """
  @spec color_stop_rgba(__MODULE__.t(), integer()) :: Xairo.or_error(color_stop())
  def color_stop_rgba(%__MODULE__{pattern: pattern}, index) do
    with {:ok, rgba} <- N.radial_gradient_color_stop_rgba(pattern, index),
         do: rgba
  end
end
