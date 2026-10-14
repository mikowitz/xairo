defmodule Xairo.TextExtents do
  @moduledoc """
  `Xairo.TextExtents` stores the extents of a single glyph or a string of glyphs
  in user-space coordinates. Because text extents are in user-space coordinates,
  they are mostly, but not entirely, independent of the current transformation
  matrix. If you call [`scale(context, 2, 2)`](`Xairo.scale/3`), text will be drawn twice as big,
  but the reported text extents will not be doubled. They will change slightly
  due to hinting (so you can't assume that metrics are independent of the
  transformation matrix), but otherwise will remain unchanged.

  ## Members

  * `x_bearing`: the horizontal distance from the origin to the leftmost part of the glyphs as drawn. Positive if the glyphs lie entirely to the right of the origin.
  * `y_bearing`: the vertical distance from the origin to the topmost part of the glyphs as drawn. Positive only if the glyphs lie completely below the origin; will usually be negative.
  * `width`: width of the glyphs as drawn
  * `height`: height of the glyphs as drawn
  * `x_advance`: distance to advance in the X direction after drawing these glyphs
  * `y_advance`: distance to advance in the Y direction after drawing these glyphs. Will typically be zero except for vertical text layout as found in East-Asian languages.
  """

  defstruct [:x_bearing, :y_bearing, :width, :height, :x_advance, :y_advance]

  @type t :: %__MODULE__{
          x_bearing: float(),
          y_bearing: float(),
          width: float(),
          height: float(),
          x_advance: float(),
          y_advance: float()
        }

  @doc false
  def from_nif(m) when is_map(m), do: struct(__MODULE__, m)
end
