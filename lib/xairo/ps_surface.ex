defmodule Xairo.PsSurface do
  @moduledoc """
  Models a drawing surface that renders its contents to disk in Postscript format.

  ## Creating the surface

  Once `Xairo.PsSurface.new/3` is called, cairo will immediately create the named image
  on the filesystem. If the filepath contains diretories that do not exist, this
  function will return an error tuple instead.

  ## Modifying the surface

  Once a surface is created, it is passed into a `Xairo.Context` via
  `Xairo.Context.new/1`. After that all commands that render content on to
  the surface are called via the API in the `Xairo.Context` module.

  ## Finishing the surface

  When you are ready to complete the image, call `Xairo.PsSurface.finish/1`, passing
  in the `Xairo.PsSurface` struct. This will inform cairo that drawing has been
  completed on the surface and any intermediary objects created during the drawing
  process can be released.

  """
  defstruct [:surface]

  @typedoc """
  Elixir model of the Postscript surface. Stores a reference to the in-memory
  representation of the surface.
  """
  @type t :: %__MODULE__{
          surface: reference()
        }

  alias Xairo.Native, as: N

  @doc """
  Creates a new Postscript surface that can be attached to a `Xairo.Context`

  This function takes three arguments
  * a width in pixels
  * a height in pixels
  * a path to a location on the filesystem at which to write the image

  The width and height define the userspace coordinates for the surface,
  rather than the size of the final image (which is determined by the associated
  `Xairo.Context`'s transformation matrix.
  """
  def new(width, height, path) do
    with {:ok, surface} <- N.ps_surface_new(width / 1, height / 1, path),
         do: %__MODULE__{surface: surface}
  end

  @doc """
  Tells the underlying cairo library that the image is complete.
  """
  def finish(%__MODULE__{surface: s} = surface) do
    N.ps_surface_finish(s)
    surface
  end
end
