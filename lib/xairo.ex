defmodule Xairo do
  alias Xairo.Context
  alias Xairo.NIF

  import Xairo.Enums, only: [enum_type: 1]

  @line_caps ~w(butt round square)a

  @type line_cap :: unquote(enum_type(@line_caps))

  @type maybe_ctx :: Context.t() | {:error, atom()}

  @spec set_source_rgb(Context.t(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgb(ctx, r, g, b), do: NIF.context_set_source_rgb(ctx, r * 1.0, g * 1.0, b * 1.0)

  @spec set_source_rgba(Context.t(), number(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgba(ctx, r, g, b, a),
    do: NIF.context_set_source_rgba(ctx, r * 1.0, g * 1.0, b * 1.0, a * 1.0)

  @spec set_line_width(Context.t(), number()) :: maybe_ctx()
  def set_line_width(ctx, width), do: NIF.context_set_line_width(ctx, width * 1.0)

  @spec set_line_cap(Context.t(), line_cap()) :: maybe_ctx()
  def set_line_cap(ctx, line_cap) when line_cap in @line_caps,
    do: NIF.context_set_line_cap(ctx, line_cap)

  @spec set_dash(Context.t(), [number()], number()) :: maybe_ctx()
  def set_dash(ctx, dashes, offset) do
    NIF.context_set_dash(
      ctx,
      Enum.map(dashes, &(&1 / 1)),
      offset / 1
    )
  end

  @spec move_to(Context.t(), number(), number()) :: maybe_ctx()
  def move_to(ctx, x, y), do: NIF.context_move_to(ctx, x * 1.0, y * 1.0)

  @spec rectangle(Context.t(), number(), number(), number(), number()) :: maybe_ctx()
  def rectangle(ctx, x, y, width, height) do
    NIF.context_rectangle(ctx, x * 1.0, y * 1.0, width * 1.0, height * 1.0)
  end

  @spec arc(Context.t(), number(), number(), number(), number(), number()) :: maybe_ctx()
  def arc(ctx, xc, yc, radius, angle1, angle2) do
    NIF.context_arc(ctx, xc * 1.0, yc * 1.0, radius * 1.0, angle1 * 1.0, angle2 * 1.0)
  end

  @spec curve_to(Context.t(), number(), number(), number(), number(), number(), number()) ::
          maybe_ctx()
  def curve_to(ctx, x1, y1, x2, y2, x3, y3) do
    NIF.context_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
  end

  @spec paint(Context.t()) :: maybe_ctx()
  def paint(ctx), do: NIF.context_paint(ctx)

  @spec fill(Context.t()) :: maybe_ctx()
  def fill(ctx), do: NIF.context_fill(ctx)

  @spec fill_preserve(Context.t()) :: maybe_ctx()
  def fill_preserve(ctx), do: NIF.context_fill_preserve(ctx)

  @spec stroke(Context.t()) :: maybe_ctx()
  def stroke(ctx), do: NIF.context_stroke(ctx)
end
