defmodule Xairo.Context do
  defstruct [:context]

  alias Xairo.Native, as: N

  def new(%{surface: surface}) do
    with {:ok, context} <- N.context_new(surface),
         do: %__MODULE__{context: context}
  end

  def set_source_rgb(%__MODULE__{context: ctx} = this, red, green, blue) do
    N.context_set_source_rgb(ctx, red / 1, green / 1, blue / 1)
    this
  end

  def set_source_rgba(%__MODULE__{context: ctx} = this, red, green, blue, alpha) do
    N.context_set_source_rgba(ctx, red / 1, green / 1, blue / 1, alpha / 1)
    this
  end

  def arc(%__MODULE__{context: ctx} = this, cx, cy, r, angle1, angle2) do
    N.context_arc(ctx, cx / 1, cy / 1, r / 1, angle1 / 1, angle2 / 1)
    this
  end

  def arc_negative(%__MODULE__{context: ctx} = this, cx, cy, r, angle1, angle2) do
    N.context_arc_negative(ctx, cx / 1, cy / 1, r / 1, angle1 / 1, angle2 / 1)
    this
  end

  def curve_to(%__MODULE__{context: ctx} = this, x1, y1, x2, y2, x3, y3) do
    N.context_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
    this
  end

  def rel_curve_to(%__MODULE__{context: ctx} = this, x1, y1, x2, y2, x3, y3) do
    N.context_rel_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
    this
  end

  def line_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_line_to(ctx, x / 1, y / 1)
    this
  end

  def rel_line_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_rel_line_to(ctx, x / 1, y / 1)
    this
  end

  def rectangle(%__MODULE__{context: ctx} = this, x, y, width, height) do
    N.context_rectangle(ctx, x / 1, y / 1, width / 1, height / 1)
    this
  end

  def move_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_move_to(ctx, x / 1, y / 1)
    this
  end

  def rel_move_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_rel_move_to(ctx, x / 1, y / 1)
    this
  end

  def close_path(%__MODULE__{context: ctx} = this) do
    N.context_close_path(ctx)
    this
  end

  def stroke(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_stroke(ctx), do: this
  end

  def stroke_preserve(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_stroke_preserve(ctx), do: this
  end

  def fill(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_fill(ctx), do: this
  end

  def paint(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_paint(ctx), do: this
  end

  def paint_with_alpha(%__MODULE__{context: ctx} = this, alpha) do
    with {:ok, _} <- N.context_paint_with_alpha(ctx, alpha / 1), do: this
  end
end
