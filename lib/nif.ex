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
    resources: [:ContextResource, :SurfaceResource],
    nifs: [...]

  ~Z"""
  const c = @import("cairo");
  const surface = @import("zig/surface.zig");
  const context = @import("zig/context.zig");

  pub const ContextResource = context.ContextResource;

  pub const context_create = context.context_create;
  pub const context_set_source_rgb = context.set_source_rgb;
  pub const context_set_source_rgba = context.set_source_rgba;
  pub const context_set_line_width = context.set_line_width;
  pub const context_set_line_cap = context.set_line_cap;
  pub const context_set_dash = context.set_dash;

  pub const context_move_to = context.move_to;
  pub const context_rectangle = context.rectangle;
  pub const context_arc = context.arc;
  pub const context_curve_to = context.curve_to;
  pub const context_translate = context.translate;
  pub const context_rotate = context.rotate;

  pub const context_paint = context.paint;
  pub const context_fill = context.fill;
  pub const context_fill_preserve = context.fill_preserve;
  pub const context_stroke = context.stroke;

  pub const context_save = context.save;
  pub const context_restore = context.restore;

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
