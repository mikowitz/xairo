defmodule Xairo.Native do
  @moduledoc false

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

  def context_set_source_rgba(_context, _rgba), do: error()
  def context_set_source_linear_gradient(_context, _pattern), do: error()
  def context_set_source_radial_gradient(_context, _pattern), do: error()
  def context_set_source_solid_pattern(_context, _pattern), do: error()
  def context_set_source_surface_pattern(_context, _pattern), do: error()
  def context_set_source_mesh(_context, _pattern), do: error()
  def context_set_source_surface(_context, _surface, _origin), do: error()

  def context_arc(_context, _center, _r, _angle1, _angle2), do: error()
  def context_arc_negative(_context, _center, _r, _angle1, _angle2), do: error()
  def context_curve_to(_context, _point1, _point2, _point3), do: error()
  def context_rel_curve_to(_context, _vector1, _vector2, _vector3), do: error()
  def context_rectangle(_context, _origin, _width, _height), do: error()
  def context_line_to(_context, _point), do: error()
  def context_rel_line_to(_context, _vector), do: error()
  def context_rel_move_to(_context, _vector), do: error()

  def context_move_to(_context, _point), do: error()

  def context_close_path(_context), do: error()

  def context_stroke(_context), do: error()
  def context_stroke_preserve(_context), do: error()
  def context_fill(_context), do: error()
  def context_fill_preserve(_context), do: error()
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

  def context_show_text(_context, _text), do: error()
  def context_text_path(_context, _text), do: error()
  def context_set_font_size(_context, _font_size), do: error()
  def context_set_font_face(_context, _font_face), do: error()
  def context_select_font_face(_context, _family, _slant, _weight), do: error()

  def context_translate(_context, _tx, _ty), do: error()
  def context_scale(_context, _sx, _sy), do: error()
  def context_rotate(_context, _radians), do: error()
  def context_transform(_context, _matrix), do: error()
  def context_set_matrix(_context, _matrix), do: error()
  def context_identity_matrix(_context), do: error()
  def context_matrix(_context), do: error()
  def context_set_font_matrix(_context, _matrix), do: error()
  def context_font_matrix(_context), do: error()

  def context_mask_radial_gradient(_context, _pattern), do: error()
  def context_mask_linear_gradient(_context, _pattern), do: error()
  def context_mask_mesh(_context, _pattern), do: error()
  def context_mask_solid_pattern(_context, _pattern), do: error()
  def context_mask_surface_pattern(_context, _pattern), do: error()
  def context_mask_surface(_context, _surface, _origin), do: error()

  def context_set_line_width(_context, _line_width), do: error()
  def context_line_width(_context), do: error()
  def context_set_antialias(_context, _antialias), do: error()
  def context_antialias(_context), do: error()
  def context_set_fill_rule(_context, _fill_rule), do: error()
  def context_fill_rule(_context), do: error()
  def context_set_line_cap(_context, _line_cap), do: error()
  def context_line_cap(_context), do: error()
  def context_set_line_join(_context, _line_join), do: error()
  def context_line_join(_context), do: error()
  def context_set_miter_limit(_context, _miter_limit), do: error()
  def context_miter_limit(_context), do: error()

  def context_set_dash(_context, _dashes, _offset), do: error()
  def context_dash_count(_context), do: error()
  def context_dash(_context), do: error()
  def context_dash_dashes(_context), do: error()
  def context_dash_offset(_context), do: error()

  def context_set_operator(_context, _operator), do: error()
  def context_operator(_context), do: error()

  def context_in_stroke(_context, _point), do: error()
  def context_in_fill(_context, _point), do: error()

  def context_user_to_device(_context, _point), do: error()
  def context_user_to_device_distance(_context, _vector), do: error()
  def context_device_to_user(_context, _point), do: error()
  def context_device_to_user_distance(_context, _vector), do: error()

  def context_clip(_context), do: error()
  def context_clip_preserve(_context), do: error()
  def context_reset_clip(_context), do: error()
  def context_in_clip(_context, _point), do: error()
  def context_clip_extents(_context), do: error()
  def context_clip_rectangle_list(_context), do: error()

  def context_path_extents(_context), do: error()
  def context_fill_extents(_context), do: error()
  def context_stroke_extents(_context), do: error()

  ## CONTEXT END

  def path_iter(_path), do: error()

  def linear_gradient_new(_start, _stop), do: error()
  def linear_gradient_linear_points(_gradient), do: error()
  def linear_gradient_color_stop_count(_gradient), do: error()
  def linear_gradient_add_color_stop(_gradient, _offset, _rgba), do: error()
  def linear_gradient_color_stop_rgba(_gradient, _index), do: error()

  def radial_gradient_new(_start, _r1, _stop, _r2), do: error()
  def radial_gradient_radial_circles(_gradient), do: error()
  def radial_gradient_color_stop_count(_gradient), do: error()
  def radial_gradient_add_color_stop(_gradient, _offset, _rgba), do: error()

  def radial_gradient_color_stop_rgba(_gradient, _index), do: error()

  def solid_pattern_from_rgba(_rgba), do: error()
  def solid_pattern_rgba(_pattern), do: error()

  def surface_pattern_create_from_image_surface(_surface), do: error()
  def surface_pattern_create_from_pdf_surface(_surface), do: error()
  def surface_pattern_create_from_ps_surface(_surface), do: error()
  def surface_pattern_create_from_svg_surface(_surface), do: error()

  def mesh_new, do: error()
  def mesh_patch_count(_mesh), do: error()
  def mesh_begin_patch(_mesh), do: error()
  def mesh_end_patch(_mesh), do: error()
  def mesh_move_to(_mesh, _point), do: error()
  def mesh_line_to(_mesh, _point), do: error()
  def mesh_curve_to(_mesh, _point1, _point2, _point3), do: error()
  def mesh_set_control_point(_mesh, _corner, _point), do: error()
  def mesh_control_point(_mesh, _patch, _corner), do: error()
  def mesh_set_corner_color(_mesh, _corner, _rgba), do: error()
  def mesh_corner_color_rgba(_mesh, _patch, _corner), do: error()
  def mesh_path(_mesh, _patch), do: error()

  def font_face_toy_create(_family, _slant, _weight), do: error()
  def font_face_toy_get_family(_font), do: error()
  def font_face_toy_get_slant(_font), do: error()
  def font_face_toy_get_weight(_font), do: error()

  def matrix_new(_xx, _yx, _xy_, _yy, _tx, _ty), do: error()
  def matrix_identity, do: error()
  def matrix_to_tuple(_matrix), do: error()
  def matrix_transform_distance(_matrix, _vector), do: error()
  def matrix_transform_point(_matrix, _point), do: error()
  def matrix_translate(_matrix, _dx, _dy), do: error()
  def matrix_scale(_matrix, _dx, _dy), do: error()
  def matrix_rotate(_matrix, _radians), do: error()
  def matrix_invert(_matrix), do: error()
  def matrix_multiply(_matrix1, _matrix2), do: error()

  def font_extents_font_extents(_context), do: error()

  def text_extents_text_extents(_text, _context), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
