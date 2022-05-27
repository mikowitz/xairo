use crate::{enums::error::Error, image_surface::ImageSurface};

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
fn context_set_source_rgb(context: Context, red: f64, green: f64, blue: f64) {
    context.context.set_source_rgb(red, green, blue);
}

#[rustler::nif]
fn context_set_source_rgba(context: Context, red: f64, green: f64, blue: f64, alpha: f64) {
    context.context.set_source_rgba(red, green, blue, alpha);
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