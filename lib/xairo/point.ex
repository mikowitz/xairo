defmodule Xairo.Point do
  @moduledoc """
  Models a point defined in userspace.
  """

  defstruct [:x, :y]

  @type t :: %__MODULE__{
          x: number(),
          y: number()
        }

  @doc """
  Returns a new point, ensuring both coordinates are stored in float form
  to allow being passed to cairo.

  ## Example

      iex> Point.new(1, 2)
      %Point{x: 1.0, y: 2.0}
  """
  @spec new(number(), number()) :: t()
  def new(x, y) do
    %__MODULE__{x: x / 1, y: y / 1}
  end

  @doc """
  Returns a `Xairo.Point` from the given argument, which can be a `Xairo.Point`
  struct or a tuple pair of `{x, y}`.

  This function is used throughout the `Xairo.Context` API to allow the shortand
  `{x, y}` when defining many points while drawing an image.

  ## Examples

      iex> Point.from(Point.new(1,2))
      %Point{x: 1.0, y: 2.0}

      iex> Point.from({3, 4.5})
      %Point{x: 3.0, y: 4.5}

  """
  @spec from(t()) :: t()
  @spec from({number(), number()}) :: t()
  def from(%__MODULE__{} = point), do: point
  def from({x, y}), do: new(x, y)
end
