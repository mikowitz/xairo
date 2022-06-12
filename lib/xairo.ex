defmodule Xairo do
  @moduledoc """
  The top-level module for the Xairo 2D graphics library.

  This module provides overarching documentation for the `Xairo` library
  and definitions for shared typespecs, see `Xairo.Context` for the bulk
  of the public API.

  ### Userspace and scale

  A discussion of userspace, imagespace, and scaling will be useful to understand how
  your drawing commands are communicated to and rendered on the underlying Cairo surface.

  All points and vectors you provide to the drawing functions below are given in "userspace"
  coordinates. That is, the coordinates relative to the size of the image you define.

  For example, the following would draw a line from {10, 10} to {90, 90} on a 100x100 pixel image

      surface = ImageSurface.new(:argb32, 100, 100)
      context =
        Context.new(surface)
        |> Context.move_to(10, 10)
        |> Context.line_to(90, 90)

  If you scale the context by a factor of 2 in both directions and draw the same line,
  it will render a line from {20, 20} to {180, 180}, rendering a significant portion of
  the line off your canvas!

      surface = ImageSurface.new(:argb32, 100, 100)
      context =
        Context.new(surface)
        |> Context.scale(2, 2)
        |> Context.move_to(10, 10)
        |> Context.line_to(90, 90)

  If your goal was to create a scaled-up version of the first image, this obviously does
  not work. This is because scaling the context does nothing to the size of the underlying
  surface. In order to get the expected result, you would need to scale the dimensions of
  your surface by the same factors

      surface = ImageSurface.new(:argb32, 200, 200)
      context =
        Context.new(surface)
        |> Context.scale(2, 2)
        |> Context.move_to(10, 10)
        |> Context.line_to(90, 90)

  One solution to avoid mismatched scales is simply to lift the scale factors up to the
  top level of your project and make sure they are applied.

      scale = 2
      surface = ImageSurface.new(:argb32, 100 * scale, 100 * scale)
      context =
        Context.new(surface)
        |> Context.scale(scale, scale)
        |> Context.move_to(10, 10)
        |> Context.line_to(90, 90)

  This way you can change the scale and be sure that it will be applied everywhere it
  needs to be for the image to render correctly. This strategy is useful when prototyping
  designs. You can use a small scale value to reduce the time it takes to render the image
  while it is in progress, and scale up only for the final output.

  ### How cairo renders images

  Cairo creates images by building up paths, or collections of moving to and
  drawing between points on the image space. These paths can be initiated by
  moving to a point, which is set as the current point of the path, using the
  functions

  * `Xairo.Context.move_to/2`
  * `Xairo.Context.rel_move_to/2`

  `move_to/2` takes as its second parameter an absolute coordinate in userspace
  (see above for an explanation), while `rel_move_to/2` takes a vector defining
  the distance to the new point relative to the previous current point.

  Once a current point has been set, the path can be appended to by using any of
  these functions

  * `Xairo.Context.line_to/2`
  * `Xairo.Context.rel_line_to/2`
  * `Xairo.Context.rectangle/4`
  * `Xairo.Context.arc/5`
  * `Xairo.Context.arc_negative/5`
  * `Xairo.Context.curve_to/4`
  * `Xairo.Context.rel_curve_to/4`

  A path may be built up as large as desired, using these functions as well as
  the functions above for moving the current point. However, nothing will
  be rendered onto the image until one of the following functions is called

  * `Xairo.Context.stroke/1`
  * `Xairo.Context.fill/1`

  `Xairo.Context.stroke/1` will render all the lines created as part of the path, while
  `Xairo.Context.fill/1` will render the lines as well as fill in the space between them. For
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

  * `Xairo.Context.set_source/2`
  * `Xairo.Context.set_line_width/2`
  * `Xairo.Context.set_line_cap/2`
  * `Xairo.Context.set_line_join/2`
  * `Xairo.Context.set_dash/3`

  To paint the entire image space (for example to set a background), you use

  * `Xairo.Context.paint/1`

  after setting a color. If this function is never called, by default the
  background, when rendering to `.png`, will be transparent.

  ### Modifying and displaying text

  Basic text can be rendered as part of an image as well. `Xairo` provides
  access to Cairo's "toy font" API, which is designed to provide only simple
  tools for manipulating text. See `Xairo.FontFace`.

  Text is displayed using

  * `Xairo.Context.show_text/2`

  Calling `Xairo.Context.show_text/2` immediately renders the text given, instead of waiting
  for `Xairo.Context.stroke/1` or `Xairo.Context.fill/1` to be called. However, it does take the current
  path into account, beginning the text render at the current point, and
  advancing the current point after being rendered. See `Xairo.Text.Extents`
  for an explanation of how that distance is calculated.

  A font can be set using

  * `Xairo.Context.set_font_face/2`
  * `Xairo.Context.select_font_face/4`

  In additon, the size and positioning of the font can be set with

  * `Xairo.Context.set_font_size/2`
  * `Xairo.Context.set_font_matrix/2`

  `Xairo.Context.set_font_matrix/2` allows setting a transformation matrix for the font face.
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

  * `Xairo.Context.scale/3`
  * `Xairo.Context.translate/3`
  * `Xairo.Context.rotate/2`
  * `Xairo.Context.transform/2`

  It is also possible to create a new matrix and perform these operations
  separately before replacing the CTM. See `Xairo.Matrix`.

  #### Replacing the CTM

  These functions will replace the CTM with a new matrix

  * `Xairo.Context.set_matrix/2`
  * `Xairo.Context.identity_matrix/1`

  You can also retrieve a `Xairo.Matrix` holding the current CTM by calling

  * `Xairo.Context.matrix/1`

  #### Other uses for `Xairo.Matrix`

  Matrices can also be used to perform affine transformations on fonts and text
  by calling

  * `Xairo.Context.set_font_matrix/2`
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
  The structs that can be set as the color source for a `Xairo.Context`
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
end
