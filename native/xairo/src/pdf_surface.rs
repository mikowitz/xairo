use crate::enums::error::Error;
use rustler::ResourceArc;

pub struct PdfSurfaceRaw {
    pub surface: cairo::PdfSurface,
}

unsafe impl Send for PdfSurfaceRaw {}
unsafe impl Sync for PdfSurfaceRaw {}

pub type PdfSurface = ResourceArc<PdfSurfaceRaw>;

#[rustler::nif]
fn pdf_surface_new(width: f64, height: f64, path: String) -> Result<PdfSurface, Error> {
    match cairo::PdfSurface::new(width, height, path) {
        Ok(surface) => Ok(ResourceArc::new(PdfSurfaceRaw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn pdf_surface_finish(surface: PdfSurface) {
    surface.surface.finish();
}
