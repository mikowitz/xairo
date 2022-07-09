use crate::enums::Error;
use rustler::ResourceArc;

pub struct Raw {
    pub surface: cairo::PdfSurface,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type PdfSurface = ResourceArc<Raw>;

#[rustler::nif]
fn pdf_surface_new(width: f64, height: f64, path: String) -> Result<PdfSurface, Error> {
    match cairo::PdfSurface::new(width, height, path) {
        Ok(surface) => Ok(ResourceArc::new(Raw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn pdf_surface_finish(surface: PdfSurface) {
    surface.surface.finish();
}
