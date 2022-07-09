use crate::{enums::Error, point::Point, rgba::Rgba};
use rustler::ResourceArc;

pub struct Raw {
    pub gradient: cairo::LinearGradient,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type LinearGradient = ResourceArc<Raw>;

#[rustler::nif]
fn linear_gradient_new(start: Point, stop: Point) -> LinearGradient {
    let (x1, y1) = start.to_tuple();
    let (x2, y2) = stop.to_tuple();
    ResourceArc::new(Raw {
        gradient: cairo::LinearGradient::new(x1, y1, x2, y2),
    })
}

#[rustler::nif]
fn linear_gradient_linear_points(gradient: LinearGradient) -> Result<(Point, Point), Error> {
    match gradient.gradient.linear_points() {
        Ok((x1, y1, x2, y2)) => Ok((Point { x: x1, y: y1 }, Point { x: x2, y: y2 })),
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
        Ok((offset, red, green, blue, alpha)) => Ok((offset, Rgba::new(red, green, blue, alpha))),
        Err(err) => Err(err.into()),
    }
}
