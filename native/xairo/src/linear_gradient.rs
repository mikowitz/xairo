use crate::{enums::error::Error, rgba::Rgba};
use rustler::ResourceArc;

pub struct LinearGradientRaw {
    pub gradient: cairo::LinearGradient,
}

unsafe impl Send for LinearGradientRaw {}
unsafe impl Sync for LinearGradientRaw {}

pub type LinearGradient = ResourceArc<LinearGradientRaw>;

#[rustler::nif]
fn linear_gradient_new(x1: f64, y1: f64, x2: f64, y2: f64) -> LinearGradient {
    ResourceArc::new(LinearGradientRaw {
        gradient: cairo::LinearGradient::new(x1, y1, x2, y2),
    })
}

#[rustler::nif]
fn linear_gradient_linear_points(gradient: LinearGradient) -> Result<(f64, f64, f64, f64), Error> {
    match gradient.gradient.linear_points() {
        Ok(points) => Ok(points),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn linear_gradient_color_stop_count(gradient: LinearGradient) -> Result<isize, Error> {
    match gradient.gradient.color_stop_count() {
        Ok(count) => Ok(count),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn linear_gradient_add_color_stop(gradient: LinearGradient, offset: f64, rgba: Rgba) {
    let (r, g, b, a) = rgba.to_tuple();
    gradient.gradient.add_color_stop_rgba(offset, r, g, b, a);
}

#[rustler::nif]
fn linear_gradient_color_stop_rgba(
    gradient: LinearGradient,
    index: isize,
) -> Result<(f64, Rgba), Error> {
    match gradient.gradient.color_stop_rgba(index) {
        Ok((o, r, g, b, a)) => Ok((o, Rgba::new(r, g, b, a))),
        Err(err) => Err(err.into()),
    }
}
