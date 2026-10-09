defmodule Xairo.TextExtents do
  defstruct [:x_bearing, :y_bearing, :width, :height, :x_advance, :y_advance]

  def from_nif(m) when is_map(m), do: struct(__MODULE__, m)
end
