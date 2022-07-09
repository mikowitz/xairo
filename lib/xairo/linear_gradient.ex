defmodule Xairo.LinearGradient do
  @moduledoc """
  Models a linear griadent that can be set as a surface's color source.

  A linear gradient requires 3 pieces of data:

  * two `Xairo.Point` structs that define the line along which the
  gradient is drawn
  * a list of pairs of of an offset value and `Xairo.Rgba` color, defining the color stops along the gradient's path

  ### Color stops

  Every color stop defines a point along the gradient's path where the associated color
  will be rendered. Between twe color stops, their respective colors are interpolated to
  provide a smooth transition from one to the other.

  The offset values are given as floats in the range [0, 1], where 0 is the location of the starting
  point defined for the gradient, and 1 is the location of the ending point.

  ## Example

  This example defines a simple gradient that runs from the top of an image to the bottom,
  and transitions from red at the top to blue at the bottom.

  First, we define the gradient with its start and stop points

  ```
  gradient = LinearGradient.new(
    Point.new(0, 0),  # starting point
    Point.new(0, 100) # stopping point
  )
  ```

  then we add a color stop at the beginning of the line with the color red

  ```
  gradient = LinearGradient.add_color_stop(
    gradient,
    0,                  # position along the gradient's line (will be stored as 0.0, or 0%)
    RGBA.new(255, 0, 0) # color
  )
  ```

  and a color stop at the end of the line with the color blue

  ```
  gradient = LinearGradient.add_color_stop(
    gradient,
    1,                  # position along the gradient's line (will be stored as 1.0, or 100%)
    RGBA.new(0, 0, 255) # color
  )
  ```

  Then we can use that gradient as the color source via

  ```
  Context.set_source(context, gradient)
  ```

  and any subsequent paths drawn, until the color source is changed again, will pull their color at every point
  from this gradient.

  ## Miscellani

  * a gradient with no color stops results in a completely transparent
    color source
  * a gradient with a single color stop set, no matter
  where on the path, will result in a solid color source
  """
  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.{Point, Rgba}

  @type color_stop :: {number(), Rgba.t()}

  @typedoc """
  The Elixir model of a linear gradient. Stores a reference to the in-memory
  native representation of the gradient.
  """
  @type t :: %__MODULE__{
          pattern: reference()
        }

  @doc """
  Initializes a linear gradient from the given points.

  ## Example

  This creates a horizontal linear gradient across the center of an image.

      iex> LinearGradient.new(
      ...>   Point.new(0, 50),
      ...>   Point.new(100, 50)
      ...> )

  """
  @spec new(Point.t(), Point.t()) :: __MODULE__.t()
  def new(%Point{} = start, %Point{} = stop) do
    %__MODULE__{
      pattern: N.linear_gradient_new(start, stop)
    }
  end

  @doc """
  Returns the definitions for the start and stop points of the gradient.

  ## Example

      iex> gradient = LinearGradient.new(Point.new(10, 10), Point.new(100, 100))
      iex> LinearGradient.linear_points(gradient)
      {%Point{ x: 10.0, y: 10.0 }, %Point{ x: 100.0, y: 100.0 }}
  """
  @spec linear_points(__MODULE__.t()) :: {Point.t(), Point.t()}
  def linear_points(%__MODULE__{pattern: pattern}) do
    with {:ok, points} <- N.linear_gradient_linear_points(pattern), do: points
  end

  @doc """
  Returns the number of color stops currently set on the gradient

  ## Example

      iex> gradient = LinearGradient.new(Point.new(0, 50), Point.new(100, 50))
      ...> |> LinearGradient.add_color_stop(0.5, Rgba.new(0,0,0))
      ...> |> LinearGradient.add_color_stop(0.2, Rgba.new(0, 0, 1, 0.5))
      iex> LinearGradient.color_stop_count(gradient)
      2

  """
  @spec color_stop_count(__MODULE__.t()) :: Xairo.or_error(integer())
  def color_stop_count(%__MODULE__{pattern: pattern}) do
    with {:ok, count} <- N.linear_gradient_color_stop_count(pattern), do: count
  end

  @doc """
  Sets a color stop on the gradient with the offset and color value passed in.
  """
  @spec add_color_stop(__MODULE__.t(), number(), Rgba.t()) :: __MODULE__.t()
  def add_color_stop(%__MODULE__{pattern: pattern} = linear_gradient, offset, %Rgba{} = rgba) do
    N.linear_gradient_add_color_stop(
      pattern,
      offset / 1,
      rgba
    )

    linear_gradient
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

    iex> gradient = LinearGradient.new(Point.new(0, 0), Point.new(100, 100))
    ...> |> LinearGradient.add_color_stop(0.5, Rgba.new(0,0,0))
    ...> |> LinearGradient.add_color_stop(0.2, Rgba.new(0, 0, 1, 0.5))
    iex> LinearGradient.color_stop_rgba(gradient, 0)
    {0.2, %Rgba{ red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5}}

  """
  @spec color_stop_rgba(__MODULE__.t(), integer()) :: Xairo.or_error(color_stop())
  def color_stop_rgba(%__MODULE__{pattern: pattern}, index) do
    with {:ok, rgba} <- N.linear_gradient_color_stop_rgba(pattern, index),
         do: rgba
  end
end
