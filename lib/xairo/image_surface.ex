defmodule Xairo.ImageSurface do
  @moduledoc """
    Models a drawing surface that renders its contents to disk in PNG format.
  """

  defstruct [:surface]

  alias Xairo.Native, as: N

  def create(format, width, height) do
    with {:ok, surface} <- N.image_surface_create(format, width, height),
         do: %__MODULE__{surface: surface}
  end

  def write_to_png(%__MODULE__{surface: surface}, filename) do
    with {:ok, _} <- N.image_surface_write_to_png(surface, filename), do: :ok
  end

  def width(%__MODULE__{surface: surface}) do
    N.image_surface_width(surface)
  end

  def height(%__MODULE__{surface: surface}) do
    N.image_surface_height(surface)
  end

  def stride(%__MODULE__{surface: surface}) do
    N.image_surface_stride(surface)
  end

  def format(%__MODULE__{surface: surface}) do
    N.image_surface_format(surface)
  end
end
