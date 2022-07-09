use crate::{enums::Error, rgba::Rgba};
use rustler::ResourceArc;

pub struct Raw {
    pub pattern: cairo::SolidPattern,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type SolidPattern = ResourceArc<Raw>;

#[rustler::nif]
fn solid_pattern_from_rgba(rgba: Rgba) -> SolidPattern {
    let (r, g, b, a) = rgba.to_tuple();
    ResourceArc::new(Raw {
        pattern: cairo::SolidPattern::from_rgba(r, g, b, a),
    })
}

#[rustler::nif]
fn solid_pattern_rgba(pattern: SolidPattern) -> Result<Rgba, Error> {
    match pattern.pattern.rgba() {
        Ok((r, g, b, a)) => Ok(Rgba::new(r, g, b, a)),
        Err(err) => Err(err.into()),
    }
}
