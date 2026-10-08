defmodule Xairo do
  alias Xairo.Context
  alias Xairo.NIF

  import Xairo.Enums, only: [enum_type: 1]

  use Xairo.Path
  use Xairo.Drawing

  @antialiases ~w(default none gray subpixel fast good best)a
  @type antialias :: unquote(enum_type(@antialiases))

  @fill_rules ~w(winding even_odd)a
  @type fill_rule :: unquote(enum_type(@fill_rules))

  @line_caps ~w(butt round square)a
  @type line_cap :: unquote(enum_type(@line_caps))

  @line_joins ~w(miter round bevel)a
  @type line_join :: unquote(enum_type(@line_joins))

  @font_slants ~w(normal italic oblique)a
  @type font_slant :: unquote(enum_type(@font_slants))

  @operators ~w( clear source over in out atop dest dest_over dest_in dest_out dest_atop 
    xor add saturate multiply screen overlay darken lighten color_dodge color_burn 
    hard_light soft_light difference exclusion hsl_hue hsl_saturation hsl_color hsl_luminosity)a
  @type operator :: unquote(enum_type(@operators))

  @font_weights ~w(normal bold)a
  @type font_weight :: unquote(enum_type(@font_weights))

  @type maybe_ctx :: Context.t() | {:error, atom()}

  @spec set_source_rgb(Context.t(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgb(ctx, r, g, b), do: NIF.context_set_source_rgb(ctx, r * 1.0, g * 1.0, b * 1.0)

  @spec set_source_rgba(Context.t(), number(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgba(ctx, r, g, b, a),
    do: NIF.context_set_source_rgba(ctx, r * 1.0, g * 1.0, b * 1.0, a * 1.0)

  @spec set_antialias(Context.t(), antialias()) :: maybe_ctx()
  def set_antialias(ctx, antialias) when antialias in @antialiases,
    do: NIF.context_set_antialias(ctx, antialias)

  @spec get_antialias(Context.t()) :: antialias()
  def get_antialias(ctx), do: NIF.context_get_antialias(ctx)

  @spec set_fill_rule(Context.t(), fill_rule()) :: maybe_ctx()
  def set_fill_rule(ctx, fill_rule) when fill_rule in @fill_rules,
    do: NIF.context_set_fill_rule(ctx, fill_rule)

  @spec get_fill_rule(Context.t()) :: fill_rule()
  def get_fill_rule(ctx), do: NIF.context_get_fill_rule(ctx)

  @spec get_line_width(Context.t()) :: float()
  def get_line_width(ctx), do: NIF.context_get_line_width(ctx)

  @spec set_line_width(Context.t(), number()) :: maybe_ctx()
  def set_line_width(ctx, width), do: NIF.context_set_line_width(ctx, width * 1.0)

  @spec get_line_cap(Context.t()) :: line_cap()
  def get_line_cap(ctx), do: NIF.context_get_line_cap(ctx)

  @spec set_line_cap(Context.t(), line_cap()) :: maybe_ctx()
  def set_line_cap(ctx, line_cap) when line_cap in @line_caps,
    do: NIF.context_set_line_cap(ctx, line_cap)

  @spec get_line_join(Context.t()) :: line_join()
  def get_line_join(ctx), do: NIF.context_get_line_join(ctx)

  @spec set_line_join(Context.t(), line_join()) :: maybe_ctx()
  def set_line_join(ctx, line_join) when line_join in @line_joins,
    do: NIF.context_set_line_join(ctx, line_join)

  @spec get_miter_limit(Context.t()) :: float()
  def get_miter_limit(ctx), do: NIF.context_get_miter_limit(ctx)

  @spec set_miter_limit(Context.t(), number()) :: maybe_ctx()
  def set_miter_limit(ctx, width), do: NIF.context_set_miter_limit(ctx, width * 1.0)

  @spec get_tolerance(Context.t()) :: float()
  def get_tolerance(ctx), do: NIF.context_get_tolerance(ctx)

  @spec set_tolerance(Context.t(), number()) :: maybe_ctx()
  def set_tolerance(ctx, width), do: NIF.context_set_tolerance(ctx, width * 1.0)

  @spec get_dash(Context.t()) :: {[float()], float()}
  def get_dash(ctx), do: NIF.context_get_dash(ctx)

  @spec set_dash(Context.t(), [number()], number()) :: maybe_ctx()
  def set_dash(ctx, dashes, offset) do
    NIF.context_set_dash(
      ctx,
      Enum.map(dashes, &(&1 / 1)),
      offset / 1
    )
  end

  @spec get_operator(Context.t()) :: operator()
  def get_operator(ctx), do: NIF.context_get_operator(ctx)

  @spec set_operator(Context.t(), operator()) :: maybe_ctx()
  def set_operator(ctx, operator) when operator in @operators do
    NIF.context_set_operator(ctx, operator)
  end

  @spec set_font_size(Context.t(), number()) :: maybe_ctx()
  def set_font_size(ctx, size), do: NIF.context_set_font_size(ctx, size / 1)

  @spec translate(Context.t(), number(), number()) :: maybe_ctx()
  def translate(ctx, tx, ty), do: NIF.context_translate(ctx, tx / 1, ty / 1)

  @spec rotate(Context.t(), number()) :: maybe_ctx()
  def rotate(ctx, angle), do: NIF.context_rotate(ctx, angle / 1)

  @spec show_text(Context.t(), String.t()) :: maybe_ctx()
  def show_text(ctx, text), do: NIF.context_show_text(ctx, text)

  @spec save(Context.t()) :: maybe_ctx()
  def save(ctx), do: NIF.context_save(ctx)

  @spec restore(Context.t()) :: maybe_ctx()
  def restore(ctx), do: NIF.context_restore(ctx)

  @spec clip(Context.t()) :: maybe_ctx()
  def clip(ctx), do: NIF.context_clip(ctx)

  @spec reset_clip(Context.t()) :: maybe_ctx()
  def reset_clip(ctx), do: NIF.context_reset_clip(ctx)

  @spec select_font_face(Context.t(), String.t(), font_slant(), font_weight()) :: maybe_ctx()
  def select_font_face(ctx, family, slant, weight)
      when slant in @font_slants and weight in @font_weights do
    NIF.context_select_font_face(ctx, family, slant, weight)
  end
end
