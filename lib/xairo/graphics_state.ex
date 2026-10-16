# credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
defmodule Xairo.GraphicsState do
  @moduledoc false

  import Xairo.Enums, only: [enum_type: 1]

  @antialiases ~w(default none gray subpixel fast good best)a
  @fill_rules ~w(winding even_odd)a
  @line_caps ~w(butt round square)a
  @line_joins ~w(miter round bevel)a
  @operators ~w( clear source over in out atop dest dest_over dest_in dest_out dest_atop
    xor add saturate multiply screen overlay darken lighten color_dodge color_burn
    hard_light soft_light difference exclusion hsl_hue hsl_saturation hsl_color hsl_luminosity)a

  defmacro __using__(_) do
    quote location: :keep do
      alias Xairo.{Context, NIF}

      @antialiases unquote(@antialiases)
      @type antialias :: unquote(enum_type(@antialiases))

      @fill_rules unquote(@fill_rules)
      @type fill_rule :: unquote(enum_type(@fill_rules))

      @line_caps unquote(@line_caps)
      @type line_cap :: unquote(enum_type(@line_caps))

      @line_joins unquote(@line_joins)
      @type line_join :: unquote(enum_type(@line_joins))

      @operators unquote(@operators)
      @type operator :: unquote(enum_type(@operators))

      @doc """
      Set the antialiasing mode of the rasterizer used for drawing shapes.
      This value is a hint, and a particular backend may or may not support
      a particular value. At the current time, no backend supports
      `:subpixel` when drawing shapes.

      Note that this option does not affect text rendering, instead see
      `font_options_set_antialias`.

      The available antialiasing modes are:

      * `:default` - Use the default antialiasing for the subsystem and target device
      * `:none` - Use a bilevel alpha mask
      * `:gray` - Perform single-color antialiasing (using shades of gray for
        black text on a white background, for example)
      * `:subpixel` - Perform antialiasing by taking advantage of the order of
        subpixel elements on devices such as LCD panels
      * `:fast` - Hint that the backend should perform some antialiasing but
        prefer speed over quality
      * `:good` - The backend should balance quality against performance
      * `:best` - Hint that the backend should render at the highest quality,
        sacrificing speed if necessary

      `:fast`, `:good` and `:best` make no guarantee on how the backend will
      perform its rasterisation (if it even rasterises!), nor that they have
      any differing effect other than to enable some form of antialiasing.

      The interpretation of `:default` is left entirely up to the backend,
      typically this will be similar to `:good`.
      """
      @doc group: "Graphics state"
      @spec set_antialias(Context.t(), antialias()) :: Xairo.maybe_ctx()
      def set_antialias(ctx, antialias) when antialias in @antialiases,
        do: NIF.context_set_antialias(ctx, antialias)

      @doc """
      Gets the current shape antialiasing mode, as set by `set_antialias/2`.
      """
      @doc group: "Graphics state"
      @spec get_antialias(Context.t()) :: antialias()
      def get_antialias(ctx), do: NIF.context_get_antialias(ctx)

      @doc """
      Set the current fill rule within the `Xairo.Context`. The fill rule
      is used to determine which regions are inside or outside a complex
      (potentially self-intersecting) path. The current fill rule affects
      both `fill/1` and `clip/1`.

      For both fill rules, whether or not a point is included in the fill is
      determined by taking a ray from that point to infinity and looking
      at intersections with the path. The ray can be in any direction,
      as long as it doesn't pass through the end point of a segment
      or have a tricky intersection such as intersecting tangent to the path.
      (Note that filling is not actually implemented in this way. This
      is just a description of the rule that is applied.)

      * `:winding` - If the path crosses the ray from left-to-right, counts +1.
        If the path crosses the ray from right to left, counts -1. (Left and
        right are determined from the perspective of looking along the ray from
        the starting point.) If the total count is non-zero, the point will be
        filled.
      * `:even_odd` - Counts the total number of intersections, without regard
        to the orientation of the contour. If the total number of intersections
        is odd, the point will be filled.

      The default fill rule is `:winding`.
      """
      @doc group: "Graphics state"
      @spec set_fill_rule(Context.t(), fill_rule()) :: Xairo.maybe_ctx()
      def set_fill_rule(ctx, fill_rule) when fill_rule in @fill_rules,
        do: NIF.context_set_fill_rule(ctx, fill_rule)

      @doc """
      Gets the current fill rule, as set by `set_fill_rule/2`.
      """
      @doc group: "Graphics state"
      @spec get_fill_rule(Context.t()) :: fill_rule()
      def get_fill_rule(ctx), do: NIF.context_get_fill_rule(ctx)

      @doc """
      This function returns the current line width value exactly as set by
      `set_line_width/2`. Note that the value is unchanged even if
      the CTM has changed between the calls to `set_line_width/2` and
      `get_line_width/1`.
      """
      @doc group: "Graphics state"
      @spec get_line_width(Context.t()) :: float()
      def get_line_width(ctx), do: NIF.context_get_line_width(ctx)

      @doc """
      Sets the current line width within the `Xairo.Context`. The line
      width value specifies the diameter of a pen that is circular in
      user space, (though device-space pen may be an ellipse in general
      due to scaling/shear/rotation of the CTM).

      Note: When the description above refers to user space and CTM it
      refers to the user space and CTM in effect at the time of the
      stroking operation, not the user space and CTM in effect at the
      time of the call to `set_line_width/2`. The simplest usage
      makes both of these spaces identical. That is, if there is no
      change to the CTM between a call to `set_line_width/2` and the
      stroking operation, then one can just pass user-space values to
      `set_line_width/2` and ignore this note.

      As with the other stroke parameters, the current line width is
      examined by `stroke/1`, and `stroke_extents/1`, but does not have
      any effect during path construction.

      The default line width value is 2.0.
      """
      @doc group: "Graphics state"
      @spec set_line_width(Context.t(), number()) :: Xairo.maybe_ctx()
      def set_line_width(ctx, width), do: NIF.context_set_line_width(ctx, width * 1.0)

      @doc """
      Gets the current line cap style, as set by `set_line_cap/2`.
      """
      @doc group: "Graphics state"
      @spec get_line_cap(Context.t()) :: line_cap()
      def get_line_cap(ctx), do: NIF.context_get_line_cap(ctx)

      @doc """
      Sets the current line cap style within the `Xairo.Context`. The line
      cap style specifies how to render the endpoints of the path when stroking.

      * `:butt` - start(stop) the line exactly at the start(end) point
      * `:round` - use a round ending, the center of the circle is the end point
      * `:square` - use squared ending, the center of the square is the end point

      As with the other stroke parameters, the current line cap style is
      examined by `stroke/1`, and `stroke_extents/1`, but does not have
      any effect during path construction.

      The default line cap style is `:butt`.
      """
      @doc group: "Graphics state"
      @spec set_line_cap(Context.t(), line_cap()) :: Xairo.maybe_ctx()
      def set_line_cap(ctx, line_cap) when line_cap in @line_caps,
        do: NIF.context_set_line_cap(ctx, line_cap)

      @doc """
      Gets the current line join style, as set by `set_line_join/2`.
      """
      @doc group: "Graphics state"
      @spec get_line_join(Context.t()) :: line_join()
      def get_line_join(ctx), do: NIF.context_get_line_join(ctx)

      @doc """
      Sets the current line join style within the `Xairo.Context`. The line
      join style specifies how to render the junction of two lines when stroking.

      * `:miter` - use a sharp (angled) corner, see `set_miter_limit/2`
      * `:round` - use a rounded join, the center of the circle is the joint point
      * `:bevel` - use a cut-off join, the join is cut off at half the line
        width from the joint point

      As with the other stroke parameters, the current line join style is
      examined by `stroke/1`, and `stroke_extents/1`, but does not have
      any effect during path construction.

      The default line join style is `:miter`.
      """
      @doc group: "Graphics state"
      @spec set_line_join(Context.t(), line_join()) :: Xairo.maybe_ctx()
      def set_line_join(ctx, line_join) when line_join in @line_joins,
        do: NIF.context_set_line_join(ctx, line_join)

      @doc """
      Gets the current miter limit, as set by `set_miter_limit/2`.
      """
      @doc group: "Graphics state"
      @spec get_miter_limit(Context.t()) :: float()
      def get_miter_limit(ctx), do: NIF.context_get_miter_limit(ctx)

      @doc """
      Sets the current miter limit within the `Xairo.Context`.

      If the current line join style is set to `:miter` (see
      `set_line_join/2`), the miter limit is used to determine
      whether the lines should be joined with a bevel instead of a miter.
      Cairo divides the length of the miter by the line width.
      If the result is greater than the miter limit, the style is
      converted to a bevel.

      As with the other stroke parameters, the current line miter limit is
      examined by `stroke/1`, and `stroke_extents/1`, but does not have
      any effect during path construction.

      The default miter limit value is 10.0, which will convert joins
      with interior angles less than 11 degrees to bevels instead of
      miters. For reference, a miter limit of 2.0 makes the miter cutoff
      at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90
      degrees.

      A miter limit for a desired angle can be computed as:
      `miter limit = 1 / sin(angle / 2)`
      """
      @doc group: "Graphics state"
      @spec set_miter_limit(Context.t(), number()) :: Xairo.maybe_ctx()
      def set_miter_limit(ctx, width), do: NIF.context_set_miter_limit(ctx, width * 1.0)

      @doc """
      Gets the current tolerance value, as set by `set_tolerance/2`.
      """
      @doc group: "Graphics state"
      @spec get_tolerance(Context.t()) :: float()
      def get_tolerance(ctx), do: NIF.context_get_tolerance(ctx)

      @doc """
      Sets the tolerance used when converting paths into trapezoids.
      Curved segments of the path will be subdivided until the maximum
      deviation between the original path and the polygonal approximation
      is less than the tolerance, given in device units (typically pixels).
      The default value is 0.1. A larger
      value will give better performance, a smaller value, better
      appearance. (Reducing the value from the default value of 0.1
      is unlikely to improve appearance significantly.) The accuracy of paths
      within Cairo is limited by the precision of its internal arithmetic, and
      the prescribed tolerance is restricted to the smallest
      representable internal value.
      """
      @doc group: "Graphics state"
      @spec set_tolerance(Context.t(), number()) :: Xairo.maybe_ctx()
      def set_tolerance(ctx, width), do: NIF.context_set_tolerance(ctx, width * 1.0)

      @doc """
      Gets the current dash array and dash offset, as set by `set_dash/3`,
      returned as a `{dashes, offset}` tuple.
      """
      @doc group: "Graphics state"
      @spec get_dash(Context.t()) :: {[float()], float()}
      def get_dash(ctx), do: NIF.context_get_dash(ctx)

      @doc """
      Sets the dash pattern to be used by `stroke/1`. A dash pattern
      is specified by `dashes`, a list of positive values. Each value
      provides the length of alternate "on" and "off" portions of the
      stroke. The `offset` specifies an offset into the pattern at which
      the stroke begins.

      Each "on" segment will have caps applied as if the segment were a
      separate sub-path. In particular, it is valid to use an "on" length
      of 0.0 with a `:round` or `:square` line cap in order
      to distributed dots or squares along a path.

      Note: The length values are in user-space units as evaluated at the
      time of stroking. This is not necessarily the same as the user
      space at the time of `set_dash/3`.

      If `dashes` is empty dashing is disabled.

      If `dashes` has a single value a symmetric pattern is assumed with
      alternating on and off portions of the size specified by the single
      value in `dashes`.

      If any value in `dashes` is negative, or if all values are 0, then
      `{:error, :invalid_dash}` will be returned.
      """
      @doc group: "Graphics state"
      @spec set_dash(Context.t(), [number()], number()) :: Xairo.maybe_ctx()
      def set_dash(ctx, dashes, offset) do
        NIF.context_set_dash(
          ctx,
          Enum.map(dashes, &(&1 / 1)),
          offset / 1
        )
      end

      @doc """
      Gets the current compositing operator for a `Xairo.Context`.
      """
      @doc group: "Graphics state"
      @spec get_operator(Context.t()) :: operator()
      def get_operator(ctx), do: NIF.context_get_operator(ctx)

      @doc """
      Sets the compositing operator to be used for all drawing
      operations.

      The operators marked as unbounded modify their
      destination even outside of the mask layer (that is, their effect is not
      bound by the mask layer). However, their effect can still be limited by
      way of clipping.

      To keep things simple, the operator descriptions here
      document the behavior for when both source and destination are either fully
      transparent or fully opaque. The actual implementation works for
      translucent layers too.

      For a more detailed explanation of the effects of each operator, including
      the mathematical definitions, see
      [https://cairographics.org/operators/](https://cairographics.org/operators/).

      * `:clear` - clear destination layer (bounded)
      * `:source` - replace destination layer (bounded)
      * `:over` - draw source layer on top of destination layer (bounded)
      * `:in` - draw source where there was destination content (unbounded)
      * `:out` - draw source where there was no destination content (unbounded)
      * `:atop` - draw source on top of destination content and only there
      * `:dest` - ignore the source
      * `:dest_over` - draw destination on top of source
      * `:dest_in` - leave destination only where there was source content (unbounded)
      * `:dest_out` - leave destination only where there was no source content
      * `:dest_atop` - leave destination on top of source content and only there (unbounded)
      * `:xor` - source and destination are shown where there is only one of them
      * `:add` - source and destination layers are accumulated
      * `:saturate` - like over, but assuming source and dest are disjoint geometries
      * `:multiply` - source and destination layers are multiplied. This causes
        the result to be at least as dark as the darker inputs.
      * `:screen` - source and destination are complemented and multiplied. This
        causes the result to be at least as light as the lighter inputs.
      * `:overlay` - multiplies or screens, depending on the lightness of the
        destination color.
      * `:darken` - replaces the destination with the source if it is darker,
        otherwise keeps the source.
      * `:lighten` - replaces the destination with the source if it is lighter,
        otherwise keeps the source.
      * `:color_dodge` - brightens the destination color to reflect the source color.
      * `:color_burn` - darkens the destination color to reflect the source color.
      * `:hard_light` - Multiplies or screens, dependent on source color.
      * `:soft_light` - Darkens or lightens, dependent on source color.
      * `:difference` - Takes the difference of the source and destination color.
      * `:exclusion` - Produces an effect similar to difference, but with lower contrast.
      * `:hsl_hue` - Creates a color with the hue of the source and the saturation
        and luminosity of the target.
      * `:hsl_saturation` - Creates a color with the saturation of the source and
        the hue and luminosity of the target. Painting with this mode onto a gray
        area produces no change.
      * `:hsl_color` - Creates a color with the hue and saturation of the source
        and the luminosity of the target. This preserves the gray levels of the
        target and is useful for coloring monochrome images or tinting color images.
      * `:hsl_luminosity` - Creates a color with the luminosity of the source and
        the hue and saturation of the target. This produces an inverse effect to
        `:hsl_color`.

      The default operator is `:over`.
      """
      @doc group: "Graphics state"
      @spec set_operator(Context.t(), operator()) :: Xairo.maybe_ctx()
      def set_operator(ctx, operator) when operator in @operators do
        NIF.context_set_operator(ctx, operator)
      end
    end
  end
end
