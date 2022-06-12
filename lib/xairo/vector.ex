defmodule Xairo.Vector do
  @moduledoc """
  Models a vector defined in userspace.
  """

  defstruct [:x, :y]

  @type t :: %__MODULE__{
          x: number(),
          y: number()
        }

  @doc """
  Returns a new vector, ensuring both coordinates are stored in float form
  to allow being passed to cairo.

  ## Example

      iex> Vector.new(20, 18.75)
      %Vector{x: 20.0, y: 18.75}
  """
  def new(x, y) do
    %__MODULE__{x: x / 1, y: y / 1}
  end

  @doc """
  Returns a `Xairo.Vector` from the given argument, which can be a `Xairo.Vector`
  struct or a tuple pair of `{x, y}`.

  This function is used throughout the `Xairo.Context` API to allow the shortand
  `{x, y}` when defining many points while drawing an image.

  ## Examples

      iex> Vector.from(Vector.new(1,2))
      %Vector{x: 1.0, y: 2.0}

      iex> Vector.from({3, 4.5})
      %Vector{x: 3.0, y: 4.5}

  """
  @spec from(t()) :: t()
  @spec from({number(), number()}) :: t()
  def from(%__MODULE__{} = point), do: point
  def from({x, y}), do: new(x, y)
end
