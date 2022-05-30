use crate::enums::error::Error;
use rustler::ResourceArc;

pub struct SolidPatternRaw {
    pub pattern: cairo::SolidPattern,
}

unsafe impl Send for SolidPatternRaw {}
unsafe impl Sync for SolidPatternRaw {}

pub type SolidPattern = ResourceArc<SolidPatternRaw>;

#[rustler::nif]
fn solid_pattern_from_rgb(red: f64, green: f64, blue: f64) -> SolidPattern {
    ResourceArc::new(SolidPatternRaw {
        pattern: cairo::SolidPattern::from_rgb(red, green, blue),
    })
}

#[rustler::nif]
fn solid_pattern_from_rgba(red: f64, green: f64, blue: f64, alpha: f64) -> SolidPattern {
    ResourceArc::new(SolidPatternRaw {
        pattern: cairo::SolidPattern::from_rgba(red, green, blue, alpha),
    })
}

#[rustler::nif]
fn solid_pattern_rgba(pattern: SolidPattern) -> Result<(f64, f64, f64, f64), Error> {
    match pattern.pattern.rgba() {
        Ok(rgba) => Ok(rgba),
        Err(err) => Err(err.into()),
    }
}
