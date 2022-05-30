use crate::{
    enums::error::Error, image_surface::ImageSurface, linear_gradient::LinearGradient, mesh::Mesh,
    path::Path, path::PathRaw, pdf_surface::PdfSurface, ps_surface::PsSurface,
    radial_gradient::RadialGradient, solid_pattern::SolidPattern, surface_pattern::SurfacePattern,
    svg_surface::SvgSurface,
};

use rustler::ResourceArc;

pub struct ContextRaw {
    pub context: cairo::Context,
}

unsafe impl Send for ContextRaw {}
unsafe impl Sync for ContextRaw {}

pub type Context = ResourceArc<ContextRaw>;

#[rustler::nif]
fn context_new(surface: ImageSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(ContextRaw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_pdf_surface(surface: PdfSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(ContextRaw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_ps_surface(surface: PsSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(ContextRaw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_new_from_svg_surface(surface: SvgSurface) -> Result<Context, Error> {
    match cairo::Context::new(&surface.surface) {
        Ok(context) => Ok(ResourceArc::new(ContextRaw { context })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn context_set_source_rgb(context: Context, red: f64, green: f64, blue: f64) {
    context.context.set_source_rgb(red, green, blue);
}

#[rustler::nif]
fn context_set_source_rgba(context: Context, red: f64, green: f64, blue: f64, alpha: f64) {
    context.context.set_source_rgba(red, green, blue, alpha);
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
fn context_arc(ctx: Context, cx: f64, cy: f64, r: f64, angle1: f64, angle2: f64) {
    ctx.context.arc(cx, cy, r, angle1, angle2);
}

#[rustler::nif]
fn context_arc_negative(ctx: Context, cx: f64, cy: f64, r: f64, angle1: f64, angle2: f64) {
    ctx.context.arc_negative(cx, cy, r, angle1, angle2);
}

#[rustler::nif]
fn context_curve_to(ctx: Context, x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) {
    ctx.context.curve_to(x1, y1, x2, y2, x3, y3);
}

#[rustler::nif]
fn context_rel_curve_to(ctx: Context, x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) {
    ctx.context.rel_curve_to(x1, y1, x2, y2, x3, y3);
}

#[rustler::nif]
fn context_line_to(ctx: Context, x: f64, y: f64) {
    ctx.context.line_to(x, y);
}

#[rustler::nif]
fn context_rel_line_to(ctx: Context, x: f64, y: f64) {
    ctx.context.rel_line_to(x, y);
}

#[rustler::nif]
fn context_rectangle(ctx: Context, x: f64, y: f64, width: f64, height: f64) {
    ctx.context.rectangle(x, y, width, height);
}

#[rustler::nif]
fn context_move_to(ctx: Context, x: f64, y: f64) {
    ctx.context.move_to(x, y);
}

#[rustler::nif]
fn context_rel_move_to(ctx: Context, x: f64, y: f64) {
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
fn context_current_point(context: Context) -> Result<(f64, f64), Error> {
    match context.context.current_point() {
        Ok(point) => Ok(point),
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
