defmodule Xairo.Surface.Image do
  @moduledoc """
  Module for working with image-backed surfaces.
  """

  alias Xairo.NIF
  alias Xairo.Surface
  @type format :: :argb32 | :rgb24 | :a8 | :a1 | :rgb16_565 | :rgb96f | :rgba128f

  @formats ~w(argb32 rgb24 a8 a1 rgb16_565 rgb96f rgba128f)a

  @doc """
  Creates a `Xairo.Surface.Image` of the specified format and dimensions.

  Initially the surface contents are set to 0. (Specifically, within each
  pixel, each color or alpha channel belonging to format will be 0. The
  contents of bits within a pixel, but not belonging to the given format are
  undefined).
  """
  @spec create(format(), non_neg_integer(), non_neg_integer()) ::
          {:ok, Surface.t()} | {:error, atom()}
  def create(format, width, height) when format in @formats and width >= 0 and height >= 0 do
    NIF.image_surface_create(format, width, height)
  end

  @doc """
  Creates a new image surface and initializes the contents to the given PNG file.
  """
  @spec create_from_png(String.t()) :: {:ok, Surface.t()} | {:error, atom()}
  def create_from_png(filename) when is_bitstring(filename) do
    NIF.image_surface_create_from_png(filename)
  end

  @doc """
  Get the width of `surface` in pixels.
  """
  @spec get_width(Surface.t()) :: integer()
  def get_width(surface), do: NIF.image_surface_get_width(surface)

  @doc """
  Get the height of `surface` in pixels.
  """
  @spec get_height(Surface.t()) :: integer()
  def get_height(surface), do: NIF.image_surface_get_height(surface)

  @doc """
  Get the format of `surface`.
  """
  @spec get_format(Surface.t()) :: atom() | {:error, atom()}
  def get_format(surface), do: NIF.image_surface_get_format(surface)

  @doc """
  Get the stride of `surface` in bytes.

  The stride is the distance in bytes from the beginning of one row of the
  image data to the beginning of the next row.
  """
  @spec get_stride(Surface.t()) :: integer()
  def get_stride(surface), do: NIF.image_surface_get_stride(surface)
end
