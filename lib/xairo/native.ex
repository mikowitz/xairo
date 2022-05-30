defmodule Xairo.Native do
  use Rustler, otp_app: :xairo, crate: "xairo"

  def image_surface_create(_format, _width, _height), do: error()
  def image_surface_write_to_png(_surface, _filename), do: error()
  def image_surface_width(_surface), do: error()
  def image_surface_height(_surface), do: error()
  def image_surface_stride(_surface), do: error()
  def image_surface_format(_surface), do: error()

  def pdf_surface_new(_width, _height, _path), do: error()
  def pdf_surface_finish(_surface), do: error()

  def ps_surface_new(_width, _height, _path), do: error()
  def ps_surface_finish(_surface), do: error()

  def svg_surface_new(_width, _height, _path), do: error()
  def svg_surface_finish(_surface), do: error()
  def svg_surface_document_unit(_surface), do: error()
  def svg_surface_set_document_unit(_surface, _unit), do: error()

  def context_new(_surface), do: error()
  def context_new_from_pdf_surface(_surface), do: error()
  def context_new_from_ps_surface(_surface), do: error()
  def context_new_from_svg_surface(_surface), do: error()

  def context_set_source_rgb(_context, _red, _green, _blue), do: error()
  def context_set_source_rgba(_context, _red, _green, _blue, _alpha), do: error()
  def context_set_source_linear_gradient(_context, _pattern), do: error()
  def context_set_source_radial_gradient(_context, _pattern), do: error()
  def context_set_source_solid_pattern(_context, _pattern), do: error()
  def context_set_source_surface_pattern(_context, _pattern), do: error()
  def context_set_source_mesh(_context, _pattern), do: error()

  def context_arc(_context, _cx, _cy, _r, _angle1, _angle2), do: error()
  def context_arc_negative(_context, _cx, _cy, _r, _angle1, _angle2), do: error()
  def context_curve_to(_context, _x1, _y1, _x2, _y2, _x3, _y3), do: error()
  def context_rel_curve_to(_context, _x1, _y1, _x2, _y2, _x3, _y3), do: error()
  def context_rectangle(_context, _x, _y, _width, _height), do: error()
  def context_line_to(_context, _x, _y), do: error()
  def context_rel_line_to(_context, _x, _y), do: error()
  def context_rel_move_to(_context, _x, _y), do: error()
  def context_move_to(_context, _x, _y), do: error()
  def context_close_path(_context), do: error()

  def context_stroke(_context), do: error()
  def context_stroke_preserve(_context), do: error()
  def context_fill(_context), do: error()
  def context_paint(_context), do: error()
  def context_paint_with_alpha(_context, _alpha), do: error()

  def context_copy_path(_context), do: error()
  def context_copy_path_flat(_context), do: error()
  def context_append_path(_context, _path), do: error()
  def context_tolerance(_context), do: error()
  def context_set_tolerance(_context, _tolerance), do: error()
  def context_has_current_point(_context), do: error()
  def context_current_point(_context), do: error()

  def context_new_path(_context), do: error()
  def context_new_sub_path(_context), do: error()

  def path_iter(_path), do: error()

  def linear_gradient_new(_x1, _y1, _x2, _y2), do: error()
  def linear_gradient_linear_points(_gradient), do: error()
  def linear_gradient_color_stop_count(_gradient), do: error()
  def linear_gradient_add_color_stop_rgb(_gradient, _offset, _red, _green, _blue), do: error()

  def linear_gradient_add_color_stop_rgba(_gradient, _offset, _red, _green, _blue, _alpha),
    do: error()

  def linear_gradient_color_stop_rgba(_gradient, _index), do: error()

  def radial_gradient_new(_x1, _y1, _r1, _x2, _y2, _r2), do: error()
  def radial_gradient_radial_circles(_gradient), do: error()
  def radial_gradient_color_stop_count(_gradient), do: error()
  def radial_gradient_add_color_stop_rgb(_gradient, _offset, _red, _green, _blue), do: error()

  def radial_gradient_add_color_stop_rgba(_gradient, _offset, _red, _green, _blue, _alpha),
    do: error()

  def radial_gradient_color_stop_rgba(_gradient, _index), do: error()

  def solid_pattern_from_rgb(_red, _green, _blue), do: error()
  def solid_pattern_from_rgba(_red, _green, _blue, _alpha), do: error()
  def solid_pattern_rgba(_pattern), do: error()

  def surface_pattern_create_from_image_surface(_surface), do: error()
  def surface_pattern_create_from_pdf_surface(_surface), do: error()
  def surface_pattern_create_from_ps_surface(_surface), do: error()
  def surface_pattern_create_from_svg_surface(_surface), do: error()

  def mesh_new, do: error()
  def mesh_patch_count(_mesh), do: error()
  def mesh_begin_patch(_mesh), do: error()
  def mesh_end_patch(_mesh), do: error()
  def mesh_move_to(_mesh, _x, _y), do: error()
  def mesh_line_to(_mesh, _x, _y), do: error()
  def mesh_curve_to(_mesh, _x1, _y1, _x2, _y2, _x3, _y3), do: error()
  def mesh_set_control_point(_mesh, _corner, _x, _y), do: error()
  def mesh_control_point(_mesh, _patch, _corner), do: error()
  def mesh_set_corner_color_rgb(_mesh, _corner, _red, _green, _blue), do: error()
  def mesh_set_corner_color_rgba(_mesh, _corner, _red, _green, _blue, _alpha), do: error()
  def mesh_corner_color_rgba(_mesh, _patch, _corner), do: error()
  def mesh_path(_mesh, _patch), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
