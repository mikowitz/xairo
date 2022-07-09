defmodule Xairo do
  @moduledoc """
    The top-level module for the Xairo 2D graphics library, providing the majority
    of the user-facing Xairo API.

  With only a few exceptions, called out in their documentation, the functions
  on this module take a `Xairo.Image` struct as their first argument, and return a
  `Xairo.Image` struct. This allows for piping through functions while constructing
  more complex images.

  ### Userspace and scale

  A discussion of userspace, imagespace, and scaling will be useful to understand how
  your drawing commands are communicated to and rendered on the underlying Cairo surface.

  All points and vectors you provide to the drawing functions below are given in "userspace"
  coordinates. That is, the coordinates relative to the size of the image you define.

  For example, the following would draw a line from {10, 10} to {90, 90} on a 100x100 pixel image

      Image.new("test.png", 100, 100)
      |> Xairo.move_to(10, 10)
      |> Xairo.line_to(90, 90)

  If you scale the context by a factor of 2 in both directions and draw the same line,
  it will render a line from {20, 20} to {180, 180}, rendering a significant portion of
  the line off your canvas!

      Image.new("test.png", 100, 100)
      |> Xairo.scale(2, 2)
      |> Xairo.move_to(10, 10)
      |> Xairo.line_to(90, 90)

  If your goal was to create a scaled-up version of the first image, this obviously does
  not work. This is because scaling the context does nothing to the size of the underlying
  surface. In order to get the expected result, you would need to scale the dimensions of
  your surface by the same factors

      Image.new("test.png", 200, 200)
      |> Xairo.scale(2, 2)
      |> Xairo.move_to(10, 10)
      |> Xairo.line_to(90, 90)

  One solution to avoid mismatched scales is simply to lift the scale factors up to the
  top level of your project and make sure they are applied.

      scale = 2
      Image.new("test.png", 100 * scale, 100 * scale)
      |> Xairo.scale(scale, scale)
      |> Xairo.move_to(10, 10)
      |> Xairo.line_to(90, 90)

  This way you can change the scale and be sure that it will be applied everywhere it
  needs to be for the image to render correctly. This strategy is useful when prototyping
  designs. You can use a small scale value to reduce the time it takes to render the image
  while it is in progress, and scale up only for the final output.

  ### How cairo renders images

  Cairo creates images by building up paths, or collections of moving to and
  drawing between points on the image space. These paths can be initiated by
  moving to a point, which is set as the current point of the path, using the
  functions

  * `Xairo.move_to/2`
  * `Xairo.rel_move_to/2`

  `move_to/2` takes as its second parameter an absolute coordinate in userspace
  (see above for an explanation), while `rel_move_to/2` takes a vector defining
  the distance to the new point relative to the previous current point.

  Once a current point has been set, the path can be appended to by using any of
  these functions

  * `Xairo.line_to/2`
  * `Xairo.rel_line_to/2`
  * `Xairo.rectangle/4`
  * `Xairo.arc/5`
  * `Xairo.arc_negative/5`
  * `Xairo.curve_to/4`
  * `Xairo.rel_curve_to/4`

  A path may be built up as large as desired, using these functions as well as
  the functions above for moving the current point. However, nothing will
  be rendered onto the image until one of the following functions is called

  * `Xairo.stroke/1`
  * `Xairo.fill/1`

  `Xairo.stroke/1` will render all the lines created as part of the path, while
  `Xairo.fill/1` will render the lines as well as fill in the space between them. For
  simple convex paths, this will fill the entirely of the interior (assuming a
  line between the first and last coordinates of the path, if `close_path/1` has
  not been called). For more complex shapes, or instances where the path crosses
  over itself, cairo uses an internal algorithm to determine which portions, if
  any, to fill in.

  ### Modifying color, line width, etc.

  Because nothing is rendered until these functions are called, only the most
  recent function calls to set the path's color, line width, etc. will be taken
  into account. This means that to draw lines of different colors or widths, you
  must create and end different paths for each one. These functions can be
  called at any point before the path in initialized or during its extension,
  but if called multiple times, only the final invocation will be taken into
  account.

  These functions are:

  * `Xairo.set_source/2`
  * `Xairo.set_line_width/2`
  * `Xairo.set_line_cap/2`
  * `Xairo.set_line_join/2`
  * `Xairo.set_dash/3`

  To paint the entire image space (for example to set a background), you use

  * `Xairo.paint/1`

  after setting a color. If this function is never called, by default the
  background, when rendering to `.png`, will be transparent.

  ### Modifying and displaying text

  Basic text can be rendered as part of an image as well. `Xairo` provides
  access to Cairo's "toy font" API, which is designed to provide only simple
  tools for manipulating text. See `Xairo.FontFace`.

  Text is displayed using

  * `Xairo.show_text/2`

  Calling `Xairo.show_text/2` immediately renders the text given, instead of waiting
  for `Xairo.stroke/1` or `Xairo.fill/1` to be called. However, it does take the current
  path into account, beginning the text render at the current point, and
  advancing the current point after being rendered. See `Xairo.Text.Extents`
  for an explanation of how that distance is calculated.

  A font can be set using

  * `Xairo.set_font_face/2`
  * `Xairo.select_font_face/4`

  In additon, the size and positioning of the font can be set with

  * `Xairo.set_font_size/2`
  * `Xairo.set_font_matrix/2`

  `Xairo.set_font_matrix/2` allows setting a transformation matrix for the font face.
  See [Transformation matrices](#module-transformation-matrices) for an
  explanation of how to use these matrices.

  ### Transformation matrices

  The image context stores a "current transformation matrix" (CTM) that handles
  an affine transformation for points rendered on the image. Only a single CTM
  can be active at any time. When a new image is created, its CTM is set to the
  identity matrix: a scale value of 1 in the x and y directions, and 0 rotation,
  shearing, or translation.

  #### Modifying matrices

  The following functions update the CTM, applying their transformation after
  any existing transformations:

  * `Xairo.scale/3`
  * `Xairo.translate/3`
  * `Xairo.rotate/2`
  * `Xairo.transform/2`

  It is also possible to create a new matrix and perform these operations
  separately before replacing the CTM. See `Xairo.Matrix`.

  #### Replacing the CTM

  These functions will replace the CTM with a new matrix

  * `Xairo.set_matrix/2`
  * `Xairo.identity_matrix/1`

  You can also retrieve a `Xairo.Matrix` holding the current CTM by calling

  * `Xairo.matrix/1`

  #### Other uses for `Xairo.Matrix`

  Matrices can also be used to perform affine transformations on fonts and text
  by calling

  * `Xairo.set_font_matrix/2`
  """

  @typedoc """
  A 2-element tuple, consisting of the atom `:tuple` and an atom describing the error
  """
  @type error :: {:error, atom()}

  @typedoc """
  Shorthand for `type | nil`
  """
  @type or_error(a) :: a | error()

  @typedoc """
  The supported types of surfaces
  """
  @type surface ::
          Xairo.ImageSurface.t()
          | Xairo.PdfSurface.t()
          | Xairo.PsSurface.t()
          | Xairo.SvgSurface.t()

  @typedoc """
  Supported color patterns
  """
  @type pattern ::
          Xairo.RadialGradient.t()
          | Xairo.LinearGradient.t()
          | Xairo.Mesh.t()
          | Xairo.SolidPattern.t()
          | Xairo.SurfacePattern.t()

  @typedoc """
  The structs that can be set as the color source for a `Xairo.Image`
  """
  @type color_source ::
          pattern()
          | Xairo.ImageSurface.t()
          | Xairo.Rgba.t()

  @typedoc """
  Shorthand for an `{x, y}` coordinate pair without needing to create a new `Xairo.Point` or `Xairo.Vector`
  """
  @type coordinate_pair :: {number(), number()}

  @typedoc """
  Valid types for representing a vector in an image's coordinate system.
  """
  @type point :: Xairo.Point.t() | coordinate_pair()

  @typedoc """
  Valid types for representing a point in an image's coordinate system.
  """
  @type vector :: Xairo.Vector.t() | coordinate_pair()

  @typedoc """
  Valid options for an image's [antialias function](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-antialias-t)
  """
  @type antialias :: :default | :none | :gray | :subpixel | :fast | :good | :best

  @typedoc """
  Valid options for an image's [fill rule](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-fill-rule-t)
  """
  @type fill_rule :: :winding | :even_odd

  @typedoc """
  Valid options for an image's [line cap style](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-cap-t)
  """
  @type line_cap :: :butt | :round | :square

  @typedoc """
  Valid options for an image's [line join style](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-join-t)
  """
  @type line_join :: :miter | :round | :bevel

  @typedoc """
  Valid options for an image's [compositing operator](https://cairographics.org/operators/)
  """
  @type operator ::
          :clear
          | :source
          | :over
          | :in
          | :out
          | :atop
          | :dest
          | :dest_over
          | :dest_in
          | :dest_out
          | :dest_atop
          | :xor
          | :add
          | :saturate
          | :multiply
          | :screen
          | :overlay
          | :darken
          | :lighten
          | :color_dodge
          | :color_burn
          | :hard_light
          | :soft_light
          | :difference
          | :exclusion
          | :hsl_hue
          | :hsl_saturation
          | :hsl_color
          | :hsl_luminosity

  alias Xairo.{
    FontFace,
    Image,
    LinearGradient,
    Matrix,
    Mesh,
    Path,
    Point,
    RadialGradient,
    Rgba,
    SolidPattern,
    SurfacePattern,
    SvgSurface,
    Vector
  }

  alias Xairo.Native, as: N
  @type image :: Image.t()

  @doc """
  Appends a path to the end of the current path.
  """
  @doc section: :drawing
  @spec append_path(image(), Path.t()) :: image()
  def append_path(%Image{context: ctx} = image, %Path{path: path}) do
    N.context_append_path(ctx.context, path)
    image
  end

  @doc """
  Draws an arc defined by the given parameters.

  In addition to the `Xairo.Image` struct, this function takes the following
  arguments

  * the center point to draw the arc around
  * the arc's radius
  * the starting and stopping angles (given in radians)

  The arc is drawn clockwise between the two angles.
  """
  @doc section: :drawing
  @spec arc(image(), Xairo.point(), number(), number(), number()) :: image()
  def arc(%Image{context: ctx} = image, center, r, angle1, angle2) do
    N.context_arc(ctx.context, Point.from(center), r / 1, angle1 / 1, angle2 / 1)
    image
  end

  @doc """
  Draws a counterclockwise arc defined by the given parameters.

  This function is identical to `Xairo.arc/5` except for the direction in which
  the arc is drawn.
  """
  @doc section: :drawing
  @spec arc_negative(image(), Xairo.point(), number(), number(), number()) :: image()
  def arc_negative(%Image{context: ctx} = image, center, r, angle1, angle2) do
    N.context_arc_negative(ctx.context, Point.from(center), r / 1, angle1 / 1, angle2 / 1)
    image
  end

  @doc """
  Closes the path by drawing a straight line from the current point to the path's origin.
  """
  @doc section: :drawing
  @spec close_path(image()) :: image()
  def close_path(%Image{context: ctx} = image) do
    N.context_close_path(ctx.context)
    image
  end

  @doc """
  Copies the current path.
  """
  @doc section: :drawing
  @spec copy_path(image()) :: Xairo.or_error(Path.t())
  def copy_path(%Image{context: ctx}) do
    with {:ok, path} <- N.context_copy_path(ctx.context), do: Path.from(path)
  end

  @doc """
  Copies the current path, but replaces curves and arcs with
  a series of straight lines based on the context's tolerance value.
  """
  @doc section: :drawing
  @spec copy_path_flat(image()) :: Xairo.or_error(Path.t())
  def copy_path_flat(%Image{context: ctx}) do
    with {:ok, path} <- N.context_copy_path_flat(ctx.context), do: Path.from(path)
  end

  @doc """
  Draws a cubic Bézier curve with the given control points.

  The first control point of the curve is the context's path's current point, with
  the three arguments given to the function determining the remaining control points.
  """
  @doc section: :drawing
  @spec curve_to(image(), Xairo.point(), Xairo.point(), Xairo.point()) :: image()
  def curve_to(%Image{context: ctx} = image, point1, point2, point3) do
    N.context_curve_to(ctx.context, Point.from(point1), Point.from(point2), Point.from(point3))
    image
  end

  @doc """
  Renders the current path to the context's surface by filling it in.

  If the path overlaps itself, contained areas or filled based on the
  current setting for the fill rule.

  This function clears the current path.
  """
  @doc section: :drawing
  @spec fill(image()) :: Xairo.or_error(image())
  def fill(%Image{context: ctx} = image) do
    with {:ok, _} <- N.context_fill(ctx.context), do: image
  end

  @doc """
  Identical to `Xairo.fill/1` but preserves the current path.
  """
  @doc section: :drawing
  @spec fill_preserve(image()) :: Xairo.or_error(image())
  def fill_preserve(%Image{context: ctx} = image) do
    with {:ok, _} <- N.context_fill_preserve(ctx.context), do: image
  end

  @doc """
  Draws a straight line from the current point to the given point.
  """
  @doc section: :drawing
  @spec line_to(image(), Xairo.point()) :: image()
  def line_to(%Image{context: ctx} = image, point) do
    N.context_line_to(ctx.context, Point.from(point))
    image
  end

  @doc """
  Moves the current point to the given point.
  """
  @doc section: :drawing
  @spec move_to(image(), Xairo.point()) :: image()
  def move_to(%Image{context: ctx} = image, point) do
    N.context_move_to(ctx.context, Point.from(point))
    image
  end

  @doc """
  Clears the current path.

  After this is called there will be no path or current point.
  """
  @doc section: :drawing
  @spec new_path(image()) :: image()
  def new_path(%Image{context: ctx} = image) do
    N.context_new_path(ctx.context)
    image
  end

  @doc """
  Begins a new sub path.

  After this is called the current path is not affected, but there is no current
  point set.

  Often this function is not needed as new sub-paths are created by calls to
  `Xario.move_to/2`

    One instance where this function is useful is when you want to begin a new path with
    a call to `Xairo.arc/5` or its negative version. By calling this function
    you will skip needing to manually calculate and move to the arc's starting point
    to avoid a line being drawn from the current point to the beginning of the arc.
  """
  @doc section: :drawing
  @spec new_sub_path(image()) :: image()
  def new_sub_path(%Image{context: ctx} = image) do
    N.context_new_sub_path(ctx.context)
    image
  end

  @doc """
  Paints the current color source onto the entire surface area.
  """
  @doc section: :drawing
  @spec paint(image()) :: Xairo.or_error(image())
  def paint(%Image{context: ctx} = image) do
    with {:ok, _} <- N.context_paint(ctx.context), do: image
  end

  @doc """
  Identical to `Xairo.paint/1` but takes an additional argument specifying
  an alpha value to be applied across the entire surface area.
  """
  @doc section: :drawing
  @spec paint_with_alpha(image(), number()) :: Xairo.or_error(image())
  def paint_with_alpha(%Image{context: ctx} = image, alpha) do
    with {:ok, _} <- N.context_paint_with_alpha(ctx.context, alpha / 1), do: image
  end

  @doc """
  Draws a rectangle based on the given arguments.

  In addition to the `Xairo.Image` struct, this function takes the following
  arguments

  * an origin point representing the top-left corner of the rectangle
  * the width of the rectangle
  * the height of the rectangle

  Note that after this function is called, the current point for the context is the
  upper-left origin point of the rectangle, not the bottom-right.
  """
  @doc section: :drawing
  @spec rectangle(image(), Xairo.point(), number(), number()) :: image()
  def rectangle(%Image{context: ctx} = image, origin, width, height) do
    N.context_rectangle(ctx.context, Point.from(origin), width / 1, height / 1)
    image
  end

  @doc """
  Draws a cubic Bézier curve with the given control points relative to the path's current point.

    Whereas the arguments given to `Xairo.curve_to/4` are absolute points in userspace,
    the arguments given to this function are vectors defined relative to the first control point (the path's current point). It is important to note that all the control points are relative to the starting point, not to the calculated location of the previous argument.
  """
  @doc section: :drawing
  @spec rel_curve_to(image(), Xairo.vector(), Xairo.vector(), Xairo.vector()) :: image()
  def rel_curve_to(%Image{context: ctx} = image, vec1, vec2, vec3) do
    N.context_rel_curve_to(ctx.context, Vector.from(vec1), Vector.from(vec2), Vector.from(vec3))
    image
  end

  @doc """
  Draws a straight line from the current point to a point relative to the current point by
  the vector argument.
  """
  @doc section: :drawing
  @spec rel_line_to(image(), Xairo.vector()) :: image()
  def rel_line_to(%Image{context: ctx} = image, vec) do
    N.context_rel_line_to(ctx.context, Vector.from(vec))
    image
  end

  @doc """
  Moves the current point to a point relative to the current point by the
  vector argument.
  """
  @doc section: :drawing
  @spec rel_move_to(image(), Xairo.vector()) :: image()
  def rel_move_to(%Image{context: ctx} = image, vec) do
    N.context_rel_move_to(ctx.context, Vector.from(vec))
    image
  end

  @doc """
  Sets the current color data source for the context. This can be one of any
  struct defined as part of `t:Xairo.color_source/0`.
  """
  @doc section: :drawing
  @spec set_source(image(), Xairo.pattern()) :: Xairo.or_error(image())
  def set_source(%Image{context: ctx} = image, %Rgba{} = rgba) do
    N.context_set_source_rgba(ctx.context, rgba)
    %{image | context: %{ctx | source: SolidPattern.from_rgba(rgba)}}
  end

  def set_source(
        %Image{context: ctx} = image,
        %Xairo.LinearGradient{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_linear_gradient(ctx.context, pattern) do
      %{image | context: %{ctx | source: gradient}}
    end
  end

  def set_source(
        %Image{context: ctx} = image,
        %Xairo.RadialGradient{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_radial_gradient(ctx.context, pattern) do
      %{image | context: %{ctx | source: gradient}}
    end
  end

  def set_source(%Image{context: ctx} = image, %Xairo.SolidPattern{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_solid_pattern(ctx.context, pattern) do
      %{image | context: %{ctx | source: gradient}}
    end
  end

  def set_source(
        %Image{context: ctx} = image,
        %Xairo.SurfacePattern{pattern: pattern} = gradient
      ) do
    with {:ok, _} <- N.context_set_source_surface_pattern(ctx.context, pattern) do
      %{image | context: %{ctx | source: gradient}}
    end
  end

  def set_source(%Image{context: ctx} = image, %Xairo.Mesh{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_mesh(ctx.context, pattern) do
      %{image | context: %{ctx | source: gradient}}
    end
  end

  @doc """
  Sets the current color data source to be a `Xairo.Image`.

  In addition to the source surface, this function takes a point that defines the origin of the
  source surface on the target context.
  """
  @doc section: :drawing
  @spec set_source(image(), image(), Xairo.point()) :: Xairo.or_error(image())
  def set_source(
        %Image{context: ctx} = image,
        %Image{surface: source_surface},
        origin
      ) do
    with {:ok, _} <-
           N.context_set_source_surface(ctx.context, source_surface.surface, Point.from(origin)) do
      %{image | context: %{ctx | source: SurfacePattern.create(source_surface)}}
    end
  end

  @doc """
  Returns the currently set color data source for the context.
  """
  @doc section: :drawing
  @spec source(image()) :: Xairo.color_source()
  def source(%Image{context: ctx}), do: ctx.source

  @doc """
  Renders the current path to the context's surface by drawing along the path.

  This takes into account the context's settings for line width, join, and cap styles.

  This function clears the current path.
  """
  @doc section: :drawing
  @spec stroke(image()) :: Xairo.or_error(image())
  def stroke(%Image{context: ctx} = image) do
    with {:ok, _} <- N.context_stroke(ctx.context), do: image
  end

  @doc """
  Identical to `Xairo.stroke/1` but preserves the current path.
  """
  @doc section: :drawing
  @spec stroke_preserve(image()) :: Xairo.or_error(image())
  def stroke_preserve(%Image{context: ctx} = image) do
    with {:ok, _} <- N.context_stroke_preserve(ctx.context), do: image
  end

  @doc """
  Returns the surface from which the context was instantiated.

  This function retains underlying Cairo API name, which indicates
  that the associated surface is the target for the drawing operations
  called on the context.
  """
  @doc section: :init
  @spec target(image()) :: Xairo.surface()
  def target(%Image{surface: surface}), do: surface

  @doc """
  Sets the dash pattern that is used to draw lines when `Xairo.stroke/1`
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
  @spec set_dash(image(), [number()], number()) :: image()
  def set_dash(%Image{context: ctx} = image, dashes, offset) do
    N.context_set_dash(ctx.context, Enum.map(dashes, &(&1 / 1)), offset / 1)
    image
  end

  @doc """
  Returns the length of the list of dash segment widths.
  """
  @doc section: :drawing
  @spec dash_count(image()) :: integer()
  def dash_count(%Image{context: ctx}) do
    N.context_dash_count(ctx.context)
  end

  @doc """
  Returns a 2-element tuple containing the current dash segment list and offset.
  """
  @doc section: :drawing
  @spec dash(image()) :: {[number()], number()}
  def dash(%Image{context: ctx}) do
    N.context_dash(ctx.context)
  end

  @doc """
  Returns the current dash segment list.
  """
  @doc section: :drawing
  @spec dash_dashes(image()) :: [number()]
  def dash_dashes(%Image{context: ctx}) do
    N.context_dash_dashes(ctx.context)
  end

  @doc """
  Returns the current dash offset.
  """
  @doc section: :drawing
  @spec dash_offset(image()) :: number()
  def dash_offset(%Image{context: ctx}) do
    N.context_dash_offset(ctx.context)
  end

  #############
  ## CONFIG ##
  #############

  @doc """
  Returns the current document unit for an SVG image.
  """
  @doc section: :config
  @spec document_unit(image()) :: or_error(SvgSurface.document_unit())
  def document_unit(%Image{surface: %SvgSurface{} = surface}) do
    SvgSurface.document_unit(surface)
  end

  def document_unit(%Image{}), do: {:error, :cannot_get_document_unit_for_non_svg_image}

  @doc """
  Sets the document unit for an SVG image.

  This function can be called any number of times during the image's
  creation, but only the most recent setting before `Xairo.Image.save/1`
  is called on the image will be taken into account.
  """
  @doc section: :config

  @spec set_document_unit(image(), SvgSurface.document_unit()) :: or_error(image())
  def set_document_unit(%Image{surface: %SvgSurface{} = surface} = image, unit) do
    SvgSurface.set_document_unit(surface, unit)
    image
  end

  def set_document_unit(%Image{}, _unit),
    do: {:error, :cannot_set_document_unit_for_non_svg_image}

  @doc """
  Returns the current line width
  """
  @doc section: :config
  @spec line_width(image()) :: number()
  def line_width(%Image{context: ctx}) do
    N.context_line_width(ctx.context)
  end

  @doc """
  Sets the line width to be used in calls to `Xairo.stroke/1`
  """
  @doc section: :config
  @spec set_line_width(image(), number()) :: image()
  def set_line_width(%Image{context: ctx} = image, line_width) do
    N.context_set_line_width(ctx.context, line_width / 1)
    image
  end

  @doc """
  Sets the antialias strategy for how lines are rendered.

  See [Cairo documentation on antialias settings](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-antialias-t) for more details.
  """
  @doc section: :config
  @spec set_antialias(image(), Xairo.antialias()) :: image()
  def set_antialias(%Image{context: ctx} = image, antialias) do
    N.context_set_antialias(ctx.context, antialias)
    image
  end

  @doc """
  Returns the current antialias strategy.
  """
  @doc section: :config
  @spec antialias(image()) :: Xairo.antialias()
  def antialias(%Image{context: ctx}) do
    N.context_antialias(ctx.context)
  end

  @doc """
  Sets the fill rule for how `Xairo.fill/1` handles points where
  the path overlaps.

  See [Cairo documentation on the fill rule](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-fill-rule-t) for details on how the various rules apply.
  """
  @doc section: :config
  @spec set_fill_rule(image(), Xairo.fill_rule()) :: image()
  def set_fill_rule(%Image{context: ctx} = image, fill_rule) do
    N.context_set_fill_rule(ctx.context, fill_rule)
    image
  end

  @doc """
  Returns the current fill rule.
  """
  @doc section: :config
  @spec fill_rule(image()) :: Xairo.fill_rule()
  def fill_rule(%Image{context: ctx}) do
    N.context_fill_rule(ctx.context)
  end

  @doc """
  Sets the line cap style.

  See [Cairo documentation on line caps](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-cap-t).
  """
  @doc section: :config
  @spec set_line_cap(image(), Xairo.line_cap()) :: image()
  def set_line_cap(%Image{context: ctx} = image, line_cap) do
    N.context_set_line_cap(ctx.context, line_cap)
    image
  end

  @doc """
  Returns the current line cap setting
  """
  @doc section: :config
  @spec line_cap(image()) :: Xairo.line_cap()
  def line_cap(%Image{context: ctx}) do
    N.context_line_cap(ctx.context)
  end

  @doc """
  Sets the rule for line joins.

  See [Cairo documentation about line joins](https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-join-t)
  """
  @doc section: :config
  @spec set_line_join(image(), Xairo.line_join()) :: image()
  def set_line_join(%Image{context: ctx} = image, line_join) do
    N.context_set_line_join(ctx.context, line_join)
    image
  end

  @doc """
  Returns the current line join setting
  """
  @doc section: :config
  @spec line_join(image()) :: Xairo.line_join()
  def line_join(%Image{context: ctx}) do
    N.context_line_join(ctx.context)
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
  @spec set_miter_limit(image(), number()) :: image()
  def set_miter_limit(%Image{context: ctx} = image, miter_limit) do
    N.context_set_miter_limit(ctx.context, miter_limit / 1)
    image
  end

  @doc """
  Returns the current value of the miter limit
  """
  @doc section: :config
  @spec miter_limit(image()) :: number()
  def miter_limit(%Image{context: ctx}) do
    N.context_miter_limit(ctx.context)
  end

  @doc """
  Returns the current tolerance for the context.

  This value determines how curves are segmented when calling `Xairo.copy_path_flat/1`.
  """
  @doc section: :config
  @spec tolerance(image()) :: number()
  def tolerance(%Image{context: ctx}), do: N.context_tolerance(ctx.context)

  @doc """
  Sets the tolerance value for the context.
  """
  @doc section: :config
  @spec set_tolerance(image(), number()) :: image()
  def set_tolerance(%Image{context: ctx} = image, tolerance) do
    N.context_set_tolerance(ctx.context, tolerance / 1)
    image
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
  @spec set_operator(image(), Xairo.operator()) :: image()
  def set_operator(%Image{context: ctx} = image, operator) do
    N.context_set_operator(ctx.context, operator)
    image
  end

  @doc """
  Returns the current operator set for the context.
  """
  @doc section: :config
  @spec operator(image()) :: Xairo.operator()
  def operator(%Image{context: ctx}) do
    N.context_operator(ctx.context)
  end

  #################
  # CALCULATIONS #
  #################

  @doc """
  Returns the current point for the context, or a point at {0, 0} when there
  is no current point.

  Can also return an error if the state of the context has become corrupted.
  """
  @doc section: :calc
  @spec current_point(image()) :: Xairo.or_error(Point.t())
  def current_point(%Image{context: ctx}) do
    with {:ok, point} <- N.context_current_point(ctx.context), do: point
  end

  @doc """
  Returns whether there is a current point set for the context.

  This will be false for a brand new context, and after `Xairo.stroke/1` or
  `Xairo.fill/1` has been called and the path has been cleared.

  Can also return an error if the state of the context has become corrupted.
  """
  @doc section: :calc
  @spec has_current_point(image()) :: Xairo.or_error(boolean())
  def has_current_point(%Image{context: ctx}) do
    with {:ok, boolean} <- N.context_has_current_point(ctx.context), do: boolean
  end

  @doc """
  Returns whether the given point falls in the region painted by a call to
  `Xairo.stroke/1`
  """
  @doc section: :calc
  @spec in_stroke(image(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_stroke(%Image{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_stroke(ctx.context, Point.from(point)), do: bool
  end

  @doc """
  Returns whether the given point falls in the region painted by a call to
  `Xairo.fill/1`
  """
  @doc section: :calc
  @spec in_fill(image(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_fill(%Image{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_fill(ctx.context, Point.from(point)), do: bool
  end

  @doc """
  Returns whether the given point is included inside the current clip region.
  """
  @doc section: :calc
  @spec in_clip(image(), Xairo.point()) :: Xairo.or_error(boolean())
  def in_clip(%Image{context: ctx}, point) do
    with {:ok, bool} <- N.context_in_clip(ctx.context, Point.from(point)), do: bool
  end

  @doc """
  Returns the bounding box for the current clip region.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec clip_extents(image()) :: Xairo.or_error({Point.t(), Point.t()})
  def clip_extents(%Image{context: ctx}) do
    with {:ok, extents} <- N.context_clip_extents(ctx.context), do: extents
  end

  @doc """
  Returns a list of rectangles that describe the current clip region of the
  context.

  Will return an error if the current clip region cannot be represented by rectangles
  (e.g. the clip region was defined using `Xairo.arc/5`,
  `Xairo.curve_to/4`, etc).

  The rectangles are each defined by a 3-element tuple of
  `{upper-left-corner, width, height}`
  """
  @doc section: :calc
  @spec clip_rectangle_list(image()) :: Xairo.or_error([{Point.t(), number(), number()}])
  def clip_rectangle_list(%Image{context: ctx}) do
    with {:ok, rectangle_list} <- N.context_clip_rectangle_list(ctx.context),
         do: rectangle_list
  end

  @doc """
  Converts a point or vector in userspace to its actual location on the surface, determined
  by the current transformation matrix.

  When converting a vector, this function does *not* take into account the x and y
  translation values of the CTM.
  """
  @doc section: :calc
  @spec user_to_device(image(), Point.t()) :: Point.t()
  @spec user_to_device(image(), Vector.t()) :: Vector.t()
  def user_to_device(%Image{context: ctx}, %Point{} = point) do
    N.context_user_to_device(ctx.context, point)
  end

  def user_to_device(%Image{context: ctx}, %Vector{} = vec) do
    with {:ok, distance} <- N.context_user_to_device_distance(ctx.context, vec),
         do: distance
  end

  @doc """
  Converts a point or vector in absolute image space to userspace, as determined
  by the current transformation matrix.

  When converting a vector, this function does *not* take into account the x and y
  translation values of the CTM.
  """
  @doc section: :calc
  @spec device_to_user(image(), Point.t()) :: Point.t()
  @spec device_to_user(image(), Vector.t()) :: Vector.t()
  def device_to_user(%Image{context: ctx}, %Point{} = point) do
    with {:ok, distance} <- N.context_device_to_user(ctx.context, point),
         do: distance
  end

  def device_to_user(%Image{context: ctx}, %Vector{} = vec) do
    with {:ok, distance} <- N.context_device_to_user_distance(ctx.context, vec),
         do: distance
  end

  @doc """
  Returns the bounding box for the current path.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec path_extents(image()) :: Xairo.or_error({Point.t(), Point.t()})
  def path_extents(%Image{context: ctx}) do
    with {:ok, extents} <- N.context_path_extents(ctx.context), do: extents
  end

  @doc """
  Returns the bounding box for the colored area by a call to `Xairo.fill/1`
  given the current path.

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.
  """
  @doc section: :calc
  @spec fill_extents(image()) :: Xairo.or_error({Point.t(), Point.t()})
  def fill_extents(%Image{context: ctx}) do
    with {:ok, extents} <- N.context_fill_extents(ctx.context), do: extents
  end

  @doc """
  Returns the bounding box for the colored area by a call to `Xairo.stroke/1`
  given the current path.

  This bounding box takes into account the currently set line width, as well as line
  cap and join styles

  The bounding box is represented by a 2-element tuple containing the top-left
  and bottom-right corners of the box.

  """
  @doc section: :calc
  @spec stroke_extents(image()) :: Xairo.or_error({Point.t(), Point.t()})
  def stroke_extents(%Image{context: ctx}) do
    with {:ok, extents} <- N.context_stroke_extents(ctx.context), do: extents
  end

  @doc section: :calc
  defdelegate font_extents(image), to: Xairo.FontExtents, as: :for

  @doc section: :calc
  defdelegate text_extents(image, text), to: Xairo.TextExtents, as: :for

  #########
  # TEXT #
  #########

  @doc """
  Prints the given text to the surface.

  This function will immediately render the text and move the current point
  to the end of its output. It does not affect the current path.
  """
  @doc section: :text
  @spec show_text(image(), String.t()) :: Xairo.or_error(image())
  def show_text(%Image{context: ctx} = image, text) do
    with {:ok, _} <- N.context_show_text(ctx.context, text), do: image
  end

  @doc """
  Sets the font size for the context and surface.
  """
  @doc section: :text
  @spec set_font_size(image(), number()) :: image()
  def set_font_size(%Image{context: ctx} = image, font_size) do
    N.context_set_font_size(ctx.context, font_size / 1)
    image
  end

  @doc """
  Adds the outline of the given text to the current path.

  Unlike `Xairo.show_text/2`, this does not render anything to the surface
  until a call to `Xairo.fill/1` or `Xairo.stroke/1` is made.

  Calling this function followed by `Xairo.fill/1` is equivalent
  to calling `Xairo.show_text/2` with the same text.
  """
  @doc section: :text
  @spec text_path(image(), String.t()) :: image()
  def text_path(%Image{context: ctx} = image, text) do
    N.context_text_path(ctx.context, text)
    image
  end

  @doc """
  Returns the current font face for the context.
  """
  @doc section: :text
  @spec font_face(image()) :: FontFace.t()
  def font_face(%Image{context: ctx}) do
    ctx.font_face
  end

  @doc """
  Sets the font face for the context.

  See `Xairo.FontFace` for more details.
  """
  @doc section: :text
  @spec set_font_face(image(), FontFace.t()) :: image()
  def set_font_face(%Image{context: ctx} = image, %FontFace{font_face: font_face} = ff) do
    N.context_set_font_face(ctx.context, font_face)
    %{image | context: %{ctx | font_face: ff}}
  end

  @doc """
  Sets the current font face for the context by passing in the individual components
  of the font face.

  See `Xairo.FontFace` for more details about what those arguments should be.
  """
  @doc section: :text
  @spec select_font_face(image(), String.t(), FontFace.slant(), FontFace.weight()) :: image()
  def select_font_face(%Image{context: ctx} = image, family, slant, weight) do
    with font_face <- N.context_select_font_face(ctx.context, family, slant, weight),
         do: %{image | context: %{ctx | font_face: %FontFace{font_face: font_face}}}
  end

  ##############
  # TRANSFORM #
  ##############

  @doc """
  Applies the specified x and y scaling to the context's current
  transformation matrix.
  """
  @doc section: :transform
  @spec scale(image(), number(), number()) :: image()
  def scale(%Image{context: ctx} = image, sx, sy) do
    N.context_scale(ctx.context, sx / 1, sy / 1)
    image
  end

  @doc """
  Returns the context's current transformation matrix.
  """
  @doc section: :transform
  @spec matrix(image()) :: Matrix.t()
  def matrix(%Image{context: ctx}) do
    %Matrix{matrix: N.context_matrix(ctx.context)}
  end

  @doc """
  Applies the specified rotation (in radians) to the context's
  current transformation matrix.
  """
  @doc section: :transform
  @spec rotate(image(), number()) :: image()
  def rotate(%Image{context: ctx} = image, radians) do
    N.context_rotate(ctx.context, radians / 1)
    image
  end

  @doc """
  Applies the specified x and y translations to the context's current
  transformation matrix.
  """
  @doc section: :transform
  @spec translate(image(), number(), number()) :: image()
  def translate(%Image{context: ctx} = image, tx, ty) do
    N.context_translate(ctx.context, tx / 1, ty / 1)
    image
  end

  @doc """
  Returns the current font matrix.
  """
  @doc section: :transform
  @spec font_matrix(image()) :: Matrix.t()
  def font_matrix(%Image{context: ctx}) do
    %Matrix{matrix: N.context_font_matrix(ctx.context)}
  end

  @doc """
  Sets the transformation matrix for text rendered to the surface.

  These transformations are added to any transformations applied by the
  context's transformation matrix.
  """
  @doc section: :transform
  @spec set_font_matrix(image(), Matrix.t()) :: image()
  def set_font_matrix(%Image{context: ctx} = image, %Matrix{matrix: matrix}) do
    N.context_set_font_matrix(ctx.context, matrix)
    image
  end

  @doc """
  Sets the current transformation matrix to the identity matrix.
  """
  @doc section: :transform
  @spec identity_matrix(image()) :: image()
  def identity_matrix(%Image{context: ctx} = image) do
    N.context_identity_matrix(ctx.context)
    image
  end

  @doc """
  Applies the transformations in the given matrix to the end of the
  context's current transformation matrix.
  """
  @doc section: :transform
  @spec transform(image(), Matrix.t()) :: image()
  def transform(%Image{context: ctx} = image, %Matrix{matrix: matrix}) do
    N.context_transform(ctx.context, matrix)
    image
  end

  @doc """
  Sets the given matrix as the context's current transformation matrix.

  This replaces any other modifications on the CTM.
  """
  @doc section: :transform
  @spec set_matrix(image(), Matrix.t()) :: image()
  def set_matrix(%Image{context: ctx} = image, %Matrix{matrix: matrix}) do
    N.context_set_matrix(ctx.context, matrix)
    image
  end

  #########
  # MASK #
  #########

  @doc """
  Paints the current source applying the `alpha` values from the given pattern as a mask.
  """
  @doc section: :mask
  @spec mask(image(), Xairo.pattern()) :: Xairo.or_error(image())
  def mask(%Image{context: ctx} = image, %RadialGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_radial_gradient(ctx.context, pattern), do: image
  end

  def mask(%Image{context: ctx} = image, %LinearGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_linear_gradient(ctx.context, pattern), do: image
  end

  def mask(%Image{context: ctx} = image, %Mesh{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_mesh(ctx.context, pattern), do: image
  end

  def mask(%Image{context: ctx} = image, %SolidPattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_solid_pattern(ctx.context, pattern), do: image
  end

  def mask(%Image{context: ctx} = image, %SurfacePattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_surface_pattern(ctx.context, pattern), do: image
  end

  @doc """
  Like `Xairo.mask/2` but uses the `alpha` channel from a `Xairo.ImageSurface` as the mask.

  `Xairo.mask_surface/3` also takes a point argument as the origin at which to
  situate the masking surface.
  """
  @doc section: :mask
  @spec mask_surface(image(), image(), Xairo.point()) :: Xairo.or_error(image())
  def mask_surface(%Image{context: ctx} = image, %Image{surface: surface}, origin) do
    with {:ok, _} <- N.context_mask_surface(ctx.context, surface.surface, Point.from(origin)),
         do: image
  end

  #########
  # CLIP #
  #########

  @doc """
  Sets a new clip region by intersecting the current clip region with the current path.

  This function clears the current path.

  Clipping calculates an intersection, so it can only make the clip region smaller. This region
  applies to all drawing operations by effectively masking any changes outside the current clip
  region.
  """
  @doc section: :clip
  @spec clip(image()) :: image()
  def clip(%Image{context: ctx} = image) do
    N.context_clip(ctx.context)
    image
  end

  @doc """
  Identical to `Xairo.clip/1` but preserves the current path.
  """
  @doc section: :clip
  @spec clip_preserve(image()) :: image()
  def clip_preserve(%Image{context: ctx} = image) do
    N.context_clip_preserve(ctx.context)
    image
  end

  @doc """
  Resets the clip region to the entire image surface area.
  """
  @doc section: :clip
  @spec reset_clip(image()) :: image()
  def reset_clip(%Image{context: ctx} = image) do
    N.context_reset_clip(ctx.context)
    image
  end
end
