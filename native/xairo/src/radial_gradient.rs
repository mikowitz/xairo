use crate::{enums::error::Error, rgba::Rgba};
use rustler::ResourceArc;

pub struct RadialGradientRaw {
    pub gradient: cairo::RadialGradient,
}

unsafe impl Send for RadialGradientRaw {}
unsafe impl Sync for RadialGradientRaw {}

pub type RadialGradient = ResourceArc<RadialGradientRaw>;

#[rustler::nif]
fn radial_gradient_new(x1: f64, y1: f64, r1: f64, x2: f64, y2: f64, r2: f64) -> RadialGradient {
    ResourceArc::new(RadialGradientRaw {
        gradient: cairo::RadialGradient::new(x1, y1, r1, x2, y2, r2),
    })
}

#[rustler::nif]
fn radial_gradient_radial_circles(
    gradient: RadialGradient,
) -> Result<(f64, f64, f64, f64, f64, f64), Error> {
    match gradient.gradient.radial_circles() {
        Ok(circles) => Ok(circles),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn radial_gradient_color_stop_count(gradient: RadialGradient) -> Result<isize, Error> {
    match gradient.gradient.color_stop_count() {
        Ok(count) => Ok(count),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn radial_gradient_add_color_stop(gradient: RadialGradient, offset: f64, rgba: Rgba) {
    let (r, g, b, a) = rgba.to_tuple();
    gradient.gradient.add_color_stop_rgba(offset, r, g, b, a);
}

#[rustler::nif]
fn radial_gradient_color_stop_rgba(
    gradient: RadialGradient,
    index: isize,
) -> Result<(f64, Rgba), Error> {
    match gradient.gradient.color_stop_rgba(index) {
        Ok((o, r, g, b, a)) => Ok((o, Rgba::new(r, g, b, a))),
        Err(err) => Err(err.into()),
    }
}
