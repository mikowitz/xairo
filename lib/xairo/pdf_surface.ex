defmodule Xairo.PdfSurface do
  @moduledoc """
  Models a drawing surface that renders its contents to disk in PDF format.

  ## Creating the surface

  Once `Xairo.PdfSurface.new/3` is called, cairo will immediately create the named image
  on the filesystem. If the filepath contains diretories that do not exist, this
  function will return an error tuple instead.

  ## Modifying the surface

  Once a surface is created, it is passed into a `Xairo.Context` via
  `Xairo.Context.new/1`. After that all commands that render content on to
  the surface are called via the API in the `Xairo.Context` module.

  ## Finishing the surface

  When you are ready to complete the image, call `Xairo.PdfSurface.finish/1`, passing
  in the `Xairo.PdfSurface` struct. This will inform cairo that drawing has been
  completed on the surface and any intermediary objects created during the drawing
  process can be released.

  """
  defstruct [:surface]

  @typedoc """
  Elixir model of the PDF surface. Stores a reference to the in-memory
  representation of the surface.
  """
  @type t :: %__MODULE__{
          surface: reference()
        }

  alias Xairo.Native, as: N

  @doc """
  Creates a new PDF surface that can be attached to a `Xairo.Context`

  This function takes three arguments
  * a width in pixels
  * a height in pixels
  * a path to a location on the filesystem at which to write the image

  The width and height define the userspace coordinates for the surface,
  rather than the size of the final image (which is determined by the associated
  `Xairo.Context`'s transformation matrix.
  """
  @spec new(number(), number(), String.t()) :: Xairo.or_error(t())
  def new(width, height, path) do
    with {:ok, surface} <- N.pdf_surface_new(width / 1, height / 1, path),
         do: %__MODULE__{surface: surface}
  end

  @doc """
  Tells the underlying cairo library that the image is complete.
  """
  @spec finish(t()) :: t()
  def finish(%__MODULE__{surface: s} = surface) do
    N.pdf_surface_finish(s)
    surface
  end
end
