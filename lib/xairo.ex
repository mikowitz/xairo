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

  @doc """
  Sets the source pattern within `ctx` to an opaque color. This opaque color
  will then be used for any subsequent drawing operation until a new source
  pattern is set.

  The color components are floating point numbers in the range `[0, 1]`. If
  the values passed in are outside that range, they will be clamped.

  The default source pattern is opaque black, (that is, it is equivalent to
  `set_source_rgb(ctx, 0, 0, 0)`).
  """
  @doc group: "Graphics state"
  @spec set_source_rgb(Context.t(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgb(ctx, r, g, b), do: NIF.context_set_source_rgb(ctx, r * 1.0, g * 1.0, b * 1.0)

  @doc """
  Sets the source pattern within `ctx` to a translucent color. This color will
  then be used for any subsequent drawing operation until a new source
  pattern is set.

  The color and alpha components are floating point numbers in the range
  `[0, 1]`. If the values passed in are outside that range, they will be
  clamped.

  Note that the color and alpha values are not premultiplied.

  The default source pattern is opaque black, (that is, it is equivalent to
  `set_source_rgba(ctx, 0, 0, 0, 1)`).
  """
  @doc group: "Graphics state"
  @spec set_source_rgba(Context.t(), number(), number(), number(), number()) :: maybe_ctx()
  def set_source_rgba(ctx, r, g, b, a),
    do: NIF.context_set_source_rgba(ctx, f(r), f(g), f(b), f(a))

  @doc """
  This is a convenience function for creating a pattern from surface and
  setting it as the source in `context` with `set_source/2`.

  The `x` and `y` parameters give the user-space coordinate at which the
  surface origin should appear. (The surface origin is its upper-left corner
  before any transformation has been applied.) The `x` and `y` parameters are
  negated and then set as translation values in the pattern matrix.

  Other than the initial translation pattern matrix, as described above, all
  other pattern attributes, (such as its extend mode), are set to the default
  values as in cairo_pattern_create_for_surface(). The resulting pattern can
  be queried with cairo_get_source() so that these attributes can be modified
  if desired, (eg. to create a repeating pattern with cairo_pattern_set_extend()).
  """
  @doc group: "Graphics state"
  @spec set_source_surface(Context.t(), Surface.t(), number(), number()) :: maybe_ctx()
  def set_source_surface(ctx, surface, x, y), do: NIF.set_source_surface(ctx, surface, f(x), f(y))

  @doc """
  Makes a copy of the current state of `ctx` and saves it on an internal stack
  of saved states for `ctx` . When `restore/1` is called, `ctx` will be
  restored to the saved state. Multiple calls to `save/1` and `restore/1` can
  be nested; each call to `restore/1` restores the state from the matching
  paired `save/1`.
  """
  @doc group: "Graphics state"
  @spec save(Context.t()) :: maybe_ctx()
  def save(ctx), do: NIF.context_save(ctx)

  @doc """
  Restores `ctx` to the state saved by a preceding call to `save/1` and
  removes that state from the stack of saved states.
  """
  @doc group: "Graphics state"
  @spec restore(Context.t()) :: maybe_ctx()
  def restore(ctx), do: NIF.context_restore(ctx)

  defp f(x), do: :erlang.float(x)
end
