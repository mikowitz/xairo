defmodule Xairo do
  @moduledoc """
  API for drawing operations on a Cairo context.
  """

  alias Xairo.Context
  alias Xairo.NIF

  use Xairo.Path
  use Xairo.Drawing

  use Xairo.Text

  use Xairo.Transformations

  @type maybe_ctx :: Context.t() | {:error, atom()}

  use Xairo.GraphicsState

  @doc group: "Graphics state"
  @spec set_source_rgb(Context.t(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgb(ctx, r, g, b), do: NIF.context_set_source_rgb(ctx, r * 1.0, g * 1.0, b * 1.0)

  @doc group: "Graphics state"
  @spec set_source_rgba(Context.t(), number(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgba(ctx, r, g, b, a),
    do: NIF.context_set_source_rgba(ctx, r * 1.0, g * 1.0, b * 1.0, a * 1.0)

  @doc group: "Graphics state"
  @spec save(Context.t()) :: maybe_ctx()
  def save(ctx), do: NIF.context_save(ctx)

  @doc group: "Graphics state"
  @spec restore(Context.t()) :: maybe_ctx()
  def restore(ctx), do: NIF.context_restore(ctx)
end
