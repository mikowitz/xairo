defmodule Xairo.Surface do
  @moduledoc """
  Module for functions that apply to all surface types.
  """

  alias Xairo.NIF

  require Xairo.Enums
  import Xairo.Enums, only: [enum_type: 1]

  @surface_types ~w(image pdf ps xlib xcb glitz quartz win32 beos directfb svg os2 win32_printing quartz_image script qt recording vg gl drm tee xml skia subsurface cogl)a

  @type surface_type :: unquote(enum_type(@surface_types))

  @type t :: reference()

  @spec write_to_png(t(), String.t()) :: :ok | {:error, atom()}
  def write_to_png(surface, filename), do: NIF.surface_write_to_png(surface, filename)

  @spec to_png_stream(t()) :: {:ok, binary()} | {:error, atom()}
  def to_png_stream(surface), do: NIF.surface_write_to_png_stream(surface)

  @spec get_type(t()) :: surface_type()
  def get_type(surface), do: NIF.surface_get_type(surface)

  @spec flush(t()) :: t()
  def flush(surface), do: NIF.surface_flush(surface)

  @spec finish(t()) :: t()
  def finish(surface), do: NIF.surface_finish(surface)
end
