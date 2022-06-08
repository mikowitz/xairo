defmodule Xairo.SolidPattern do
  @moduledoc """
    Models a solid color in RGB(A) format that can be set as a drawing
    surface's color source.
  """

  defstruct [:pattern]

  alias Xairo.Native, as: N
  alias Xairo.Rgba

  def from_rgba(%Rgba{} = rgba) do
    %__MODULE__{
      pattern: N.solid_pattern_from_rgba(rgba)
    }
  end

  def rgba(%__MODULE__{pattern: pattern}) do
    with {:ok, rgba} <- N.solid_pattern_rgba(pattern), do: rgba
  end
end
