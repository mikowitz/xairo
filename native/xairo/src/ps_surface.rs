use crate::enums::error::Error;
use rustler::ResourceArc;

pub struct PsSurfaceRaw {
    pub surface: cairo::PsSurface,
}

unsafe impl Send for PsSurfaceRaw {}
unsafe impl Sync for PsSurfaceRaw {}

pub type PsSurface = ResourceArc<PsSurfaceRaw>;

#[rustler::nif]
fn ps_surface_new(width: f64, height: f64, path: String) -> Result<PsSurface, Error> {
    match cairo::PsSurface::new(width, height, path) {
        Ok(surface) => Ok(ResourceArc::new(PsSurfaceRaw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn ps_surface_finish(surface: PsSurface) {
    surface.surface.finish();
}
