defmodule Xairo.NIF do
  case System.cmd("pkg-config", ["--variable=includedir", "cairo"]) do
    {dir, 0} ->
      @cairo_include_dir Path.join(String.trim(dir), "cairo")

    {msg, _} ->
      raise CompileError, "xairo requires system cairo to be available via pkg-config: #{msg}."
  end

  use Zig,
    otp_app: :xairo,
    leak_check: true,
    c: [
      include_dirs: @cairo_include_dir,
      link_lib: {:system, "cairo"},
      headers: [cairo: "zig/xairo.h"]
    ],
    resources: [:SurfaceResource],
    nifs: [...]

  ~Z"""
  const c = @import("cairo");
  const surface = @import("zig/surface.zig");

  pub const SurfaceResource = surface.SurfaceResource;

  pub const cairo_version = c.cairo_version_string;

  pub const image_surface_create = surface.image_surface_create;
  pub const image_surface_create_from_png = surface.image_surface_create_from_png;
  pub const image_surface_get_width = surface.image_surface_get_width;
  pub const image_surface_get_height = surface.image_surface_get_height;
  pub const image_surface_get_format = surface.image_surface_get_format;
  pub const image_surface_get_stride = surface.image_surface_get_stride;
  pub const surface_write_to_png = surface.surface_write_to_png;
  pub const surface_write_to_png_stream = surface.surface_write_to_png_stream;
  """
end
