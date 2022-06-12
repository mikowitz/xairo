defmodule Xairo.Context do
  @moduledoc """
  Models a Cairo drawing context that can be instantiated from any
  supported surface type.

  The majority of the Xairo API is contained in this module, as the context
  is the underlying Cairo object that handles commands relating to drawing
  onto a surface.

  With only a few exceptions, called out in their documentation, the functions
  on this module take a `Xairo.Context` as their first argument, and return a
  `Xairo.Context`. This allows for piping through functions while constructing
  more complex images.
  """
  defstruct [:context, :surface, :source, :font_face]

  @typedoc """
  The Elixir model of a Cairo context. Stores a reference to the in-memory
  representation of the context, as well as Elixir structs representing the
  surface it was instantiade with, the current color data source, and the current
  font face.
  """
  @type t :: %__MODULE__{
          context: reference(),
          surface: Xairo.surface(),
          source: Xairo.color_source(),
          font_face: Xairo.FontFace.t()
        }

  alias Xairo.{
    FontFace,
    ImageSurface,
    LinearGradient,
    Matrix,
    Mesh,
    Path,
    PdfSurface,
    Point,
    PsSurface,
    RadialGradient,
    Rgba,
    SolidPattern,
    SurfacePattern,
    SvgSurface,
    Vector
  }

  alias Xairo.Native, as: N

  @doc """
  Creates a new context from a `t:Xairo.surface/0`.
  """
  @doc section: :init
  @spec new(Xairo.surface()) :: Xairo.or_error(t())
  def new(%ImageSurface{} = surface) do
    with {:ok, context} <- N.context_new(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PdfSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_pdf_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%SvgSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_svg_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PsSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_ps_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  @doc """
  Returns the surface from which the context was instantiated.

  This function retains underlying Cairo API name, which indicates
  that the associated surface is the target for the drawing operations
  called on the context.
  """
  @doc section: :init
  @spec target(t()) :: Xairo.surface()
  def target(%__MODULE__{surface: surface}), do: surface

  @doc """
  Sets the current color data source for the context. This can be one of any
  struct defined as part of `t:Xairo.color_source/0`.
  """
  @doc section: :drawing
  @spec set_source(t(), Xairo.pattern()) :: Xairo.or_error(t())
  def set_source(%__MODULE__{context: ctx} = context, %Rgba{} = rgba) do
    N.context_set_source_rgba(ctx, rgba)
    %{context | source: SolidPattern.from_rgba(rgba)}
  end

  def set_source(
        %__MODULE__{context: ctx} = context,
        %LinearGradient{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_linear_gradient(ctx, pattern) do
      %{context | source: gradient}
    end
  end

  def set_source(
        %__MODULE__{context: ctx} = context,
        %RadialGradient{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_radial_gradient(ctx, pattern) do
      %{context | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = context, %SolidPattern{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_solid_pattern(ctx, pattern) do
      %{context | source: gradient}
    end
  end

  def set_source(
        %__MODULE__{context: ctx} = context,
        %SurfacePattern{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_surface_pattern(ctx, pattern) do
      %{context | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = context, %Mesh{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_mesh(ctx, pattern) do
      %{context | source: gradient}
    end
  end

  @doc """
  Sets the current color data source to be a `Xairo.ImageSurface`.

  In addition to the source surface, this function takes a point that defines the origin of the
  source surface on the target context.
  """
  @doc section: :drawing
  @spec set_source(t(), Xairo.ImageSurface.t(), Xairo.point()) :: Xairo.or_error(t())
  def set_source(
        %__MODULE__{context: ctx} = context,
        %ImageSurface{surface: surface} = sfc,
        origin
      ) do
    with {:ok, _} <- N.context_set_source_surface(ctx, surface, Point.from(origin)) do
      %{context | source: SurfacePattern.create(sfc)}
    end
  end

  @doc """
  Returns the currently set color data source for the context.
  """
  @doc section: :drawing
  @spec source(t()) :: Xairo.color_source()
  def source(%__MODULE__{source: source}), do: source

  @doc """
  Draws an arc defined by the given parameters.

  In addition to the `Xairo.Context` struct, this function takes the following
  arguments

  * the center point to draw the arc around
  * the arc's radius
  * the starting and stopping angles (given in radians)

  The arc is drawn clockwise between the two angles.
  """
  @doc section: :drawing
  @spec arc(t(), Xairo.point(), number(), number(), number()) :: t()
  def arc(%__MODULE__{context: ctx} = context, center, r, angle1, angle2) do
    N.context_arc(ctx, Point.from(center), r / 1, angle1 / 1, angle2 / 1)
    context
  end

  @doc """
  Draws a counterclockwise arc defined by the given parameters.

  This function is identical to `Xairo.Context.arc/5` except for the direction in which
  the arc is drawn.
  """
  @doc section: :drawing
  @spec arc_negative(t(), Xairo.point(), number(), number(), number()) :: t()
  def arc_negative(%__MODULE__{context: ctx} = context, center, r, angle1, angle2) do
    N.context_arc_negative(ctx, Point.from(center), r / 1, angle1 / 1, angle2 / 1)
    context
  end

  @doc """
  Draws a cubic Bézier curve with the given control points.

  The first control point of the curve is the context's path's current point, with
  the three arguments given to the function determining the remaining control points.
  """
  @doc section: :drawing
  @spec curve_to(t(), Xairo.point(), Xairo.point(), Xairo.point()) :: t()
  def curve_to(%__MODULE__{context: ctx} = context, point1, point2, point3) do
    N.context_curve_to(ctx, Point.from(point1), Point.from(point2), Point.from(point3))
    context
  end

  @doc """
  Draws a cubic Bézier curve with the given control points relative to the path's current point.

    Whereas the arguments given to `Xairo.Context.curve_to/4` are absolute points in userspace,
    the arguments given to this function are vectors defined relative to the first control point (the path's current point). It is important to note that all the control points are relative to the starting point, not to the calculated location of the previous argument.
  """
  @doc section: :drawing
  @spec rel_curve_to(t(), Xairo.vector(), Xairo.vector(), Xairo.vector()) :: t()
  def rel_curve_to(%__MODULE__{context: ctx} = context, vec1, vec2, vec3) do
    N.context_rel_curve_to(ctx, Vector.from(vec1), Vector.from(vec2), Vector.from(vec3))
    context
  end

  @doc """
  Draws a straight line from the current point to the given point.
  """
  @doc section: :drawing
  @spec line_to(t(), Xairo.point()) :: t()
  def line_to(%__MODULE__{context: ctx} = context, point) do
    N.context_line_to(ctx, Point.from(point))
    context
  end

  @doc """
  Draws a straight line from the current point to a point relative to the current point by
  the vector argument.
  """
  @doc section: :drawing
  @spec rel_line_to(t(), Xairo.vector()) :: t()
  def rel_line_to(%__MODULE__{context: ctx} = context, vec) do
    N.context_rel_line_to(ctx, Vector.from(vec))
    context
  end

  @doc """
  Draws a rectangle based on the given arguments.

  In addition to the `Xairo.Context` struct, this function takes the following
  arguments

  * an origin point representing the top-left corner of the rectangle
  * the width of the rectangle
  * the height of the rectangle

  Note that after this function is called, the current point for the context is the
  upper-left origin point of the rectangle, not the bottom-right.
  """
  @doc section: :drawing
  @spec rectangle(t(), Xairo.point(), number(), number()) :: t()
  def rectangle(%__MODULE__{context: ctx} = context, origin, width, height) do
    N.context_rectangle(ctx, Point.from(origin), width / 1, height / 1)
    context
  end

  @doc """
  Moves the current point to the given point.
  """
  @doc section: :drawing
  @spec move_to(t(), Xairo.point()) :: t()
  def move_to(%__MODULE__{context: ctx} = context, point) do
    N.context_move_to(ctx, Point.from(point))
    context
  end

  @doc """
  Moves the current point to a point relative to the current point by the
  vector argument.
  """
  @doc section: :drawing
  @spec rel_move_to(t(), Xairo.vector()) :: t()
  def rel_move_to(%__MODULE__{context: ctx} = context, vec) do
    N.context_rel_move_to(ctx, Vector.from(vec))
    context
  end

  @doc """
  Closes the path by drawing a straight line from the current point to the path's origin.
  """
  @doc section: :drawing
  @spec close_path(t()) :: t()
  def close_path(%__MODULE__{context: ctx} = context) do
    N.context_close_path(ctx)
    context
  end

  @doc """
  Renders the current path to the context's surface by drawing along the path.

  This takes into account the context's settings for line width, join, and cap styles.

  This function clears the current path.
  """
  @doc section: :drawing
  @spec stroke(t()) :: Xairo.or_error(t())
  def stroke(%__MODULE__{context: ctx} = context) do
    with {:ok, _} <- N.context_stroke(ctx), do: context
  end

  @doc """
  Identical to `Xairo.Context.stroke/1` but preserves the current path.
  """
  @doc section: :drawing
  @spec stroke_preserve(t()) :: Xairo.or_error(t())
  def stroke_preserve(%__MODULE__{context: ctx} = context) do
    with {:ok, _} <- N.context_stroke_preserve(ctx), do: context
  end

  @doc """
  Renders the current path to the context's surface by filling it in.

  If the path overlaps itself, contained areas or filled based on the
  current setting for the fill rule.

  This function clears the current path.
  """
  @doc section: :drawing
  @spec fill(t()) :: Xairo.or_error(t())
  def fill(%__MODULE__{context: ctx} = context) do
    with {:ok, _} <- N.context_fill(ctx), do: context
  end

  @doc """
  Identical to `Xairo.Context.fill/1` but preserves the current path.
  """
  @doc section: :drawing
  @spec fill_preserve(t()) :: Xairo.or_error(t())
  def fill_preserve(%__MODULE__{context: ctx} = context) do
    with {:ok, _} <- N.context_fill_preserve(ctx), do: context
  end

  @doc """
  Paints the current color source onto the entire surface area.
  """
  @doc section: :drawing
  @spec paint(t()) :: Xairo.or_error(t())
  def paint(%__MODULE__{context: ctx} = context) do
    with {:ok, _} <- N.context_paint(ctx), do: context
  end

  @doc """
  Identical to `Xairo.Context.paint/1` but takes an additional argument specifying
  an alpha value to be applied across the entire surface area.
  """
  @doc section: :drawing
  @spec paint_with_alpha(t(), number()) :: Xairo.or_error(t())
  def paint_with_alpha(%__MODULE__{context: ctx} = context, alpha) do
    with {:ok, _} <- N.context_paint_with_alpha(ctx, alpha / 1), do: context
  end

  @doc """
  Copies the current path.
  """
  @doc section: :drawing
  @spec copy_path(t()) :: Xairo.or_error(Path.t())
  def copy_path(%__MODULE__{context: ctx}) do
    with {:ok, path} <- N.context_copy_path(ctx), do: Path.from(path)
  end

  @doc """
  Copies the current path, but replaces curves and arcs with
  a series of straight lines based on the context's tolerance value.
  """
  @doc section: :drawing
  @spec copy_path_flat(t()) :: Xairo.or_error(Path.t())
  def copy_path_flat(%__MODULE__{context: ctx}) do
    with {:ok, path} <- N.context_copy_path_flat(ctx), do: Path.from(path)
  end

  @doc """
  Appends a path to the end of the current path.
  """
  @doc section: :drawing
  @spec append_path(t(), Path.t()) :: t()
  def append_path(%__MODULE__{context: ctx} = context, %Path{path: path}) do
    N.context_append_path(ctx, path)
    context
  end

  @doc """
  Returns the current tolerance for the context.

  This value determines how curves are segmented when calling `Xairo.Context.copy_path_flat/1`.
  """
  @doc section: :config
  @spec tolerance(t()) :: number()
  def tolerance(%__MODULE__{context: ctx}), do: N.context_tolerance(ctx)

  @doc """
  Sets the tolerance value for the context.
  """
  @doc section: :config
  @spec set_tolerance(t(), number()) :: t()
  def set_tolerance(%__MODULE__{context: ctx} = context, tolerance) do
    N.context_set_tolerance(ctx, tolerance / 1)
    context
  end

  @doc """
  Returns whether there is a current point set for the context.

  This will be false for a brand new context, and after `Xairo.Context.stroke/1` or
  `Xairo.Context.fill/1` has been called and the path has been cleared.

  Can also return an error if the state of the context has become corrupted.
  """
  @doc section: :calc
  @spec has_current_point(t()) :: Xairo.or_error(boolean())
  def has_current_point(%__MODULE__{context: ctx}) do
    with {:ok, boolean} <- N.context_has_current_point(ctx), do: boolean
  end

  @doc """
  Returns the current point for the context, or a point at {0, 0} when there
  is no current point.

  Can also return an error if the state of the context has become corrupted.
  """
  @doc section: :calc
  @spec current_point(t()) :: Xairo.or_error(Point.t())
  def current_point(%__MODULE__{context: ctx}) do
    with {:ok, point} <- N.context_current_point(ctx), do: point
  end

  @doc """
  Clears the current path.

  After this is called there will be no path or current point.
  """
  @doc section: :drawing
  @spec new_path(t()) :: t()
  def new_path(%__MODULE__{context: ctx} = context) do
    N.context_new_path(ctx)
    context
  end

  @doc """
  Begins a new sub path.

  After this is called the current path is not affected, but there is no current
  point set.

  Often this function is not needed as new sub-paths are created by calls to
  `Xario.Context.move_to/2`

    One instance where this function is useful is when you want to begin a new path with
    a call to `Xairo.Context.arc/5` or its negative version. By calling this function
    you will skip needing to manually calculate and move to the arc's starting point
    to avoid a line being drawn from the current point to the beginning of the arc.
  """
  @doc section: :drawing
  @spec new_sub_path(t()) :: t()
  def new_sub_path(%__MODULE__{context: ctx} = context) do
    N.context_new_sub_path(ctx)
    context
  end

  @doc """
  Prints the given text to the surface.

  This function will immediately render the text and move the current point
  to the end of its output. It does not affect the current path.
  """
  @doc section: :text
  @spec show_text(t(), String.t()) :: Xairo.or_error(t())
  def show_text(%__MODULE__{context: ctx} = context, text) do
    with {:ok, _} <- N.context_show_text(ctx, text), do: context
  end

  @doc """
  Adds the outline of the given text to the current path.

  Unlike `Xairo.Context.show_text/2`, this does not render anything to the surface
  until a call to `Xairo.Context.fill/1` or `Xairo.Context.stroke/1` is made.

  Calling this function followed by `Xairo.Context.fill/1` is equivalent
  to calling `Xairo.Context.show_text/2` with the same text.
  """
  @doc section: :text
  @spec text_path(t(), String.t()) :: t()
  def text_path(%__MODULE__{context: ctx} = context, text) do
    N.context_text_path(ctx, text)
    context
  end

  @doc """
  Sets the font size for the context and surface.
  """
  @doc section: :text
  @spec set_font_size(t(), number()) :: t()
  def set_font_size(%__MODULE__{context: ctx} = context, font_size) do
    N.context_set_font_size(ctx, font_size / 1)
    context
  end

  @doc """
  Sets the font face for the context.

  See `Xairo.FontFace` for more details.
  """
  @doc section: :text
  @spec set_font_face(t(), FontFace.t()) :: t()
  def set_font_face(%__MODULE__{context: ctx} = context, %FontFace{font_face: font_face} = ff) do
    N.context_set_font_face(ctx, font_face)
    %{context | font_face: ff}
  end

  @doc """
  Returns the current font face for the context.
  """
  @doc section: :text
  @spec font_face(t()) :: FontFace.t()
  def font_face(%__MODULE__{font_face: font_face}) do
    font_face
  end

  @doc """
  Sets the current font face for the context by passing in the individual components
  of the font face.

  See `Xairo.FontFace` for more details about what those arguments should be.
  """
  @doc section: :text
  @spec select_font_face(t(), String.t(), FontFace.slant(), FontFace.weight()) :: t()
  def select_font_face(%__MODULE__{context: ctx} = context, family, slant, weight) do
    with font_face <- N.context_select_font_face(ctx, family, slant, weight),
         do: %{context | font_face: %FontFace{font_face: font_face}}
  end

  @doc """
  Applies the specified x and y translations to the context's current
  transformation matrix.
  """
  @doc section: :transform
  @spec translate(t(), number(), number()) :: t()
  def translate(%__MODULE__{context: ctx} = context, tx, ty) do
    N.context_translate(ctx, tx / 1, ty / 1)
    context
  end

  @doc """
  Applies the specified x and y scaling to the context's current
  transformation matrix.
  """
  @doc section: :transform
  @spec scale(t(), number(), number()) :: t()
  def scale(%__MODULE__{context: ctx} = context, sx, sy) do
    N.context_scale(ctx, sx / 1, sy / 1)
    context
  end

  @doc """
  Applies the specified rotation (in radians) to the context's
  current transformation matrix.
  """
  @doc section: :transform
  @spec rotate(t(), number()) :: t()
  def rotate(%__MODULE__{context: ctx} = context, radians) do
    N.context_rotate(ctx, radians / 1)
    context
  end

  @doc """
  Applies the transformations in the given matrix to the end of the
  context's current transformation matrix.
  """
  @doc section: :transform
  @spec transform(t(), Matrix.t()) :: t()
  def transform(%__MODULE__{context: ctx} = context, %Matrix{matrix: matrix}) do
    N.context_transform(ctx, matrix)
    context
  end

  @doc """
  Sets the given matrix as the context's current transformation matrix.

  This replaces any other modifications on the CTM.
  """
  @doc section: :transform
  @spec set_matrix(t(), Matrix.t()) :: t()
  def set_matrix(%__MODULE__{context: ctx} = context, %Matrix{matrix: matrix}) do
    N.context_set_matrix(ctx, matrix)
    context
  end

  @doc """
  Returns the context's current transformation matrix.
  """
  @doc section: :transform
  @spec matrix(t()) :: Matrix.t()
  def matrix(%__MODULE__{context: ctx}) do
    %Matrix{matrix: N.context_matrix(ctx)}
  end

  @doc """
  Sets the current transformation matrix to the identity matrix.
  """
  @doc section: :transform
  @spec identity_matrix(t()) :: t()
  def identity_matrix(%__MODULE__{context: ctx} = context) do
    N.context_identity_matrix(ctx)
    context
  end

  @doc """
  Sets the transformation matrix for text rendered to the surface.

  These transformations are added to any transformations applied by the
  context's transformation matrix.
  """
  @doc section: :transform
  @spec set_font_matrix(t(), Matrix.t()) :: t()
  def set_font_matrix(%__MODULE__{context: ctx} = context, %Matrix{matrix: matrix}) do
    N.context_set_font_matrix(ctx, matrix)
    context
  end

  @doc """
  Returns the current font matrix.
  """
  @doc section: :transform
  @spec font_matrix(t()) :: Matrix.t()
  def font_matrix(%__MODULE__{context: ctx}) do
    %Matrix{matrix: N.context_font_matrix(ctx)}
  end

  @doc """
  Paints the current source applying the `alpha` values from the given pattern as a mask.
  """
  @doc section: :mask
  @spec mask(t(), Xairo.pattern()) :: Xairo.or_error(t())
  def mask(%__MODULE__{context: ctx} = context, %RadialGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_radial_gradient(ctx, pattern), do: context
  end

  def mask(%__MODULE__{context: ctx} = context, %LinearGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_linear_gradient(ctx, pattern), do: context
  end

  def mask(%__MODULE__{context: ctx} = context, %Mesh{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_mesh(ctx, pattern), do: context
  end

  def mask(%__MODULE__{context: ctx} = context, %SolidPattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_solid_pattern(ctx, pattern), do: context
  end

  def mask(%__MODULE__{context: ctx} = context, %SurfacePattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_surface_pattern(ctx, pattern), do: context
  end

  @doc """
  Like `Xairo.Context.mask/2` but uses the `alpha` channel from a `Xairo.ImageSurface` as the mask.

  `Xairo.Context.mask_surface/3` also takes a point argument as the origin at which to
  situate the masking surface.
  """
  @doc section: :mask
  @spec mask_surface(t(), ImageSurface.t(), Xairo.point()) :: Xairo.or_error(t())
  def mask_surface(%__MODULE__{context: ctx} = context, %ImageSurface{surface: surface}, origin) do
    with {:ok, _} <- N.context_mask_surface(ctx, surface, Point.from(origin)), do: context
  end

  @doc """
  Sets the line width to be used in calls to `Xairo.Context.stroke/1`
  """
  @doc section: :config
  @spec set_line_width(t(), number()) :: t()
  def set_line_width(%__MODULE__{context: ctx} = context, line_width) do
    N.context_set_line_width(ctx, line_width / 1)
    context
  end

  @doc """
  Returns the current line width
  """
  @doc section: :config
  @spec line_width(t()) :: number()
  def line_width(%__MODULE__{context: ctx}) do
    N.context_line_width(ctx)
  end

  @doc """
  Sets the antialias strategy for how lines are rendered.

  See [Cairo documentation on antialias settings](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-antialias-t) for more details.
  """
  @doc section: :config
  @spec set_antialias(t(), Xairo.antialias()) :: t()
  def set_antialias(%__MODULE__{context: ctx} = context, antialias) do
    N.context_set_antialias(ctx, antialias)
    context
  end

  @doc """
  Returns the current antialias strategy.
  """
  @doc section: :config
  @spec antialias(t()) :: Xairo.antialias()
  def antialias(%__MODULE__{context: ctx}) do
    N.context_antialias(ctx)
  end

  @doc """
  Sets the fill rule for how `Xairo.Context.fill/1` handles points where
  the path overlaps.

  See [Cairo documentation on the fill rule](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-fill-rule-t) for details on how the various rules apply.
  """
  @doc section: :config
  @spec set_fill_rule(t(), Xairo.fill_rule()) :: t()
  def set_fill_rule(%__MODULE__{context: ctx} = context, fill_rule) do
    N.context_set_fill_rule(ctx, fill_rule)
    context
  end

  @doc """
  Returns the current fill rule.
  """
  @doc section: :config
  @spec fill_rule(t()) :: Xairo.fill_rule()
  def fill_rule(%__MODULE__{context: ctx}) do
    N.context_fill_rule(ctx)
  end

  @doc """
  Sets the line cap style.

  See [Cairo documentation on line caps](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-cap-t).
  """
  @doc section: :config
  @spec set_line_cap(t(), Xairo.line_cap()) :: t()
  def set_line_cap(%__MODULE__{context: ctx} = context, line_cap) do
    N.context_set_line_cap(ctx, line_cap)
    context
  end

  @doc """
  Returns the current line cap setting
  """
  @doc section: :config
  @spec line_cap(t()) :: Xairo.line_cap()
  def line_cap(%__MODULE__{context: ctx}) do
    N.context_line_cap(ctx)
  end

  @doc """
  Sets the rule for line joins.

  See [Cairo documentation about line joins](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-join-t)
  """
  @doc section: :config
  @spec set_line_join(t(), Xairo.line_join()) :: t()
  def set_line_join(%__MODULE__{context: ctx} = context, line_join) do
    N.context_set_line_join(ctx, line_join)
    context
  end

  @doc """
  Returns the current line join setting
  """
  @doc section: :config
  @spec line_join(t()) :: Xairo.line_join()
  def line_join(%__MODULE__{context: ctx}) do
    N.context_line_join(ctx)
  end

  @doc """
  Sets the miter limit for the context.

  When the line join style is set to `:miter`, this limit determines if
    the lines will be joined with a bevel instead of a miter. To make this
    determination, Cairo divides the length of the miter by the line width. If that
    value is greater than this set miter limit, the style is converted to a bevel.

  From the [Cairo documentation](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-miter-limit)

  > The default miter limit value is 10.0, which will convert joins with interior angles less than 11 degrees to bevels instead of miters. For reference, a miter limit of 2.0 makes the miter cutoff at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90 degrees.
  >
  > A miter limit for a desired angle can be computed as: miter limit = 1/sin(angle/2)
  """
  @doc section: :config
  @spec set_miter_limit(t(), number()) :: t()
  def set_miter_limit(%__MODULE__{context: ctx} = context, miter_limit) do
    N.context_set_miter_limit(ctx, miter_limit / 1)
    context
  end

  @doc """
  Returns the current value of the miter limit
  """
  @doc section: :config
  @spec miter_limit(t()) :: number()
  def miter_limit(%__MODULE__{context: ctx}) do
    N.context_miter_limit(ctx)
  end

  @doc """
  Sets the dash pattern that is used to draw lines when `Xairo.Context.stroke/1`
  is called.

  The dash pattern is defined by a list of segment widths, and an initial offset
  (both measured in pixels, or document units for an SVG image).
  When a line is drawn, the initial offset is rendered as a space, and then
  the list of segment widths is cycled, alternating segments of line and space.

  Given that, a segment list with an even number of elements will repeat after
  each cycle through, while a list with an odd number will repeat after every
  two cycles through.

  By default the dash pattern consists of an empty list and a 0 length offset,
  resulting in a solid line.

  ## Examples

  After setting the dash pattern with the following command

      Context.set_dash(context, [1, 2, 3], 0)

  lines will be drawn with this pattern (assuming each character space is a pixel)

  ```
  -  --- --   -  --- --   -  --- --   -  --- -- ...
  ```
  """
  @doc section: :drawing
  @spec set_dash(t(), [number()], number()) :: t()
  def set_dash(%__MODULE__{context: ctx} = context, dashes, offset) do
    N.context_set_dash(ctx, Enum.map(dashes, &(&1 / 1)), offset / 1)
    context
  end

  @doc """
  Returns the length of the list of dash segment widths.
  """
  @doc section: :drawing
  @spec dash_count(t()) :: integer()
  def dash_count(%__MODULE__{context: ctx}) do
    N.context_dash_count(ctx)
  end

  @doc """
  Returns a 2-element tuple containing the current dash segment list and offset.
  """
  @doc section: :drawing
  @spec dash(t()) :: {[number()], number()}
  def dash(%__MODULE__{context: ctx}) do
    N.context_dash(ctx)
  end

  @doc """
  Returns the current dash segment list.
  """
  @doc section: :drawing
  @spec dash_dashes(t()) :: [number()]
  def dash_dashes(%__MODULE__{context: ctx}) do
    N.context_dash_dashes(ctx)
  end

  @doc """
  Returns the current dash offset.
  """
  @doc section: :drawing
  @spec dash_offset(t()) :: number()
  def dash_offset(%__MODULE__{context: ctx}) do
    N.context_dash_offset(ctx)
  end

  @doc """
  Sets the compositing operator for the context.

  The operator affects how objects are drawn to the surface. By default,
  a new object is drawn on top of any existing objects, taking into account
  each object's transparency.

  See [the cairo documentation on operators](https://cairographics.org/operators/)
  for visual examples and the underlying math for the existing operator options.
  """
  @doc section: :config
  @spec set_operator(t(), Xairo.operator()) :: t()
  def set_operator(%__MODULE__{context: ctx} = context, operator) do
    N.context_set_operator(ctx, operator)
    context
  end

  @doc """
  Returns the current operator set for the context.
  """
  @doc section: :config
  @spec operator(t()) :: Xairo.operator()
  def operator(%__MODULE__{context: ctx}) do
    N.context_operator(ctx)
  end

  @doc """
  Returns whether the given point falls in the region painted by a call to
  `Xairo.Context.stroke/1`
  """
  @doc section: :calc
  @spec in_stroke(t(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_stroke(%__MODULE__{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_stroke(ctx, Point.from(point)), do: bool
  end

  @doc """
  Returns whether the given point falls in the region painted by a call to
  `Xairo.Context.fill/1`
  """
  @doc section: :calc
  @spec in_fill(t(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_fill(%__MODULE__{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_fill(ctx, Point.from(point)), do: bool
  end

  @doc """
  Converts a point or vector in userspace to its actual location on the surface, determined
  by the current transformation matrix.

  When converting a vector, this function does *not* take into account the x and y
  translation values of the CTM.
  """
  @doc section: :calc
  @spec user_to_device(t(), Point.t()) :: Point.t()
  @spec user_to_device(t(), Vector.t()) :: Vector.t()
  def user_to_device(%__MODULE__{context: ctx}, %Point{} = point) do
    N.context_user_to_device(ctx, point)
  end

  def user_to_device(%__MODULE__{context: ctx}, %Vector{} = vec) do
    with {:ok, distance} <- N.context_user_to_device_distance(ctx, vec),
         do: distance
  end

  @doc """
  Converts a point or vector in absolute image space to userspace, as determined
  by the current transformation matrix.

  When converting a vector, this function does *not* take into account the x and y
  translation values of the CTM.
  """
  @doc section: :calc
  @spec device_to_user(t(), Point.t()) :: Point.t()
  @spec device_to_user(t(), Vector.t()) :: Vector.t()
  def device_to_user(%__MODULE__{context: ctx}, %Point{} = point) do
    with {:ok, distance} <- N.context_device_to_user(ctx, point),
         do: distance
  end

  def device_to_user(%__MODULE__{context: ctx}, %Vector{} = vec) do
    with {:ok, distance} <- N.context_device_to_user_distance(ctx, vec),
         do: distance
  end

  @doc """
  Sets a new clip region by intersecting the current clip region with the current path.

  This function clears the current path.

  Clipping calculates an intersection, so it can only make the clip region smaller. This region
  applies to all drawing operations by effectively masking any changes outside the current clip
  region.
  """
  @doc section: :clip
  @spec clip(t()) :: t()
  def clip(%__MODULE__{context: ctx} = context) do
    N.context_clip(ctx)
    context
  end

  @doc """
  Identical to `Xairo.Context.clip/1` but preserves the current path.
  """
  @doc section: :clip
  @spec clip_preserve(t()) :: t()
  def clip_preserve(%__MODULE__{context: ctx} = context) do
    N.context_clip_preserve(ctx)
    context
  end

  @doc """
  Resets the clip region to the entire image surface area.
  """
  @doc section: :clip
  @spec reset_clip(t()) :: t()
  def reset_clip(%__MODULE__{context: ctx} = context) do
    N.context_reset_clip(ctx)
    context
  end

  @doc """
  Returns whether the given point is included inside the current clip region.
  """
  @doc section: :calc
  @spec in_clip(t(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_clip(%__MODULE__{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_clip(ctx, Point.from(point)), do: bool
  end

  @doc """
  Returns the bounding box for the current clip region.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec clip_extents(t()) :: Xairo.or_error({Point.t(), Point.t()})
  def clip_extents(%__MODULE__{context: ctx}) do
    with {:ok, extents} <- N.context_clip_extents(ctx), do: extents
  end

  @doc """
  Returns a list of rectangles that describe the current clip region of the
  context.

  Will return an error if the current clip region cannot be represented by rectangles
  (e.g. the clip region was defined using `Xairo.Context.arc/5`,
  `Xairo.Context.curve_to/4`, etc).

  The rectangles are each defined by a 3-element tuple of
  `{upper-left-corner, width, height}`
  """
  @doc section: :calc
  @spec clip_rectangle_list(t()) :: Xairo.or_error([{Point.t(), number(), number()}])
  def clip_rectangle_list(%__MODULE__{context: ctx}) do
    with {:ok, rectangle_list} <- N.context_clip_rectangle_list(ctx),
         do: rectangle_list
  end

  @doc """
  Returns the bounding box for the current path.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec path_extents(t()) :: Xairo.or_error({Point.t(), Point.t()})
  def path_extents(%__MODULE__{context: ctx}) do
    with {:ok, extents} <- N.context_path_extents(ctx), do: extents
  end

  @doc """
  Returns the bounding box for the colored area by a call to `Xairo.Context.fill/1`
  given the current path.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec fill_extents(t()) :: Xairo.or_error({Point.t(), Point.t()})
  def fill_extents(%__MODULE__{context: ctx}) do
    with {:ok, extents} <- N.context_fill_extents(ctx), do: extents
  end

  @doc """
  Returns the bounding box for the colored area by a call to `Xairo.Context.stroke/1`
  given the current path.

  This bounding box takes into account the currently set line width, as well as line
  cap and join styles

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.

  """
  @doc section: :calc
  @spec stroke_extents(t()) :: Xairo.or_error({Point.t(), Point.t()})
  def stroke_extents(%__MODULE__{context: ctx}) do
    with {:ok, extents} <- N.context_stroke_extents(ctx), do: extents
  end

  @doc section: :calc
  defdelegate font_extents(context), to: Xairo.FontExtents, as: :for

  @doc section: :calc
  defdelegate text_extents(context, text), to: Xairo.TextExtents, as: :for
end
