use crate::enums::Error;
use rustler::ResourceArc;

pub struct Raw {
    pub surface: cairo::PsSurface,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type PsSurface = ResourceArc<Raw>;

#[rustler::nif]
fn ps_surface_new(width: f64, height: f64, path: String) -> Result<PsSurface, Error> {
    match cairo::PsSurface::new(width, height, path) {
        Ok(surface) => Ok(ResourceArc::new(Raw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn ps_surface_finish(surface: PsSurface) {
    surface.surface.finish();
}
