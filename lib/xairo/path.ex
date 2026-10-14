# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Xairo.Path do
  @moduledoc false

  alias Xairo.{Context, NIF}

  defmacro __using__(_) do
    quote location: :keep do
      @doc """
      Clears the current path. After this call there will be no path and
      no current point.
      """
      @doc group: "Paths"
      @spec new_path(Context.t()) :: Xairo.maybe_ctx()
      defdelegate new_path(ctx), to: Xairo.Path

      @doc """
      Begin a new sub-path. Note that the existing path is not
      affected. After this call there will be no current point.

      In many cases, this call is not needed since new sub-paths are
      frequently started with `move_to/3`.

      A call to `new_sub_path/1` is particularly useful when
      beginning a new sub-path with one of the `arc/6` calls. This
      makes things easier as it is no longer necessary to manually
      compute the arc's initial coordinates for a call to
      `move_to/3`.
      """
      @doc group: "Paths"
      @spec new_sub_path(Context.t()) :: Xairo.maybe_ctx()
      defdelegate new_sub_path(ctx), to: Xairo.Path

      @doc """
      Adds a line segment to the path from the current point to the
      beginning of the current sub-path, (the most recent point passed to
      `move_to/3`), and closes this sub-path. After this call the
      current point will be at the joined endpoint of the sub-path.

      The behavior of `close_path/1` is distinct from simply calling
      `line_to/3` with the equivalent coordinate in the case of
      stroking. When a closed sub-path is stroked, there are no caps on
      the ends of the sub-path. Instead, there is a line join connecting
      the final and initial segments of the sub-path.

      If there is no current point before the call to `close_path/1`,
      this function will have no effect.

      Note: Any call to `close_path/1` will
      place an explicit MOVE_TO element into the path immediately after
      the CLOSE_PATH element, (which can be seen in `copy_path` for
      example). This can simplify path processing in some cases as it may
      not be necessary to save the "last move_to point" during processing
      as the MOVE_TO immediately after the CLOSE_PATH will provide that
      point.
      """
      @doc group: "Paths"
      @spec close_path(Context.t()) :: Xairo.maybe_ctx()
      defdelegate close_path(ctx), to: Xairo.Path

      @doc """
      Computes a bounding box in user-space coordinates covering the
      points on the current path. If the current path is empty, returns
      an empty rectangle `{{0.0, 0.0}, {0.0, 0.0}}`. Stroke parameters, fill rule,
      surface dimensions and clipping are not taken into account.

      The bounding box is returned as `{{x1, y1}, {x2, y2}}`, where
      `{x1, y1}` is the top left and `{x2, y2}` is the bottom right of
      the resulting extents.

      Contrast with `fill_extents/1` and `stroke_extents/1` which
      return the extents of only the area that would be "inked" by
      the corresponding drawing operations.

      The result of `path_extents/1` is defined as equivalent to the
      limit of `stroke_extents/1` with a `:round` line cap as the
      line width approaches 0.0, (but never reaching the empty-rectangle
      returned by `stroke_extents/1` for a line width of 0.0).

      Specifically, this means that zero-area sub-paths such as
      `move_to/3`;`line_to/3` segments, (even degenerate cases
      where the coordinates to both calls are identical), will be
      considered as contributing to the extents. However, a lone
      `move_to/3` will not contribute to the results of
      `path_extents/1`.
      """
      @doc group: "Paths"
      @spec path_extents(Context.t()) :: {{float(), float()}, {float(), float()}}
      defdelegate path_extents(ctx), to: Xairo.Path

      @doc """
      Returns whether a current point is defined on the current path.
      See `get_current_point/1` for details on the current point.
      """
      @doc group: "Paths"
      @spec has_current_point(Context.t()) :: boolean()
      defdelegate has_current_point(ctx), to: Xairo.Path

      @doc """
      Gets the current point of the current path, which is
      conceptually the final point reached by the path so far.

      The current point is returned as an `{x, y}` tuple in the user-space
      coordinate system. If there is no defined current point or if the
      `Xairo.Context` is in an error status, `{0.0, 0.0}` will be returned.
      It is possible to check this in advance with `has_current_point/1`.

      Most path construction functions alter the current point. See the
      following for details on how they affect the current point:
      `new_path/1`, `new_sub_path/1`,
      `append_path`, `close_path/1`,
      `move_to/3`, `line_to/3`, `curve_to/7`,
      `rel_move_to/3`, `rel_line_to/3`, `rel_curve_to/7`,
      `arc/6`, `arc_negative/6`, `rectangle/5`,
      `text_path/2`, `glyph_path`.

      Some functions use and alter the current point but do not
      otherwise change current path:
      `show_text/2`.

      Some functions unset the current path and as a result, current point:
      `fill/1`, `stroke/1`.
      """
      @doc group: "Paths"
      @spec get_current_point(Context.t()) :: {float(), float()}
      defdelegate get_current_point(ctx), to: Xairo.Path

      @doc """
      Begin a new sub-path. After this call the current point will be (`x`, `y`).
      """
      @doc group: "Paths"
      @spec move_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate move_to(ctx, x, y), to: Xairo.Path

      @doc """
      Begin a new sub-path. After this call the current point will offset
      by (`dx`, `dy`).

      Given a current point of (x, y), `rel_move_to(ctx, dx, dy)`
      is logically equivalent to `move_to(ctx, x + dx, y + dy)`.

      It is an error to call this function with no current point. Doing
      so will return `{:error, :no_current_point}`.
      """
      @doc group: "Paths"
      @spec rel_move_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate rel_move_to(ctx, dx, dy), to: Xairo.Path

      @doc """
      Adds a line to the path from the current point to position (`x`, `y`)
      in user-space coordinates. After this call the current point
      will be (`x`, `y`).

      If there is no current point before the call to `line_to/3`
      this function will behave as `move_to(ctx, x, y)`.
      """
      @doc group: "Paths"
      @spec line_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate line_to(ctx, x, y), to: Xairo.Path

      @doc """
      Relative-coordinate version of `line_to/3`. Adds a line to the
      path from the current point to a point that is offset from the
      current point by (`dx`, `dy`) in user space. After this call the
      current point will be offset by (`dx`, `dy`).

      Given a current point of (x, y), `rel_line_to(ctx, dx, dy)`
      is logically equivalent to `line_to(ctx, x + dx, y + dy)`.

      It is an error to call this function with no current point. Doing
      so will return `{:error, :no_current_point}`.
      """
      @doc group: "Paths"
      @spec rel_line_to(Context.t(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate rel_line_to(ctx, dx, dy), to: Xairo.Path

      @doc """
      Adds a closed sub-path rectangle of the given size to the current
      path at position (`x`, `y`) in user-space coordinates.

      This function is logically equivalent to:

          ctx
          |> Xairo.move_to(x, y)
          |> Xairo.rel_line_to(width, 0)
          |> Xairo.rel_line_to(0, height)
          |> Xairo.rel_line_to(-width, 0)
          |> Xairo.close_path()
      """
      @doc group: "Paths"
      @spec rectangle(Context.t(), number(), number(), number(), number()) :: Xairo.maybe_ctx()
      defdelegate rectangle(ctx, x, y, width, height), to: Xairo.Path

      @doc """
      Adds a circular arc of the given `radius` to the current path. The
      arc is centered at (`xc`, `yc`), begins at `angle1` and proceeds in
      the direction of increasing angles to end at `angle2`. If `angle2` is
      less than `angle1` it will be progressively increased by
      `2 * :math.pi()` until it is greater than `angle1`.

      If there is a current point, an initial line segment will be added
      to the path to connect the current point to the beginning of the
      arc. If this initial line is undesired, it can be avoided by
      calling `new_sub_path/1` before calling `arc/6`.

      Angles are measured in radians. An angle of 0.0 is in the direction
      of the positive X axis (in user space). An angle of
      `:math.pi() / 2.0` radians (90 degrees) is in the
      direction of the positive Y axis (in user space). Angles increase
      in the direction from the positive X axis toward the positive Y
      axis. So with the default transformation matrix, angles increase in
      a clockwise direction.

      (To convert from degrees to radians, use `degrees * (:math.pi() / 180)`.)

      This function gives the arc in the direction of increasing angles;
      see `arc_negative/6` to get the arc in the direction of
      decreasing angles.

      The arc is circular in user space. To achieve an elliptical arc,
      you can scale the current transformation matrix by different
      amounts in the X and Y directions. For example, to draw an ellipse
      in the box given by `x`, `y`, `width`, `height`:

          ctx
          |> Xairo.save()
          |> Xairo.translate(x + width / 2, y + height / 2)
          |> Xairo.scale(width / 2, height / 2)
          |> Xairo.arc(0, 0, 1, 0, 2 * :math.pi())
          |> Xairo.restore()
      """
      @doc group: "Paths"
      @spec arc(Context.t(), number(), number(), number(), number(), number()) ::
              Xairo.maybe_ctx()
      defdelegate arc(ctx, xc, yc, radius, angle1, angle2), to: Xairo.Path

      @doc """
      Adds a circular arc of the given `radius` to the current path. The
      arc is centered at (`xc`, `yc`), begins at `angle1` and proceeds in
      the direction of decreasing angles to end at `angle2`. If `angle2` is
      greater than `angle1` it will be progressively decreased by
      `2 * :math.pi()` until it is less than `angle1`.

      See `arc/6` for more details. This function differs only in the
      direction of the arc between the two angles.
      """
      @doc group: "Paths"
      @spec arc_negative(Context.t(), number(), number(), number(), number(), number()) ::
              Xairo.maybe_ctx()
      defdelegate arc_negative(ctx, xc, yc, radius, angle1, angle2), to: Xairo.Path

      @doc """
      Adds a cubic Bézier spline to the path from the current point to
      position (`x3`, `y3`) in user-space coordinates, using (`x1`, `y1`) and
      (`x2`, `y2`) as the control points. After this call the current point
      will be (`x3`, `y3`).

      If there is no current point before the call to `curve_to/7`
      this function will behave as if preceded by a call to
      `move_to(ctx, x1, y1)`.
      """
      @doc group: "Paths"
      @spec curve_to(Context.t(), number(), number(), number(), number(), number(), number()) ::
              Xairo.maybe_ctx()
      defdelegate curve_to(ctx, x1, y1, x2, y2, x3, y3), to: Xairo.Path

      @doc """
      Relative-coordinate version of `curve_to/7`. All offsets are
      relative to the current point. Adds a cubic Bézier spline to the
      path from the current point to a point offset from the current
      point by (`dx3`, `dy3`), using points offset by (`dx1`, `dy1`) and
      (`dx2`, `dy2`) as the control points. After this call the current
      point will be offset by (`dx3`, `dy3`).

      Given a current point of (x, y), `rel_curve_to(ctx, dx1, dy1, dx2, dy2, dx3, dy3)`
      is logically equivalent to
      `curve_to(ctx, x + dx1, y + dy1, x + dx2, y + dy2, x + dx3, y + dy3)`.

      It is an error to call this function with no current point. Doing
      so will return `{:error, :no_current_point}`.
      """
      @doc group: "Paths"
      @spec rel_curve_to(Context.t(), number(), number(), number(), number(), number(), number()) ::
              Xairo.maybe_ctx()
      defdelegate rel_curve_to(ctx, dx1, dy1, dx2, dy2, dx3, dy3), to: Xairo.Path
    end
  end

  import :erlang, only: [float: 1]

  def new_path(ctx), do: NIF.context_new_path(ctx)

  def new_sub_path(ctx), do: NIF.context_new_sub_path(ctx)

  def close_path(ctx), do: NIF.close_path(ctx)

  def path_extents(ctx), do: NIF.path_extents(ctx)

  def has_current_point(ctx), do: NIF.has_current_point(ctx)

  def get_current_point(ctx), do: NIF.get_current_point(ctx)

  def move_to(ctx, x, y), do: NIF.context_move_to(ctx, x * 1.0, y * 1.0)

  def rel_move_to(ctx, dx, dy), do: NIF.context_rel_move_to(ctx, f(dx), f(dy))

  def line_to(ctx, x, y), do: NIF.context_line_to(ctx, x * 1.0, y * 1.0)

  def rel_line_to(ctx, dx, dy), do: NIF.context_rel_line_to(ctx, f(dx), f(dy))

  def rectangle(ctx, x, y, width, height) do
    NIF.context_rectangle(ctx, x * 1.0, y * 1.0, width * 1.0, height * 1.0)
  end

  def arc(ctx, xc, yc, radius, angle1, angle2) do
    NIF.context_arc(ctx, xc * 1.0, yc * 1.0, radius * 1.0, angle1 * 1.0, angle2 * 1.0)
  end

  def arc_negative(ctx, xc, yc, radius, angle1, angle2) do
    NIF.context_arc_negative(ctx, f(xc), f(yc), f(radius), f(angle1), f(angle2))
  end

  def curve_to(ctx, x1, y1, x2, y2, x3, y3) do
    NIF.context_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
  end

  def rel_curve_to(ctx, dx1, dy1, dx2, dy2, dx3, dy3) do
    NIF.context_rel_curve_to(ctx, f(dx1), f(dy1), f(dx2), f(dy2), f(dx3), f(dy3))
  end

  defp f(x), do: float(x)
end
