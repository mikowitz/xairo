defmodule Xairo.Native do
  use Rustler, otp_app: :xairo, crate: "xairo"

  def image_surface_create(_format, _width, _height), do: error()
  def image_surface_write_to_png(_surface, _filename), do: error()
  def image_surface_width(_surface), do: error()
  def image_surface_height(_surface), do: error()
  def image_surface_stride(_surface), do: error()
  def image_surface_format(_surface), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
