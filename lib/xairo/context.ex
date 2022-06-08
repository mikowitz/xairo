defmodule Xairo.Context do
  @moduledoc """
    Models a Cairo drawing context that can be instantiated from any
    supported surface type.
  """
  defstruct [:context, :surface, :source, :font_face]

  alias Xairo.{
    FontFace,
    ImageSurface,
    LinearGradient,
    Matrix,
    Mesh,
    Path,
    PdfSurface,
    PsSurface,
    RadialGradient,
    Rgba,
    SolidPattern,
    SurfacePattern,
    SvgSurface
  }

  alias Xairo.Native, as: N

  def new(%ImageSurface{} = surface) do
    with {:ok, context} <- N.context_new(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PdfSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_pdf_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%SvgSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_svg_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def new(%PsSurface{} = surface) do
    with {:ok, context} <- N.context_new_from_ps_surface(surface.surface),
         do: %__MODULE__{context: context, surface: surface}
  end

  def target(%__MODULE__{surface: surface}), do: surface

  def set_source(%__MODULE__{context: ctx} = this, %Rgba{} = rgba) do
    N.context_set_source_rgba(ctx, rgba)
    %{this | source: SolidPattern.from_rgba(rgba)}
  end

  def set_source(%__MODULE__{context: ctx} = this, %LinearGradient{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_linear_gradient(ctx, pattern) do
      %{this | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = this, %RadialGradient{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_radial_gradient(ctx, pattern) do
      %{this | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = this, %SolidPattern{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_solid_pattern(ctx, pattern) do
      %{this | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = this, %SurfacePattern{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_surface_pattern(ctx, pattern) do
      %{this | source: gradient}
    end
  end

  def set_source(%__MODULE__{context: ctx} = this, %Mesh{pattern: pattern} = gradient) do
    with {:ok, _} <- N.context_set_source_mesh(ctx, pattern) do
      %{this | source: gradient}
    end
  end

  def set_source_surface(
        %__MODULE__{context: ctx} = this,
        %ImageSurface{surface: surface} = sfc,
        x,
        y
      ) do
    with {:ok, _} <- N.context_set_source_surface(ctx, surface, x / 1, y / 1) do
      %{this | source: SurfacePattern.create(sfc)}
    end
  end

  def source(%__MODULE__{source: source}), do: source

  def arc(%__MODULE__{context: ctx} = this, cx, cy, r, angle1, angle2) do
    N.context_arc(ctx, cx / 1, cy / 1, r / 1, angle1 / 1, angle2 / 1)
    this
  end

  def arc_negative(%__MODULE__{context: ctx} = this, cx, cy, r, angle1, angle2) do
    N.context_arc_negative(ctx, cx / 1, cy / 1, r / 1, angle1 / 1, angle2 / 1)
    this
  end

  def curve_to(%__MODULE__{context: ctx} = this, x1, y1, x2, y2, x3, y3) do
    N.context_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
    this
  end

  def rel_curve_to(%__MODULE__{context: ctx} = this, x1, y1, x2, y2, x3, y3) do
    N.context_rel_curve_to(ctx, x1 / 1, y1 / 1, x2 / 1, y2 / 1, x3 / 1, y3 / 1)
    this
  end

  def line_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_line_to(ctx, x / 1, y / 1)
    this
  end

  def rel_line_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_rel_line_to(ctx, x / 1, y / 1)
    this
  end

  def rectangle(%__MODULE__{context: ctx} = this, x, y, width, height) do
    N.context_rectangle(ctx, x / 1, y / 1, width / 1, height / 1)
    this
  end

  def move_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_move_to(ctx, x / 1, y / 1)
    this
  end

  def rel_move_to(%__MODULE__{context: ctx} = this, x, y) do
    N.context_rel_move_to(ctx, x / 1, y / 1)
    this
  end

  def close_path(%__MODULE__{context: ctx} = this) do
    N.context_close_path(ctx)
    this
  end

  def stroke(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_stroke(ctx), do: this
  end

  def stroke_preserve(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_stroke_preserve(ctx), do: this
  end

  def fill(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_fill(ctx), do: this
  end

  def fill_preserve(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_fill_preserve(ctx), do: this
  end

  def paint(%__MODULE__{context: ctx} = this) do
    with {:ok, _} <- N.context_paint(ctx), do: this
  end

  def paint_with_alpha(%__MODULE__{context: ctx} = this, alpha) do
    with {:ok, _} <- N.context_paint_with_alpha(ctx, alpha / 1), do: this
  end

  def copy_path(%__MODULE__{context: ctx}) do
    with {:ok, path} <- N.context_copy_path(ctx), do: Path.from(path)
  end

  def copy_path_flat(%__MODULE__{context: ctx}) do
    with {:ok, path} <- N.context_copy_path_flat(ctx), do: Path.from(path)
  end

  def append_path(%__MODULE__{context: ctx} = this, %Path{path: path}) do
    N.context_append_path(ctx, path)
    this
  end

  def tolerance(%__MODULE__{context: ctx}), do: N.context_tolerance(ctx)

  def set_tolerance(%__MODULE__{context: ctx} = this, tolerance) do
    N.context_set_tolerance(ctx, tolerance / 1)
    this
  end

  def has_current_point(%__MODULE__{context: ctx}) do
    with {:ok, boolean} <- N.context_has_current_point(ctx), do: boolean
  end

  def current_point(%__MODULE__{context: ctx}) do
    with {:ok, point} <- N.context_current_point(ctx), do: point
  end

  def new_path(%__MODULE__{context: ctx} = this) do
    N.context_new_path(ctx)
    this
  end

  def new_sub_path(%__MODULE__{context: ctx} = this) do
    N.context_new_sub_path(ctx)
    this
  end

  def show_text(%__MODULE__{context: ctx} = this, text) do
    with {:ok, _} <- N.context_show_text(ctx, text), do: this
  end

  def text_path(%__MODULE__{context: ctx} = this, text) do
    N.context_text_path(ctx, text)
    this
  end

  def set_font_size(%__MODULE__{context: ctx} = this, font_size) do
    N.context_set_font_size(ctx, font_size / 1)
    this
  end

  def set_font_face(%__MODULE__{context: ctx} = this, %FontFace{font_face: font_face} = ff) do
    N.context_set_font_face(ctx, font_face)
    %{this | font_face: ff}
  end

  def font_face(%__MODULE__{font_face: font_face}) do
    font_face
  end

  def select_font_face(%__MODULE__{context: ctx} = this, family, slant, weight) do
    with font_face <- N.context_select_font_face(ctx, family, slant, weight),
         do: %{this | font_face: %FontFace{font_face: font_face}}
  end

  def translate(%__MODULE__{context: ctx} = this, tx, ty) do
    N.context_translate(ctx, tx / 1, ty / 1)
    this
  end

  def scale(%__MODULE__{context: ctx} = this, sx, sy) do
    N.context_scale(ctx, sx / 1, sy / 1)
    this
  end

  def rotate(%__MODULE__{context: ctx} = this, radians) do
    N.context_rotate(ctx, radians / 1)
    this
  end

  def transform(%__MODULE__{context: ctx} = this, %Matrix{matrix: matrix}) do
    N.context_transform(ctx, matrix)
    this
  end

  def set_matrix(%__MODULE__{context: ctx} = this, %Matrix{matrix: matrix}) do
    N.context_set_matrix(ctx, matrix)
    this
  end

  def matrix(%__MODULE__{context: ctx}) do
    %Matrix{matrix: N.context_matrix(ctx)}
  end

  def identity_matrix(%__MODULE__{context: ctx} = this) do
    N.context_identity_matrix(ctx)
    this
  end

  def set_font_matrix(%__MODULE__{context: ctx} = this, %Matrix{matrix: matrix}) do
    N.context_set_font_matrix(ctx, matrix)
    this
  end

  def font_matrix(%__MODULE__{context: ctx}) do
    %Matrix{matrix: N.context_font_matrix(ctx)}
  end

  def mask(%__MODULE__{context: ctx} = this, %RadialGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_radial_gradient(ctx, pattern), do: this
  end

  def mask(%__MODULE__{context: ctx} = this, %LinearGradient{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_linear_gradient(ctx, pattern), do: this
  end

  def mask(%__MODULE__{context: ctx} = this, %Mesh{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_mesh(ctx, pattern), do: this
  end

  def mask(%__MODULE__{context: ctx} = this, %SolidPattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_solid_pattern(ctx, pattern), do: this
  end

  def mask(%__MODULE__{context: ctx} = this, %SurfacePattern{pattern: pattern}) do
    with {:ok, _} <- N.context_mask_surface_pattern(ctx, pattern), do: this
  end

  def mask_surface(%__MODULE__{context: ctx} = this, %ImageSurface{surface: surface}, x, y) do
    with {:ok, _} <- N.context_mask_surface(ctx, surface, x / 1, y / 1), do: this
  end

  def set_line_width(%__MODULE__{context: ctx} = this, line_width) do
    N.context_set_line_width(ctx, line_width / 1)
    this
  end

  def line_width(%__MODULE__{context: ctx}) do
    N.context_line_width(ctx)
  end

  def set_antialias(%__MODULE__{context: ctx} = this, antialias) do
    N.context_set_antialias(ctx, antialias)
    this
  end

  def antialias(%__MODULE__{context: ctx}) do
    N.context_antialias(ctx)
  end

  def set_fill_rule(%__MODULE__{context: ctx} = this, fill_rule) do
    N.context_set_fill_rule(ctx, fill_rule)
    this
  end

  def fill_rule(%__MODULE__{context: ctx}) do
    N.context_fill_rule(ctx)
  end

  def set_line_cap(%__MODULE__{context: ctx} = this, line_cap) do
    N.context_set_line_cap(ctx, line_cap)
    this
  end

  def line_cap(%__MODULE__{context: ctx}) do
    N.context_line_cap(ctx)
  end

  def set_line_join(%__MODULE__{context: ctx} = this, line_join) do
    N.context_set_line_join(ctx, line_join)
    this
  end

  def line_join(%__MODULE__{context: ctx}) do
    N.context_line_join(ctx)
  end

  def set_miter_limit(%__MODULE__{context: ctx} = this, miter_limit) do
    N.context_set_miter_limit(ctx, miter_limit / 1)
    this
  end

  def miter_limit(%__MODULE__{context: ctx}) do
    N.context_miter_limit(ctx)
  end

  def set_dash(%__MODULE__{context: ctx} = this, dashes, offset) do
    N.context_set_dash(ctx, Enum.map(dashes, &(&1 / 1)), offset / 1)
    this
  end

  def dash_count(%__MODULE__{context: ctx}) do
    N.context_dash_count(ctx)
  end

  def dash(%__MODULE__{context: ctx}) do
    N.context_dash(ctx)
  end

  def dash_dashes(%__MODULE__{context: ctx}) do
    N.context_dash_dashes(ctx)
  end

  def dash_offset(%__MODULE__{context: ctx}) do
    N.context_dash_offset(ctx)
  end

  def set_operator(%__MODULE__{context: ctx} = this, operator) do
    N.context_set_operator(ctx, operator)
    this
  end

  def operator(%__MODULE__{context: ctx}) do
    N.context_operator(ctx)
  end

  def in_stroke(%__MODULE__{context: ctx}, x, y) do
    with {:ok, bool} <- N.context_in_stroke(ctx, x / 1, y / 1), do: bool
  end

  def in_fill(%__MODULE__{context: ctx}, x, y) do
    with {:ok, bool} <- N.context_in_fill(ctx, x / 1, y / 1), do: bool
  end

  def user_to_device(%__MODULE__{context: ctx}, x, y) do
    N.context_user_to_device(ctx, x / 1, y / 1)
  end

  def user_to_device_distance(%__MODULE__{context: ctx}, dx, dy) do
    with {:ok, distance} <- N.context_user_to_device_distance(ctx, dx / 1, dy / 1),
         do: distance
  end

  def device_to_user(%__MODULE__{context: ctx}, x, y) do
    with {:ok, distance} <- N.context_device_to_user(ctx, x / 1, y / 1),
         do: distance
  end

  def device_to_user_distance(%__MODULE__{context: ctx}, dx, dy) do
    with {:ok, distance} <- N.context_device_to_user_distance(ctx, dx / 1, dy / 1),
         do: distance
  end

  def clip(%__MODULE__{context: ctx} = this) do
    N.context_clip(ctx)
    this
  end

  def clip_preserve(%__MODULE__{context: ctx} = this) do
    N.context_clip_preserve(ctx)
    this
  end

  def reset_clip(%__MODULE__{context: ctx} = this) do
    N.context_reset_clip(ctx)
    this
  end

  def in_clip(%__MODULE__{context: ctx}, x, y) do
    with {:ok, bool} <- N.context_in_clip(ctx, x / 1, y / 1), do: bool
  end

  def clip_extents(%__MODULE__{context: ctx}) do
    with {:ok, extents} <- N.context_clip_extents(ctx), do: extents
  end

  def clip_rectangle_list(%__MODULE__{context: ctx}) do
    with {:ok, rectangle_list} <- N.context_clip_rectangle_list(ctx),
         do: rectangle_list
  end
end
