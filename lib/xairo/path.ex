defmodule Xairo.Path do
  @moduledoc false

  alias Xairo.{Context, NIF}

  defmacro __using__(_) do
    quote do
      defdelegate new_path(ctx), to: Xairo.Path
      defdelegate new_sub_path(ctx), to: Xairo.Path
      defdelegate close_path(ctx), to: Xairo.Path
      defdelegate path_extents(ctx), to: Xairo.Path
      defdelegate has_current_point(ctx), to: Xairo.Path
      defdelegate get_current_point(ctx), to: Xairo.Path
      defdelegate move_to(ctx, x, y), to: Xairo.Path
      defdelegate rel_move_to(ctx, dx, dy), to: Xairo.Path
      defdelegate line_to(ctx, x, y), to: Xairo.Path
      defdelegate rel_line_to(ctx, dx, dy), to: Xairo.Path
      defdelegate rectangle(ctx, x, y, w, h), to: Xairo.Path
      defdelegate arc(ctx, cx, cy, r, a1, a2), to: Xairo.Path
      defdelegate arc_negative(ctx, cx, cy, r, a1, a2), to: Xairo.Path
      defdelegate curve_to(ctx, x1, y1, x2, y2, x3, y3), to: Xairo.Path
      defdelegate rel_curve_to(ctx, dx1, dy1, dx2, dy2, dx3, dy3), to: Xairo.Path
    end
  end

  import :erlang, only: [float: 1]

  @spec new_path(Context.t()) :: Xairo.maybe_ctx()
  def new_path(ctx), do: NIF.context_new_path(ctx)

  @spec new_sub_path(Context.t()) :: Xairo.maybe_ctx()
  def new_sub_path(ctx), do: NIF.context_new_sub_path(ctx)

  @spec close_path(Context.t()) :: Xairo.maybe_ctx()
  def close_path(ctx), do: NIF.close_path(ctx)

  @spec path_extents(Context.t()) :: {{float(), float()}, {float(), float()}}
  def path_extents(ctx), do: NIF.path_extents(ctx)

  @spec has_current_point(Context.t()) :: Xairo.maybe_ctx()
  def has_current_point(ctx), do: NIF.has_current_point(ctx)

  @spec get_current_point(Context.t()) :: {float(), float()}
  def get_current_point(ctx), do: NIF.get_current_point(ctx)

  @spec move_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def move_to(ctx, x, y), do: NIF.context_move_to(ctx, x * 1.0, y * 1.0)

  @spec rel_move_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def rel_move_to(ctx, dx, dy), do: NIF.context_rel_move_to(ctx, f(dx), f(dy))

  @spec line_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def line_to(ctx, x, y), do: NIF.context_line_to(ctx, x * 1.0, y * 1.0)

  @spec rel_line_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
  def rel_line_to(ctx, dx, dy), do: NIF.context_rel_line_to(ctx, f(dx), f(dy))

  @spec rectangle(Context.t(), number(), number(), number(), number()) :: Xairo.maybe_ctx()
  def rectangle(ctx, x, y, width, height) do
    NIF.context_rectangle(ctx, x * 1.0, y * 1.0, width * 1.0, height * 1.0)
  end

  @spec arc(Context.t(), number(), number(), number(), number(), number()) :: Xairo.maybe_ctx()
  def arc(ctx, xc, yc, radius, angle1, angle2) do
    NIF.context_arc(ctx, xc * 1.0, yc * 1.0, radius * 1.0, angle1 * 1.0, angle2 * 1.0)
  end

  @spec arc_negative(Context.t(), number(), number(), number(), number(), number()) ::
          Xairo.maybe_ctx()
  def arc_negative(ctx, xc, yc, radius, angle1, angle2) do
    NIF.context_arc_negative(ctx, f(xc), f(yc), f(radius), f(angle1), f(angle2))
  end

  @spec curve_to(Context.t(), number(), number(), number(), number(), number(), number()) ::
          Xairo.maybe_ctx()
  def curve_to(ctx, x1, y1, x2, y2, x3, y3) do
    NIF.context_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
  end

  @spec rel_curve_to(Context.t(), number(), number(), number(), number(), number(), number()) ::
          Xairo.maybe_ctx()
  def rel_curve_to(ctx, dx1, dy1, dx2, dy2, dx3, dy3) do
    NIF.context_rel_curve_to(ctx, f(dx1), f(dy1), f(dx2), f(dy2), f(dx3), f(dy3))
  end

  defp f(x), do: float(x)
end
