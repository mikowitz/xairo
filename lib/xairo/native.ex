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

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
