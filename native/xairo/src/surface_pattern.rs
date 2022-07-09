use crate::{
    image_surface::ImageSurface, pdf_surface::PdfSurface, ps_surface::PsSurface,
    svg_surface::SvgSurface,
};
use rustler::ResourceArc;

pub struct Raw {
    pub pattern: cairo::SurfacePattern,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type SurfacePattern = ResourceArc<Raw>;

#[rustler::nif]
fn surface_pattern_create_from_image_surface(surface: ImageSurface) -> SurfacePattern {
    ResourceArc::new(Raw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_pdf_surface(surface: PdfSurface) -> SurfacePattern {
    ResourceArc::new(Raw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_ps_surface(surface: PsSurface) -> SurfacePattern {
    ResourceArc::new(Raw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_svg_surface(surface: SvgSurface) -> SurfacePattern {
    ResourceArc::new(Raw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}
