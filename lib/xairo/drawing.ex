# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Xairo.Drawing do
  @moduledoc false
  alias Xairo.{Context, NIF}

  defmacro __using__(_) do
    quote location: :keep do
      alias Xairo.Drawing

      @doc """
      A drawing operator that strokes the current path according to the
      current line width, line join, line cap, and dash settings. After
      `stroke/1`, the current path will be cleared from the
      `Xairo.Context`. See `set_line_width/2`, `set_line_join/2`,
      `set_line_cap/2`, `set_dash/3`, and `stroke_preserve/1`.

      Note: Degenerate segments and sub-paths are treated specially and
      provide a useful result. These can result in two different
      situations:

      1. Zero-length "on" segments set in `set_dash/3`. If the cap
      style is `:round` or `:square` then these segments will be drawn as
      circular dots or squares respectively. In the case of `:square`,
      the orientation of the squares is determined by the direction of
      the underlying path.

      2. A sub-path created by `move_to/3` followed by either a
      `close_path/1` or one or more calls to `line_to/3` to the
      same coordinate as the `move_to/3`. If the cap style is
      `:round` then these sub-paths will be drawn as circular dots.
      Note that in the case of `:square` a degenerate
      sub-path will not be drawn at all, (since the correct orientation
      is indeterminate).

      In no case will a cap style of `:butt` cause anything to be drawn in
      the case of either degenerate segments or sub-paths.
      """
      @doc group: "Drawing"
      @spec stroke(Context.t()) :: Xairo.maybe_ctx()
      defdelegate stroke(ctx), to: Drawing

      @doc """
      A drawing operator that strokes the current path according to the
      current line width, line join, line cap, and dash settings. Unlike
      `stroke/1`, `stroke_preserve/1` preserves the path within the
      `Xairo.Context`.

      See `set_line_width/2`, `set_line_join/2`, `set_line_cap/2`, `set_dash/3`,
      and `stroke/1`.
      """
      @doc group: "Drawing"
      @spec stroke_preserve(Context.t()) :: Xairo.maybe_ctx()
      defdelegate stroke_preserve(ctx), to: Drawing

      @doc """
      A drawing operator that fills the current path according to the
      current fill rule, (each sub-path is implicitly closed before being
      filled). After `fill/1`, the current path will be cleared from
      the `Xairo.Context`. See `set_fill_rule/2` and `fill_preserve/1`.
      """
      @doc group: "Drawing"
      @spec fill(Context.t()) :: Xairo.maybe_ctx()
      defdelegate fill(ctx), to: Drawing

      @doc """
      A drawing operator that fills the current path according to the
      current fill rule, (each sub-path is implicitly closed before being
      filled). Unlike `fill/1`, `fill_preserve/1` preserves the
      path within the `Xairo.Context`.

      See `set_fill_rule/2` and `fill/1`.
      """
      @doc group: "Drawing"
      @spec fill_preserve(Context.t()) :: Xairo.maybe_ctx()
      defdelegate fill_preserve(ctx), to: Drawing

      @doc """
      A drawing operator that paints the current source everywhere within
      the current clip region.
      """
      @doc group: "Drawing"
      @spec paint(Context.t()) :: Xairo.maybe_ctx()
      defdelegate paint(ctx), to: Drawing

      @doc """
      A drawing operator that paints the current source everywhere within
      the current clip region using a mask of constant alpha value
      `alpha`. The effect is similar to `paint/1`, but the drawing
      is faded out using the alpha value.

      `alpha` should be between 0 (transparent) and 1 (opaque).
      """
      @doc group: "Drawing"
      @spec paint_with_alpha(Context.t(), number()) :: Xairo.maybe_ctx()
      defdelegate paint_with_alpha(ctx, alpha), to: Drawing

      @doc """
      Computes a bounding box in user coordinates covering the area that
      would be affected, (the "inked" area), by a `stroke/1`
      operation given the current path and stroke parameters.
      If the current path is empty, returns an empty rectangle `{{0, 0}, {0, 0}}`.
      Surface dimensions and clipping are not taken into account.

      The bounding box is returned as `{{x1, y1}, {x2, y2}}`, where
      `{x1, y1}` is the top left and `{x2, y2}` is the bottom right of
      the resulting extents.

      Note that if the line width is set to exactly zero, then
      `stroke_extents/1` will return an empty rectangle. Contrast with
      `path_extents/1` which can be used to compute the non-empty
      bounds as the line width approaches zero.

      Note that `stroke_extents/1` must necessarily do more work to
      compute the precise inked areas in light of the stroke parameters,
      so `path_extents/1` may be more desirable for sake of
      performance if non-inked path extents are desired.

      See `stroke/1`, `set_line_width/2`, `set_line_join/2`,
      `set_line_cap/2`, `set_dash/3`, and `stroke_preserve/1`.
      """
      @doc group: "Drawing"
      @spec stroke_extents(Context.t()) :: {{float(), float()}, {float(), float()}}
      defdelegate stroke_extents(ctx), to: Drawing

      @doc """
      Computes a bounding box in user coordinates covering the area that
      would be affected, (the "inked" area), by a `fill/1` operation
      given the current path and fill parameters. If the current path is
      empty, returns an empty rectangle `{{0, 0}, {0, 0}}`. Surface
      dimensions and clipping are not taken into account.

      The bounding box is returned as `{{x1, y1}, {x2, y2}}`, where
      `{x1, y1}` is the top left and `{x2, y2}` is the bottom right of
      the resulting extents.

      Contrast with `path_extents/1`, which is similar, but returns
      non-zero extents for some paths with no inked area, (such as a
      simple line segment).

      Note that `fill_extents/1` must necessarily do more work to
      compute the precise inked areas in light of the fill rule, so
      `path_extents/1` may be more desirable for sake of performance
      if the non-inked path extents are desired.

      See `fill/1`, `set_fill_rule/2` and `fill_preserve/1`.
      """
      @doc group: "Drawing"
      @spec fill_extents(Context.t()) :: {{float(), float()}, {float(), float()}}
      defdelegate fill_extents(ctx), to: Drawing

      @doc """
      Tests whether the given point is inside the area that would be
      affected by a `stroke/1` operation given the current path and
      stroking parameters. Surface dimensions and clipping are not taken
      into account.

      Returns `true` if the point is inside, or `false` if outside.

      See `stroke/1`, `set_line_width/2`, `set_line_join/2`,
      `set_line_cap/2`, `set_dash/3`, and `stroke_preserve/1`.
      """
      @doc group: "Drawing"
      @spec in_stroke(Context.t(), number(), number()) :: boolean()
      defdelegate in_stroke(ctx, x, y), to: Drawing

      @doc """
      Tests whether the given point is inside the area that would be
      affected by a `fill/1` operation given the current path and
      filling parameters. Surface dimensions and clipping are not taken
      into account.

      Returns `true` if the point is inside, or `false` if outside.

      See `fill/1`, `set_fill_rule/2` and `fill_preserve/1`.
      """
      @doc group: "Drawing"
      @spec in_fill(Context.t(), number(), number()) :: boolean()
      defdelegate in_fill(ctx, x, y), to: Drawing

      @doc """
      Establishes a new clip region by intersecting the current clip
      region with the current path as it would be filled by `fill/1`
      and according to the current fill rule (see `set_fill_rule/2`).

      After `clip/1`, the current path will be cleared from the
      `Xairo.Context`.

      The current clip region affects all drawing operations by
      effectively masking out any changes to the surface that are outside
      the current clip region.

      Calling `clip/1` can only make the clip region smaller, never
      larger. But the current clip is part of the graphics state, so a
      temporary restriction of the clip region can be achieved by
      calling `clip/1` within a `save/1`/`restore/1`
      pair. The only other means of increasing the size of the clip
      region is `reset_clip/1`.
      """
      @doc group: "Drawing"
      @spec clip(Context.t()) :: Xairo.maybe_ctx()
      defdelegate clip(ctx), to: Drawing

      @doc """
      Establishes a new clip region by intersecting the current clip
      region with the current path as it would be filled by `fill/1`
      and according to the current fill rule (see `set_fill_rule/2`).

      Unlike `clip/1`, `clip_preserve/1` preserves the path within
      the `Xairo.Context`.

      The current clip region affects all drawing operations by
      effectively masking out any changes to the surface that are outside
      the current clip region.

      Calling `clip_preserve/1` can only make the clip region smaller, never
      larger. But the current clip is part of the graphics state, so a
      temporary restriction of the clip region can be achieved by
      calling `clip_preserve/1` within a `save/1`/`restore/1`
      pair. The only other means of increasing the size of the clip
      region is `reset_clip/1`.
      """
      @doc group: "Drawing"
      @spec clip_preserve(Context.t()) :: Xairo.maybe_ctx()
      defdelegate clip_preserve(ctx), to: Drawing

      @doc """
      Tests whether the given point is inside the area that would be visible
      through the current clip, i.e. the area that would be filled by a
      `paint/1` operation.

      See `clip/1`, and `clip_preserve/1`.
      """
      @doc group: "Drawing"
      @spec in_clip(Context.t(), number(), number()) :: boolean()
      defdelegate in_clip(ctx, x, y), to: Drawing

      @doc """
      Computes a bounding box in user coordinates covering the area inside the
      current clip.

      The bounding box is returned as `{{x1, y1}, {x2, y2}}`, where
      `{x1, y1}` is the top left and `{x2, y2}` is the bottom right of
      the resulting extents.
      """
      @doc group: "Drawing"
      @spec clip_extents(Context.t()) :: {{float(), float()}, {float(), float()}}
      defdelegate clip_extents(ctx), to: Drawing

      @doc """
      Reset the current clip region to its original, unrestricted
      state. That is, set the clip region to an infinitely large shape
      containing the target surface. Equivalently, if infinity is too
      hard to grasp, one can imagine the clip region being reset to the
      exact bounds of the target surface.

      Note that code meant to be reusable should not call
      `reset_clip/1` as it will cause results unexpected by
      higher-level code which calls `clip/1`. Consider using
      `save/1` and `restore/1` around `clip/1` as a more
      robust means of temporarily restricting the clip region.
      """
      @doc group: "Drawing"
      @spec reset_clip(Context.t()) :: Xairo.maybe_ctx()
      defdelegate reset_clip(ctx), to: Drawing

      @doc """
      Gets the current clip region as a list of rectangles in user coordinates.
      Never returns `nil`.

      The status in the list may be `:clip_not_representable` to indicate that
      the clip region cannot be represented as a list of user-space rectangles.
      The status may have other values to indicate other errors.
      """
      @doc group: "Drawing"
      @spec copy_clip_rectangle_list(Context.t()) ::
              {:ok, {{float(), float()}, {float(), float()}}} | {:error, atom()}
      defdelegate copy_clip_rectangle_list(ctx), to: Drawing
    end
  end

  import :erlang, only: [float: 1]

  def paint(ctx), do: NIF.paint(ctx)

  def paint_with_alpha(ctx, alpha), do: NIF.paint_with_alpha(ctx, f(alpha))

  def fill(ctx), do: NIF.fill(ctx)

  def fill_preserve(ctx), do: NIF.fill_preserve(ctx)

  def stroke(ctx), do: NIF.stroke(ctx)

  def stroke_preserve(ctx), do: NIF.stroke_preserve(ctx)

  def stroke_extents(ctx), do: NIF.stroke_extents(ctx)

  def fill_extents(ctx), do: NIF.fill_extents(ctx)

  def in_fill(ctx, x, y), do: NIF.in_fill(ctx, f(x), f(y))

  def in_stroke(ctx, x, y), do: NIF.in_stroke(ctx, f(x), f(y))

  def clip(ctx), do: NIF.clip(ctx)

  def clip_preserve(ctx), do: NIF.clip_preserve(ctx)

  def in_clip(ctx, x, y), do: NIF.in_clip(ctx, f(x), f(y))

  def clip_extents(ctx), do: NIF.clip_extents(ctx)

  def reset_clip(ctx), do: NIF.reset_clip(ctx)

  def copy_clip_rectangle_list(ctx) do
    case NIF.copy_clip_rectangle_list(ctx) do
      {:error, _} = error ->
        error

      {:ok, list} ->
        {:ok, Enum.map(list, &Xairo.Rectangle.from_nif/1)}
    end
  end

  defp f(x), do: float(x)
end
