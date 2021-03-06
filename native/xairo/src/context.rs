use crate::{
    enums::{Antialias, Error, FillRule, FontSlant, FontWeight, LineCap, LineJoin, Operator},
    font_face::{FontFace, Raw as FontFaceRaw},
    image_surface::ImageSurface,
    linear_gradient::LinearGradient,
    matrix::{Matrix, Raw as MatrixRaw},
    mesh::Mesh,
    path::{Path, Raw as PathRaw},
    pdf_surface::PdfSurface,
    point::Point,
    ps_surface::PsSurface,
    radial_gradient::RadialGradient,
    rgba::Rgba,
    solid_pattern::SolidPattern,
    surface_pattern::SurfacePattern,
    svg_surface::SvgSurface,
    vector::Vector,
};

use rustler::ResourceArc;

pub struct Raw {
    pub context: cairo::Context,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type Context = ResourceArc<Raw>;

#[rustler::nif]
fn context_new(surface: ImageSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(Raw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_pdf_surface(surface: PdfSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(Raw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_ps_surface(surface: PsSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(Raw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_svg_surface(surface: SvgSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(Raw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_rgba(context: Context, rgba: Rgba) {
    let (r, g, b, a) = rgba.to_tuple();
    context.context.set_source_rgba(r, g, b, a);
}

#[rustler::nif]
fn context_set_source_linear_gradient(
    context: Context,
    gradient: LinearGradient,
) -> Result<(), Error> {
    match context.context.set_source(&gradient.gradient) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_radial_gradient(
    context: Context,
    gradient: RadialGradient,
) -> Result<(), Error> {
    match context.context.set_source(&gradient.gradient) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_solid_pattern(context: Context, pattern: SolidPattern) -> Result<(), Error> {
    match context.context.set_source(&pattern.pattern) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_surface_pattern(
    context: Context,
    pattern: SurfacePattern,
) -> Result<(), Error> {
    match context.context.set_source(&pattern.pattern) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_mesh(context: Context, mesh: Mesh) -> Result<(), Error> {
    match context.context.set_source(&mesh.mesh) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_surface(
    context: Context,
    surface: ImageSurface,
    origin: Point,
) -> Result<(), Error> {
    let (x, y) = origin.to_tuple();
    match context.context.set_source_surface(&surface.surface, x, y) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_arc(ctx: Context, center: Point, r: f64, angle1: f64, angle2: f64) {
    let (x, y) = center.to_tuple();
    ctx.context.arc(x, y, r, angle1, angle2);
}

#[rustler::nif]
fn context_arc_negative(ctx: Context, center: Point, r: f64, angle1: f64, angle2: f64) {
    let (x, y) = center.to_tuple();
    ctx.context.arc_negative(x, y, r, angle1, angle2);
}

#[rustler::nif]
fn context_curve_to(ctx: Context, point1: Point, point2: Point, point3: Point) {
    let (x1, y1) = point1.to_tuple();
    let (x2, y2) = point2.to_tuple();
    let (x3, y3) = point3.to_tuple();
    ctx.context.curve_to(x1, y1, x2, y2, x3, y3);
}

#[rustler::nif]
fn context_rel_curve_to(ctx: Context, vec1: Vector, vec2: Vector, vec3: Vector) {
    let (x1, y1) = vec1.to_tuple();
    let (x2, y2) = vec2.to_tuple();
    let (x3, y3) = vec3.to_tuple();
    ctx.context.rel_curve_to(x1, y1, x2, y2, x3, y3);
}

#[rustler::nif]
fn context_line_to(ctx: Context, point: Point) {
    let (x, y) = point.to_tuple();
    ctx.context.line_to(x, y);
}

#[rustler::nif]
fn context_rel_line_to(ctx: Context, vec: Vector) {
    let (x, y) = vec.to_tuple();
    ctx.context.rel_line_to(x, y);
}

#[rustler::nif]
fn context_rectangle(ctx: Context, origin: Point, width: f64, height: f64) {
    let (x, y) = origin.to_tuple();
    ctx.context.rectangle(x, y, width, height);
}

#[rustler::nif]
fn context_move_to(ctx: Context, point: Point) {
    let (x, y) = point.to_tuple();
    ctx.context.move_to(x, y);
}

#[rustler::nif]
fn context_rel_move_to(ctx: Context, vec: Vector) {
    let (x, y) = vec.to_tuple();
    ctx.context.rel_move_to(x, y);
}

#[rustler::nif]
fn context_close_path(ctx: Context) {
    ctx.context.close_path();
}

#[rustler::nif]
fn context_stroke(context: Context) -> Result<(), Error> {
    match context.context.stroke() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_stroke_preserve(context: Context) -> Result<(), Error> {
    match context.context.stroke_preserve() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_fill(context: Context) -> Result<(), Error> {
    match context.context.fill() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_fill_preserve(context: Context) -> Result<(), Error> {
    match context.context.fill_preserve() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_paint(context: Context) -> Result<(), Error> {
    match context.context.paint() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_paint_with_alpha(context: Context, alpha: f64) -> Result<(), Error> {
    match context.context.paint_with_alpha(alpha) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_copy_path(context: Context) -> Result<Path, Error> {
    match context.context.copy_path() {
        Ok(path) => Ok(ResourceArc::new(PathRaw { path })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_copy_path_flat(context: Context) -> Result<Path, Error> {
    match context.context.copy_path_flat() {
        Ok(path) => Ok(ResourceArc::new(PathRaw { path })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_append_path(context: Context, path: Path) {
    context.context.append_path(&path.path);
}

#[rustler::nif]
fn context_tolerance(context: Context) -> f64 {
    context.context.tolerance()
}

#[rustler::nif]
fn context_set_tolerance(context: Context, tolerance: f64) {
    context.context.set_tolerance(tolerance);
}

#[rustler::nif]
fn context_has_current_point(context: Context) -> Result<bool, Error> {
    match context.context.has_current_point() {
        Ok(bool) => Ok(bool),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_current_point(context: Context) -> Result<Point, Error> {
    match context.context.current_point() {
        Ok((x, y)) => Ok(Point { x, y }),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_path(context: Context) {
    context.context.new_path();
}

#[rustler::nif]
fn context_new_sub_path(context: Context) {
    context.context.new_sub_path();
}

#[rustler::nif]
fn context_show_text(context: Context, text: String) -> Result<(), Error> {
    match context.context.show_text(&text) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_text_path(context: Context, text: String) {
    context.context.text_path(&text);
}

#[rustler::nif]
fn context_set_font_size(context: Context, font_size: f64) {
    context.context.set_font_size(font_size);
}

#[rustler::nif]
fn context_set_font_face(context: Context, font_face: FontFace) {
    context.context.set_font_face(&font_face.font_face);
}

#[rustler::nif]
fn context_select_font_face(
    context: Context,
    family: String,
    slant: FontSlant,
    weight: FontWeight,
) -> FontFace {
    context
        .context
        .select_font_face(&family, slant.into(), weight.into());
    ResourceArc::new(FontFaceRaw {
        font_face: context.context.font_face(),
    })
}

#[rustler::nif]
fn context_translate(context: Context, tx: f64, ty: f64) {
    context.context.translate(tx, ty);
}

#[rustler::nif]
fn context_scale(context: Context, sx: f64, sy: f64) {
    context.context.scale(sx, sy);
}

#[rustler::nif]
fn context_rotate(context: Context, radians: f64) {
    context.context.rotate(radians);
}

#[rustler::nif]
fn context_transform(context: Context, matrix: Matrix) {
    context.context.transform(matrix.matrix);
}

#[rustler::nif]
fn context_set_matrix(context: Context, matrix: Matrix) {
    context.context.set_matrix(matrix.matrix);
}

#[rustler::nif]
fn context_identity_matrix(context: Context) {
    context.context.identity_matrix();
}

#[rustler::nif]
fn context_matrix(context: Context) -> Matrix {
    ResourceArc::new(MatrixRaw {
        matrix: context.context.matrix(),
    })
}

#[rustler::nif]
fn context_set_font_matrix(context: Context, matrix: Matrix) {
    context.context.set_font_matrix(matrix.matrix);
}

#[rustler::nif]
fn context_font_matrix(context: Context) -> Matrix {
    ResourceArc::new(MatrixRaw {
        matrix: context.context.font_matrix(),
    })
}

#[rustler::nif]
fn context_mask_radial_gradient(context: Context, gradient: RadialGradient) -> Result<(), Error> {
    match context.context.mask(&gradient.gradient) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_mask_linear_gradient(context: Context, gradient: LinearGradient) -> Result<(), Error> {
    match context.context.mask(&gradient.gradient) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_mask_mesh(context: Context, mesh: Mesh) -> Result<(), Error> {
    match context.context.mask(&mesh.mesh) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_mask_solid_pattern(context: Context, pattern: SolidPattern) -> Result<(), Error> {
    match context.context.mask(&pattern.pattern) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_mask_surface_pattern(context: Context, pattern: SurfacePattern) -> Result<(), Error> {
    match context.context.mask(&pattern.pattern) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_mask_surface(
    context: Context,
    surface: ImageSurface,
    origin: Point,
) -> Result<(), Error> {
    let (x, y) = origin.to_tuple();
    match context.context.mask_surface(&surface.surface, x, y) {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_line_width(context: Context, line_width: f64) {
    context.context.set_line_width(line_width);
}

#[rustler::nif]
fn context_line_width(context: Context) -> f64 {
    context.context.line_width()
}

#[rustler::nif]
fn context_set_antialias(context: Context, antialias: Antialias) {
    context.context.set_antialias(antialias.into());
}

#[rustler::nif]
fn context_antialias(context: Context) -> Antialias {
    context.context.antialias().into()
}

#[rustler::nif]
fn context_set_fill_rule(context: Context, fill_rule: FillRule) {
    context.context.set_fill_rule(fill_rule.into());
}

#[rustler::nif]
fn context_fill_rule(context: Context) -> FillRule {
    context.context.fill_rule().into()
}

#[rustler::nif]
fn context_set_line_cap(context: Context, line_cap: LineCap) {
    context.context.set_line_cap(line_cap.into());
}

#[rustler::nif]
fn context_line_cap(context: Context) -> LineCap {
    context.context.line_cap().into()
}

#[rustler::nif]
fn context_set_line_join(context: Context, line_join: LineJoin) {
    context.context.set_line_join(line_join.into());
}

#[rustler::nif]
fn context_line_join(context: Context) -> LineJoin {
    context.context.line_join().into()
}

#[rustler::nif]
fn context_set_miter_limit(context: Context, miter_limit: f64) {
    context.context.set_miter_limit(miter_limit);
}

#[rustler::nif]
fn context_miter_limit(context: Context) -> f64 {
    context.context.miter_limit()
}

#[rustler::nif]
fn context_set_dash(context: Context, dashes: Vec<f64>, offset: f64) {
    context.context.set_dash(&dashes, offset);
}

#[rustler::nif]
fn context_dash_count(context: Context) -> i32 {
    context.context.dash_count()
}

#[rustler::nif]
fn context_dash(context: Context) -> (Vec<f64>, f64) {
    context.context.dash()
}

#[rustler::nif]
fn context_dash_dashes(context: Context) -> Vec<f64> {
    context.context.dash_dashes()
}

#[rustler::nif]
fn context_dash_offset(context: Context) -> f64 {
    context.context.dash_offset()
}

#[rustler::nif]
fn context_set_operator(context: Context, operator: Operator) {
    context.context.set_operator(operator.into());
}

#[rustler::nif]
fn context_operator(context: Context) -> Operator {
    context.context.operator().into()
}

#[rustler::nif]
fn context_in_stroke(context: Context, point: Point) -> Result<bool, Error> {
    let (x, y) = point.to_tuple();
    match context.context.in_stroke(x, y) {
        Ok(bool) => Ok(bool),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_in_fill(context: Context, point: Point) -> Result<bool, Error> {
    let (x, y) = point.to_tuple();
    match context.context.in_fill(x, y) {
        Ok(bool) => Ok(bool),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_user_to_device(context: Context, point: Point) -> Point {
    let (x, y) = point.to_tuple();
    let (x, y) = context.context.user_to_device(x, y);
    Point { x, y }
}

#[rustler::nif]
fn context_user_to_device_distance(context: Context, vector: Vector) -> Result<Vector, Error> {
    let (x, y) = vector.to_tuple();
    match context.context.user_to_device_distance(x, y) {
        Ok((x, y)) => Ok(Vector { x, y }),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_device_to_user(context: Context, point: Point) -> Result<Point, Error> {
    let (x, y) = point.to_tuple();
    match context.context.device_to_user(x, y) {
        Ok((x, y)) => Ok(Point { x, y }),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_device_to_user_distance(context: Context, vector: Vector) -> Result<Vector, Error> {
    let (x, y) = vector.to_tuple();
    match context.context.device_to_user_distance(x, y) {
        Ok((x, y)) => Ok(Vector { x, y }),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_clip(context: Context) {
    context.context.clip();
}

#[rustler::nif]
fn context_clip_preserve(context: Context) {
    context.context.clip_preserve();
}

#[rustler::nif]
fn context_reset_clip(context: Context) {
    context.context.reset_clip();
}

#[rustler::nif]
fn context_in_clip(context: Context, point: Point) -> Result<bool, Error> {
    let (x, y) = point.to_tuple();
    match context.context.in_clip(x, y) {
        Ok(bool) => Ok(bool),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_clip_extents(context: Context) -> Result<(Point, Point), Error> {
    match context.context.clip_extents() {
        Ok((x1, y1, x2, y2)) => Ok((Point { x: x1, y: y1 }, Point { x: x2, y: y2 })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_clip_rectangle_list(context: Context) -> Result<Vec<(Point, f64, f64)>, Error> {
    match context.context.copy_clip_rectangle_list() {
        Ok(rectangle_list) => {
            let rects = rectangle_list
                .iter()
                .map(|r| (Point { x: r.x, y: r.y }, r.width, r.height))
                .collect::<Vec<(Point, f64, f64)>>();

            Ok(rects)
        }
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_path_extents(context: Context) -> Result<(Point, Point), Error> {
    match context.context.path_extents() {
        Ok((x1, y1, x2, y2)) => Ok((Point { x: x1, y: y1 }, Point { x: x2, y: y2 })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_fill_extents(context: Context) -> Result<(Point, Point), Error> {
    match context.context.fill_extents() {
        Ok((x1, y1, x2, y2)) => Ok((Point { x: x1, y: y1 }, Point { x: x2, y: y2 })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_stroke_extents(context: Context) -> Result<(Point, Point), Error> {
    match context.context.stroke_extents() {
        Ok((x1, y1, x2, y2)) => Ok((Point { x: x1, y: y1 }, Point { x: x2, y: y2 })),
        Err(err) => Err(err.into()),
    }
}
