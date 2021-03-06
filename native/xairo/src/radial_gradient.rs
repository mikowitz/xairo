use crate::{enums::Error, point::Point, rgba::Rgba};
use rustler::ResourceArc;

pub struct Raw {
    pub gradient: cairo::RadialGradient,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type RadialGradient = ResourceArc<Raw>;
pub type Radius = f64;
pub type Circle = (Point, Radius);

#[rustler::nif]
fn radial_gradient_new(start: Point, r1: f64, stop: Point, r2: f64) -> RadialGradient {
    let (x1, y1) = start.to_tuple();
    let (x2, y2) = stop.to_tuple();
    ResourceArc::new(Raw {
        gradient: cairo::RadialGradient::new(x1, y1, r1, x2, y2, r2),
    })
}

#[rustler::nif]
fn radial_gradient_radial_circles(gradient: RadialGradient) -> Result<(Circle, Circle), Error> {
    match gradient.gradient.radial_circles() {
        Ok((x1, y1, r1, x2, y2, r2)) => {
            Ok(((Point { x: x1, y: y1 }, r1), (Point { x: x2, y: y2 }, r2)))
        }
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
        Ok((offset, red, green, blue, alpha)) => Ok((offset, Rgba::new(red, green, blue, alpha))),
        Err(err) => Err(err.into()),
    }
}
