use crate::{enums::error::Error, rgba::Rgba};
use rustler::ResourceArc;

pub struct SolidPatternRaw {
    pub pattern: cairo::SolidPattern,
}

unsafe impl Send for SolidPatternRaw {}
unsafe impl Sync for SolidPatternRaw {}

pub type SolidPattern = ResourceArc<SolidPatternRaw>;

#[rustler::nif]
fn solid_pattern_from_rgba(rgba: Rgba) -> SolidPattern {
    let (r, g, b, a) = rgba.to_tuple();
    ResourceArc::new(SolidPatternRaw {
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
