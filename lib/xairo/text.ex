# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Xairo.Text do
  @moduledoc false

  alias Xairo.{FontExtents, NIF, TextExtents}

  import Xairo.Enums, only: [enum_type: 1]

  @font_slants ~w(normal italic oblique)a
  @font_weights ~w(normal bold)a

  defmacro __using__(_) do
    quote location: :keep do
      alias Xairo.{Context, FontExtents, NIF, TextExtents}

      @font_slants unquote(@font_slants)
      @type font_slant :: unquote(enum_type(@font_slants))

      @font_weights unquote(@font_weights)
      @type font_weight :: unquote(enum_type(@font_weights))

      @doc """
      Specify the "toy" font to use for basic Xairo text setting.
      """
      @doc group: "Text"
      @spec select_font_face(Context.t(), String.t(), font_slant(), font_weight()) ::
              Xairo.maybe_ctx()
      def select_font_face(context, family, slant, weight)
          when slant in @font_slants and weight in @font_weights do
        NIF.context_select_font_face(context, family, slant, weight)
      end

      @doc """
      Sets the current font matrix to a scale by a factor of `size`, replacing 
      any font matrix previously set with `set_font_size/2` or 
      `set_font_matrix/2`. This results in a font size of `size` user space 
      units. (More precisely, this matrix will result in the font's em-square 
      being a `size x size` square in user space.)

      If text is drawn without a call to `set_font_size/2`, (nor 
      `set_font_matrix/2` nor `set_scaled_font/2`, the default font size is 10.0.
      """
      @doc group: "Text"
      @spec set_font_size(Context.t(), number()) :: Xairo.maybe_ctx()
      defdelegate set_font_size(context, size), to: Xairo.Text

      @doc """
      A drawing operator that generates the shape from `text`, rendered 
      according to the current font_face, font_size (font_matrix), and 
      font_options.

      This function first computes a set of glyphs for the string of text. 
      The first glyph is placed so that its origin is at the current point. 
      The origin of each subsequent glyph is offset from that of the previous 
      glyph by the advance values of the previous glyph.

      After this call the current point is moved to the origin of where the 
      next glyph would be placed in this same progression. That is, the 
      current point will be at the origin of the final glyph offset by its 
      advance values. This allows for easy display of a single logical string 
      with multiple calls to cairo_show_text().

      Note: This function is part of what the cairo designers call the "toy" 
      text API. It is convenient for short demos and simple programs, but it 
      is not expected to be adequate for serious text-using applications.
      """
      @doc group: "Text"
      @spec show_text(Context.t(), String.t()) :: Xairo.maybe_ctx()
      defdelegate show_text(context, text), to: Xairo.Text

      @doc """
      Adds a closed path outlining the given `text` to the `context`. If the 
      generated path is filled, it achieves a similar effect to using 
      `show_text/2`.
      """
      @doc group: "Text"
      @spec text_path(Context.t(), String.t()) :: Xairo.maybe_ctx()
      defdelegate text_path(context, text), to: Xairo.Text

      @doc """
      Gets the extents for `text`. The extents describe a user-space rectangle 
      that encloses the "inked" portion of the text, (as it would be drawn by 
      `show_text/2`.

      Note that whitespace characters do not directly contribute to the size 
      of the rectangle (`extents.width` and `extents.height`). They do 
      contribute indirectly by changing the position of non-whitespace 
      characters. In particular, trailing whitespace characters are likely to 
      not affect the size of the rectangle, though they will affect the 
      `x_advance` and `y_advance` values.
      """
      @doc group: "Text"
      @spec text_extents(Context.t(), String.t()) :: TextExtents.t()
      defdelegate text_extents(context, text), to: Xairo.Text

      @doc """
      Returns a `Xairo.FontExtents` struct for the currently selected font.
      """
      @doc group: "Text"
      @spec font_extents(Context.t()) :: FontExtents.t()
      defdelegate font_extents(context), to: Xairo.Text
    end
  end

  def set_font_size(ctx, size), do: NIF.context_set_font_size(ctx, size / 1)

  def show_text(ctx, text), do: NIF.context_show_text(ctx, text)

  def text_path(ctx, text), do: NIF.context_text_path(ctx, text)

  def text_extents(ctx, text), do: NIF.context_text_extents(ctx, text) |> TextExtents.from_nif()

  def font_extents(ctx), do: NIF.context_font_extents(ctx) |> FontExtents.from_nif()
end
