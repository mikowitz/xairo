use crate::enums::{error::Error, svg_unit::SvgUnit};
use rustler::ResourceArc;

pub struct SvgSurfaceRaw {
    pub surface: cairo::SvgSurface,
}

unsafe impl Send for SvgSurfaceRaw {}
unsafe impl Sync for SvgSurfaceRaw {}

pub type SvgSurface = ResourceArc<SvgSurfaceRaw>;

#[rustler::nif]
fn svg_surface_new(width: f64, height: f64, path: String) -> Result<SvgSurface, Error> {
    match cairo::SvgSurface::new(width, height, Some(path)) {
        Ok(surface) => Ok(ResourceArc::new(SvgSurfaceRaw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn svg_surface_finish(surface: SvgSurface) {
    surface.surface.finish();
}

#[rustler::nif]
fn svg_surface_document_unit(surface: SvgSurface) -> SvgUnit {
    surface.surface.document_unit().into()
}

#[rustler::nif]
fn svg_surface_set_document_unit(surface: SvgSurface, unit: SvgUnit) {
    surface.surface.clone().set_document_unit(unit.into());
}
