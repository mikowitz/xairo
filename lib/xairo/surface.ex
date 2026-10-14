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

  @doc """
  Writes the contents of `surface` to a new file `filename` as a PNG image.
  """
  @spec write_to_png(t(), String.t()) :: :ok | {:error, atom()}
  def write_to_png(surface, filename), do: NIF.surface_write_to_png(surface, filename)

  @doc """
  Writes the contents of `surface` to a `t:binary/0` containing the PNG
  representation of the surface.
  """
  @spec to_png_stream(t()) :: {:ok, binary()} | {:error, atom()}
  def to_png_stream(surface), do: NIF.surface_write_to_png_stream(surface)

  @doc """
  Returns the type of the backend used to create `surface`. See
  `t:surface_type/0` for available types.
  """
  @spec get_type(t()) :: surface_type()
  def get_type(surface), do: NIF.surface_get_type(surface)

  @doc """
  Do any pending drawing for `surface` and also restore any temporary
  modifications Xairo has made to the surface's state.

  This function must be called before switching from drawing on the surface
  with Xairo to drawing on it directly with native APIs, or accessing its
  memory outside of Xairo. If the surface doesn't support direct access, then
  this function does nothing.
  """
  @spec flush(t()) :: t()
  def flush(surface), do: NIF.surface_flush(surface)

  @doc """
  This function finishes the surface and drops all references to external
  resources.

  For example, for the Xlib backend it means that cairo will no longer access
  the drawable, which can be freed. After calling `finish/1` the only valid
  operations on a surface are checking status, getting and setting user, and
  flushing and finishing it. Further drawing to the surface will not affect
  the surface but will instead trigger a `:surface_finished` error tuple.
  """
  @spec finish(t()) :: t()
  def finish(surface), do: NIF.surface_finish(surface)
end
