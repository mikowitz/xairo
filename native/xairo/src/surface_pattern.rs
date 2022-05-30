use crate::{
    image_surface::ImageSurface, pdf_surface::PdfSurface, ps_surface::PsSurface,
    svg_surface::SvgSurface,
};
use rustler::ResourceArc;

pub struct SurfacePatternRaw {
    pub pattern: cairo::SurfacePattern,
}

unsafe impl Send for SurfacePatternRaw {}
unsafe impl Sync for SurfacePatternRaw {}

pub type SurfacePattern = ResourceArc<SurfacePatternRaw>;

#[rustler::nif]
fn surface_pattern_create_from_image_surface(surface: ImageSurface) -> SurfacePattern {
    ResourceArc::new(SurfacePatternRaw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_pdf_surface(surface: PdfSurface) -> SurfacePattern {
    ResourceArc::new(SurfacePatternRaw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_ps_surface(surface: PsSurface) -> SurfacePattern {
    ResourceArc::new(SurfacePatternRaw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}

#[rustler::nif]
fn surface_pattern_create_from_svg_surface(surface: SvgSurface) -> SurfacePattern {
    ResourceArc::new(SurfacePatternRaw {
        pattern: cairo::SurfacePattern::create(&surface.surface),
    })
}
