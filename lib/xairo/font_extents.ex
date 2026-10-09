defmodule Xairo.FontExtents do
  defstruct [:ascent, :descent, :height, :max_x_advance, :max_y_advance]

  def from_nif(m) when is_map(m), do: struct(__MODULE__, m)
end
