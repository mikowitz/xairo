defmodule Xairo.FontExtents do
  @moduledoc """
  Models the extents for a context's font at the time they are calculated.

  A font's extent is affected by the font's family, slant and weight
  (see `Xairo.FontFace`), the font size set on the context, and the font
  matrix set on the context. Because font extents are measured in userspace,
  they do *not* take into account the transformation matrix of the context
  itself.

  The font's extents consists of five parameters:

  * `ascent` - the distance the font extends above its baseline
  * `descent` - the distance the font extends below its baseline
  * `height` - the recommended vertical distance between the baselines of
    consecutive lines of text. It is slightly larger than `ascent` + `descent`
  * `max_x_advance` - the maximum distance along the X-axis that the origin
    might be advanced for any glyph in the font
  * `max_y_advance` - the maximum distance along the Y-axis that the origin
    might be advanced for any glyph in the font. This will be zero for fonts
    written horizontally (most alphabets with the exception of some East Asian
    scripts).

  """

  defstruct [:ascent, :descent, :height, :max_x_advance, :max_y_advance]

  @type t :: %__MODULE__{
          ascent: number(),
          descent: number(),
          height: number(),
          max_x_advance: number(),
          max_y_advance: number()
        }

  alias Xairo.Image
  alias Xairo.Native, as: N

  @doc """
  Returns the extents for the context's current font.
  """
  @spec for(Image.t()) :: Xairo.or_error(t())
  def for(%Image{context: ctx}) do
    with {:ok, %__MODULE__{} = extents} <- N.font_extents_font_extents(ctx.context),
         do: extents
  end
end
