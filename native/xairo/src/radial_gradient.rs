use crate::enums::error::Error;
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
fn radial_gradient_add_color_stop_rgb(
    gradient: RadialGradient,
    offset: f64,
    red: f64,
    green: f64,
    blue: f64,
) {
    gradient
        .gradient
        .add_color_stop_rgb(offset, red, green, blue);
}

#[rustler::nif]
fn radial_gradient_add_color_stop_rgba(
    gradient: RadialGradient,
    offset: f64,
    red: f64,
    green: f64,
    blue: f64,
    alpha: f64,
) {
    gradient
        .gradient
        .add_color_stop_rgba(offset, red, green, blue, alpha);
}

#[rustler::nif]
fn radial_gradient_color_stop_rgba(
    gradient: RadialGradient,
    index: isize,
) -> Result<(f64, f64, f64, f64, f64), Error> {
    match gradient.gradient.color_stop_rgba(index) {
        Ok(rgba) => Ok(rgba),
        Err(err) => Err(err.into()),
    }
}
