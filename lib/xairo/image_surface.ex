defmodule Xairo.ImageSurface do
  @moduledoc """
  Models a drawing surface that renders its contents to disk in PNG format.

  ## Modifying the surface

  Once a surface is created, it is passed into a `Xairo.Context` via
  `Xairo.Context.new/1`. After that all commands that render content on to
  the surface are called via the API in the `Xairo.Context` module.

  ## Saving the surface

    When an [`ImageSurface`](`__MODULE__`) is ready to be saved to disk, call [`ImageSurface.write_to_png/2`](`__MODULE__.write_to_png/2`), passing in the surface struct and a filename ending in ".png".

  """

  defstruct [:surface]

  @typedoc """
  Elixir model of the image surface. Stores a reference to the in-memory
  representation of the surface.
  """
  @type t :: %__MODULE__{
          surface: reference()
        }
  @type format :: :argb32 | :rgb24 | :a8 | :a1 | :rgb16_565 | :rgb30

  alias Xairo.Native, as: N

  @doc """
  Creates a new image surface that can be attached to a `Xairo.Context`

  This function takes three arguments
  * a color data storage format (see `t:format/0` for the available options)
  * a width in pixels
  * a height in pixels

  The width and height define the userspace coordinates for the surface,
  rather than the size of the final image (which is determined by the associated
  `Xairo.Context`'s transformation matrix.
  """
  @spec create(format(), integer(), integer()) :: t()
  def create(format, width, height) do
    with {:ok, surface} <- N.image_surface_create(format, width, height),
         do: %__MODULE__{surface: surface}
  end

  @doc """
  Attempts to save the surface to the location on disk provided by the filename.

  This function will not create any subdirectories in the desired filepath that do
  not exist, and will return an error instead.
  """
  @spec write_to_png(t(), String.t()) :: Xairo.or_error(:ok)
  def write_to_png(%__MODULE__{surface: surface}, filename) do
    with {:ok, _} <- N.image_surface_write_to_png(surface, filename), do: :ok
  end

  @doc """
  Returns the width of the surface in userspace
  """
  @spec width(t()) :: integer()
  def width(%__MODULE__{surface: surface}) do
    N.image_surface_width(surface)
  end

  @doc """
  Returns the width of the surface in userspace
  """
  @spec height(t()) :: integer()
  def height(%__MODULE__{surface: surface}) do
    N.image_surface_height(surface)
  end

  @doc """
  Returns the "stride" of the surface

  The stride refers to the distance in bytes from the beginning of one row
  of image data to the beginning of the next row. This is a function of the
  surface's width and format

  ## Examples

  A 100x100 pixel image surface with data format `:argb32` will have a stride of 400
  (100 pixels per row * 4 bytes (32 bits) of color data per pixel)

      iex> ImageSurface.create(:argb32, 100, 100)
      ...> |> ImageSurface.stride()
      400

  A 100x100 pixel image surface with data format `:a8` will have a stride of 100
  (100 pixels per row * 1 byte (8 bits) of color data per pixel)

      iex> ImageSurface.create(:a8, 100, 100)
      ...> |> ImageSurface.stride()
      100

  """
  @spec stride(t()) :: integer()
  def stride(%__MODULE__{surface: surface}) do
    N.image_surface_stride(surface)
  end

  @doc """
  Returns the color data storage format of the image surface.
  """
  @spec format(t()) :: format()
  def format(%__MODULE__{surface: surface}) do
    N.image_surface_format(surface)
  end
end
