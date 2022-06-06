defmodule Xairo.SolidPattern do
  @moduledoc """
    Models a solid color in RGB(A) format that can be set as a drawing
    surface's color source.
  """

  defstruct [:pattern]

  alias Xairo.Native, as: N

  def from_rgb(red, green, blue) do
    %__MODULE__{
      pattern: N.solid_pattern_from_rgb(red / 1, green / 1, blue / 1)
    }
  end

  def from_rgba(red, green, blue, alpha) do
    %__MODULE__{
      pattern: N.solid_pattern_from_rgba(red / 1, green / 1, blue / 1, alpha / 1)
    }
  end

  def rgba(%__MODULE__{pattern: pattern}) do
    with {:ok, rgba} <- N.solid_pattern_rgba(pattern), do: rgba
  end
end
