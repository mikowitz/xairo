defmodule Xairo.SvgSurface do
  @moduledoc """
  Models a drawing surface that renders its contents to disk in SVG format.
    #
  ## Creating the surface

  Once `Xairo.SvgSurface.new/3` is called, cairo will immediately create the named image
  on the filesystem. If the filepath contains diretories that do not exist, this
  function will return an error tuple instead.

  ## Modifying the surface

  Once a surface is created, it is passed into a `Xairo.Context` via
  `Xairo.Context.new/1`. After that all commands that render content on to
  the surface are called via the API in the `Xairo.Context` module.

  ### Scaling

  While the translation from userspace to imagespace can be scaled via
  `Xairo.Context.scale/3`, the final size of the SVG image can be scaled by
  changing its document unit via `Xairo.SvgSurface.set_document_unit/2` at
  any point during its creation. It can be called at any time, and even multiple
  times, but only the unit set most recently before calling `Xairo.SvgSurface.finish/1`
  will have an effect on the final image.

  ### Document units

  The document unit for an `Image.Svg` can be set in a call to `Xairo.SvgSurface.set_document_unit/2` at any point during the image lifecycle. This is the unit that will determine the final width and height of the image, and the unit of the coordinate grid for positioning and rendering paths

  Unit types are represented by atoms, and can be any of the following:

  - `:px` - one pixel
  - `:pt` - one point: this is the default unit if none is specified, and is equal to 1.333 pixels
  - `:in` - one inch (96 pixels)
  - `:cm` - one centimeter (~ 37.8 pixels)
  - `:mm` - one millimeter (~ 3.78 pixels)
  - `:pc` - one pica (1/6 inch, 16 pixels)
  - `:em` - the size of the element's font (ends up ~ 12 pixels)
  - `:ex` - the x-height of the element's font (ends up ~ 1/2 of the :em value, or ~ 6 pixels)
  - `:user` - pulled from lower level OS settings. Usually equivalent to a pixel.
  - `:percent` - some percent of another reference value (in my tests, this ends up being 200%)

  ## Finishing the surface

  When you are ready to complete the image, call `Xairo.SvgSurface.finish/1`, passing
  in the `Xairo.SvgSurface` struct. This will inform cairo that drawing has been
  completed on the surface and any intermediary objects created during the drawing
  process can be released.
  """

  defstruct [:surface]

  @typedoc """
  Elixir model of the SVG surface. Stores a reference to the in-memory
  representation of the surface.
  """
  @type t :: %__MODULE__{
          surface: reference()
        }
  @type document_unit :: :cm | :em | :ex | :in | :mm | :pc | :percent | :pt | :px | :user

  alias Xairo.Native, as: N

  @doc """
  Creates a new SVG surface that can be attached to a `Xairo.Context`

  This function takes three arguments
  * a width in document units
  * a height in document units
  * a path to a location on the filesystem at which to write the image

  By default the document unit is `:pt`

  The width and height define the userspace coordinates for the surface,
  rather than the size of the final image (which is determined by the associated
  `Xairo.Context`'s transformation matrix.
  """
  @spec new(number(), number(), String.t()) :: t()
  def new(width, height, path) do
    with {:ok, surface} <- N.svg_surface_new(width / 1, height / 1, path),
         do: %__MODULE__{surface: surface}
  end

  @doc """
  Tells the underlying cairo library that the image is complete.
  """
  @spec finish(t()) :: t()
  def finish(%__MODULE__{surface: s} = surface) do
    N.svg_surface_finish(s)
    surface
  end

  @doc """
  Returns the current document unit for the surface.
  """
  @spec document_unit(t()) :: document_unit()
  def document_unit(%__MODULE__{surface: surface}) do
    N.svg_surface_document_unit(surface)
  end

  @doc """
  Sets the document unit for the surface.

  This function can be called any number of times during the image's
  creation, but only the most recent setting before `Xairo.SvgSurface.finish/1`
  is called will be taken into account.
  """
  @spec set_document_unit(t(), document_unit()) :: t()
  def set_document_unit(%__MODULE__{surface: s} = surface, unit) do
    N.svg_surface_set_document_unit(s, unit)
    surface
  end
end
