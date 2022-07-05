defmodule Xairo.TextExtents do
  @moduledoc """
  Models the extents for a string given the context's font settings
  at the time they are calculated.

  Text extents are affected by the current font face, (see `Xairo.FontFace`),
  the font size set on the context, and the font matrix set on the context.
  Because text extents are measured in userspace, they do *not* take into
  account the transformation matrix of the context itself.

  The font's extents consists of six parameters:

  * `x_bearing` - the distance from the origin to the leftmost part of the string's glyphs
  * `y_bearing` - the distance from the origin to the topmost part of the string's glyphs
  * `width` - width of the string as drawn
  * `height` - height of the string as drawn
  * `x_advance` - the distance the path's current point will advance along the X-axis after drawing the string
  * `y_advance` - the distance the path's current point will advance along the Y-axis after drawing the string. This will be zero for fonts written horizontally (most alphabets with the exception of some East Asian scripts).
  """

  defstruct [:x_bearing, :y_bearing, :width, :height, :x_advance, :y_advance, :text]

  @type t :: %__MODULE__{
          x_bearing: number(),
          y_bearing: number(),
          width: number(),
          height: number(),
          x_advance: number(),
          y_advance: number(),
          text: String.t()
        }

  alias Xairo.Image
  alias Xairo.Native, as: N

  @doc """
  Returns the extents for the text string using the context's current
  font settings.
  """
  @spec for(Image.t(), String.t()) :: Xairo.or_error(t())
  def for(%Image{context: ctx}, text) do
    with {:ok, %__MODULE__{} = extents} <- N.text_extents_text_extents(text, ctx.context),
         do: extents
  end
end
