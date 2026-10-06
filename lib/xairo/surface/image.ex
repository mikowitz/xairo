defmodule Xairo.Surface.Image do
  alias Xairo.NIF
  alias Xairo.Surface
  @type format :: :argb32 | :rgb24 | :a8 | :a1 | :rgb16_565 | :rgb96f | :rgba128f

  @formats ~w(argb32 rgb24 a8 a1 rgb16_565 rgb96f rgba128f)a

  @spec create(format(), non_neg_integer(), non_neg_integer()) ::
          {:ok, Surface.t()} | {:error, atom()}
  def create(format, width, height) when format in @formats and width >= 0 and height >= 0 do
    NIF.image_surface_create(format, width, height)
  end

  @spec get_width(Surface.t()) :: integer()
  def get_width(surface), do: NIF.image_surface_get_width(surface)

  @spec get_height(Surface.t()) :: integer()
  def get_height(surface), do: NIF.image_surface_get_height(surface)

  @spec get_format(Surface.t()) :: integer() | {:error, atom()}
  def get_format(surface), do: NIF.image_surface_get_format(surface)

  @spec get_stride(Surface.t()) :: integer()
  def get_stride(surface), do: NIF.image_surface_get_stride(surface)
end
