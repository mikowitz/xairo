defmodule Xairo.TextExtents do
  @moduledoc """
  Module for modeling the extents of a specific text based on the current "toy" font family.
  """

  defstruct [:x_bearing, :y_bearing, :width, :height, :x_advance, :y_advance]

  def from_nif(m) when is_map(m), do: struct(__MODULE__, m)
end
