defmodule Xairo.Drawing do
  @moduledoc false
  alias Xairo.{Context, NIF}

  defmacro __using__(_) do
    quote do
      alias Xairo.Drawing

      defdelegate stroke(ctx), to: Drawing
      defdelegate stroke_preserve(ctx), to: Drawing
      defdelegate fill(ctx), to: Drawing
      defdelegate fill_preserve(ctx), to: Drawing
      defdelegate paint(ctx), to: Drawing
      defdelegate paint_with_alpha(ctx, a), to: Drawing
      defdelegate stroke_extents(ctx), to: Drawing
      defdelegate fill_extents(ctx), to: Drawing
      defdelegate in_stroke(ctx, x, y), to: Drawing
      defdelegate in_fill(ctx, x, y), to: Drawing
      defdelegate clip(ctx), to: Drawing
      defdelegate clip_preserve(ctx), to: Drawing
      defdelegate clip_extents(ctx), to: Drawing
      defdelegate reset_clip(ctx), to: Drawing
    end
  end

  import :erlang, only: [float: 1]

  @spec paint(Context.t()) :: Xairo.maybe_ctx()
  def paint(ctx), do: NIF.paint(ctx)

  @spec paint_with_alpha(Context.t(), number()) :: Xairo.maybe_ctx()
  def paint_with_alpha(ctx, alpha), do: NIF.paint_with_alpha(ctx, f(alpha))

  @spec fill(Context.t()) :: Xairo.maybe_ctx()
  def fill(ctx), do: NIF.fill(ctx)

  @spec fill_preserve(Context.t()) :: Xairo.maybe_ctx()
  def fill_preserve(ctx), do: NIF.fill_preserve(ctx)

  @spec stroke(Context.t()) :: Xairo.maybe_ctx()
  def stroke(ctx), do: NIF.stroke(ctx)

  @spec stroke_preserve(Context.t()) :: Xairo.maybe_ctx()
  def stroke_preserve(ctx), do: NIF.stroke_preserve(ctx)

  @spec stroke_extents(Context.t()) :: {{number(), number()}, {number(), number()}}
  def stroke_extents(ctx), do: NIF.stroke_extents(ctx)

  @spec fill_extents(Context.t()) :: {{number(), number()}, {number(), number()}}
  def fill_extents(ctx), do: NIF.fill_extents(ctx)

  @spec in_fill(Context.t(), number(), number()) :: boolean()
  def in_fill(ctx, x, y), do: NIF.in_fill(ctx, f(x), f(y))

  @spec in_stroke(Context.t(), number(), number()) :: boolean()
  def in_stroke(ctx, x, y), do: NIF.in_stroke(ctx, f(x), f(y))

  @spec clip(Context.t()) :: Xairo.maybe_ctx()
  def clip(ctx), do: NIF.clip(ctx)

  @spec clip_preserve(Context.t()) :: Xairo.maybe_ctx()
  def clip_preserve(ctx), do: NIF.clip_preserve(ctx)

  @spec reset_clip(Context.t()) :: Xairo.maybe_ctx()
  def reset_clip(ctx), do: NIF.reset_clip(ctx)

  @spec clip_extents(Context.t()) :: {{number(), number()}, {number(), number()}}
  def clip_extents(ctx), do: NIF.clip_extents(ctx)

  defp f(x), do: float(x)
end
