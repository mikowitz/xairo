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

  pub const context_get_antialias = context.get_antialias;
  pub const context_set_antialias = context.set_antialias;

  pub const context_get_fill_rule = context.get_fill_rule;
  pub const context_set_fill_rule = context.set_fill_rule;

  pub const context_get_line_width = context.get_line_width;
  pub const context_set_line_width = context.set_line_width;

  pub const context_get_line_join = context.get_line_join;
  pub const context_set_line_join = context.set_line_join;

  pub const context_get_operator = context.get_operator;
  pub const context_set_operator = context.set_operator;

  pub const context_get_miter_limit = context.get_miter_limit;
  pub const context_set_miter_limit = context.set_miter_limit;

  pub const context_get_tolerance = context.get_tolerance;
  pub const context_set_tolerance = context.set_tolerance;

  pub const context_get_line_cap = context.get_line_cap;
  pub const context_set_line_cap = context.set_line_cap;

  pub const context_get_dash = context.get_dash;
  pub const context_set_dash = context.set_dash;

  pub const context_select_font_face = context.select_font_face;
  pub const context_set_font_size = context.set_font_size;

  pub const context_move_to = context.move_to;
  pub const context_line_to = context.line_to;
  pub const context_rectangle = context.rectangle;
  pub const context_arc = context.arc;
  pub const context_curve_to = context.curve_to;
  pub const context_translate = context.translate;
  pub const context_rotate = context.rotate;

  pub const context_paint = context.paint;
  pub const context_fill = context.fill;
  pub const context_fill_preserve = context.fill_preserve;
  pub const context_stroke = context.stroke;
  pub const context_show_text = context.show_text;

  pub const context_save = context.save;
  pub const context_restore = context.restore;
  pub const context_clip = context.clip;
  pub const context_reset_clip = context.reset_clip;

  pub const context_get_target = context.get_target;

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
  pub const surface_get_type = surface.get_type;
  pub const surface_flush = surface.flush;
  pub const surface_finish = surface.finish;

  pub const svg_surface_create = surface.svg_surface_create;
  pub const svg_surface_create_for_stream = surface.svg_surface_create_for_stream;
  pub const svg_surface_to_binary = surface.svg_surface_to_binary;
  """
end
