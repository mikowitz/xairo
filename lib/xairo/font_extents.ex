defmodule Xairo.FontExtents do
  @moduledoc """
  Module for modeling the extents of the current "toy" font family.
  """

  defstruct [:ascent, :descent, :height, :max_x_advance, :max_y_advance]

  def from_nif(m) when is_map(m), do: struct(__MODULE__, m)
end
