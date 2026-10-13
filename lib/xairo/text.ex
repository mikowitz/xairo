defmodule Xairo.Text do
  @moduledoc false

  alias Xairo.{Context, FontExtents, NIF, TextExtents}

  import Xairo.Enums, only: [enum_type: 1]

  defmacro __using__(_) do
    quote do
      defdelegate select_font_face(ctx, family, slant, weight), to: Xairo.Text
      defdelegate set_font_size(ctx, size), to: Xairo.Text
      defdelegate show_text(ctx, text), to: Xairo.Text
      defdelegate text_path(ctx, text), to: Xairo.Text
      defdelegate text_extents(ctx, text), to: Xairo.Text
      defdelegate font_extents(ctx), to: Xairo.Text
    end
  end

  @font_slants ~w(normal italic oblique)a
  @type font_slant :: unquote(enum_type(@font_slants))

  @font_weights ~w(normal bold)a
  @type font_weight :: unquote(enum_type(@font_weights))

  @spec select_font_face(Context.t(), String.t(), font_slant(), font_weight()) ::
          Xairo.maybe_ctx()
  def select_font_face(ctx, family, slant, weight)
      when slant in @font_slants and weight in @font_weights do
    NIF.context_select_font_face(ctx, family, slant, weight)
  end

  @spec set_font_size(Context.t(), number()) :: Xairo.maybe_ctx()
  def set_font_size(ctx, size), do: NIF.context_set_font_size(ctx, size / 1)

  @spec show_text(Context.t(), String.t()) :: Xairo.maybe_ctx()
  def show_text(ctx, text), do: NIF.context_show_text(ctx, text)

  @spec text_path(Context.t(), String.t()) :: Xairo.maybe_ctx()
  def text_path(ctx, text), do: NIF.context_text_path(ctx, text)

  @spec text_extents(Context.t(), String.t()) :: TextExtents.t()
  def text_extents(ctx, text), do: NIF.context_text_extents(ctx, text) |> TextExtents.from_nif()

  @spec font_extents(Context.t()) :: FontExtents.t()
  def font_extents(ctx), do: NIF.context_font_extents(ctx) |> FontExtents.from_nif()
end
