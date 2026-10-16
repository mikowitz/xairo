defmodule Xairo.NIF do
  @moduledoc false

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
  const path = @import("zig/path.zig");
  const drawing = @import("zig/drawing.zig");
  const matrix = @import("zig/matrix.zig");
  const transformation = @import("zig/transformation.zig");
  const text = @import("zig/text.zig");

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

  pub const context_select_font_face = text.select_font_face;
  pub const context_set_font_size = text.set_font_size;
  pub const context_show_text = text.show_text;
  pub const context_text_path = text.text_path;
  pub const context_text_extents = text.text_extents;
  pub const context_font_extents = text.font_extents;

  pub const context_new_path = path.new_path;
  pub const context_new_sub_path = path.new_sub_path;
  pub const close_path = path.close_path;
  pub const path_extents = path.path_extents;
  pub const has_current_point = path.has_current_point;
  pub const get_current_point = path.get_current_point;
  pub const context_move_to = path.move_to;
  pub const context_rel_move_to = path.rel_move_to;
  pub const context_line_to = path.line_to;
  pub const context_rel_line_to = path.rel_line_to;
  pub const context_rectangle = path.rectangle;
  pub const context_arc = path.arc;
  pub const context_arc_negative = path.arc_negative;
  pub const context_curve_to = path.curve_to;
  pub const context_rel_curve_to = path.rel_curve_to;


  pub const paint = drawing.paint;
  pub const paint_with_alpha = drawing.paint_with_alpha;
  pub const fill = drawing.fill;
  pub const fill_preserve = drawing.fill_preserve;
  pub const stroke = drawing.stroke;
  pub const stroke_preserve = drawing.stroke_preserve;
  pub const stroke_extents = drawing.stroke_extents;
  pub const fill_extents = drawing.fill_extents;
  pub const in_fill = drawing.in_fill;
  pub const in_stroke = drawing.in_stroke;
  pub const clip = drawing.clip;
  pub const clip_preserve = drawing.clip_preserve;
  pub const reset_clip = drawing.reset_clip;
  pub const clip_extents = drawing.clip_extents;

  pub const context_save = context.save;
  pub const context_restore = context.restore;

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

  pub const matrix_translate = matrix.translate;
  pub const matrix_scale = matrix.scale;
  pub const matrix_rotate = matrix.rotate;
  pub const matrix_invert = matrix.invert;
  pub const matrix_multiply = matrix.multiply;
  pub const matrix_transform_distance = matrix.transform_distance;
  pub const matrix_transform_point = matrix.transform_point;

  pub const context_translate = transformation.translate;
  pub const context_scale = transformation.scale;
  pub const context_rotate = transformation.rotate;
  pub const context_transform = transformation.transform;
  pub const context_set_matrix = transformation.set_matrix;
  pub const context_get_matrix = transformation.get_matrix;
  pub const context_identity_matrix = transformation.identity_matrix;
  pub const device_to_user = transformation.device_to_user;
  pub const device_to_user_distance = transformation.device_to_user_distance;
  pub const user_to_device = transformation.user_to_device;
  pub const user_to_device_distance = transformation.user_to_device_distance;
  """
end
