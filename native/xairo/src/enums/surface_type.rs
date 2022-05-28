#[derive(rustler::NifUnitEnum)]
pub enum SurfaceType {
    Image,
    Pdf,
    Ps,
    Svg,
}

impl From<cairo::SurfaceType> for SurfaceType {
    fn from(surface_type: cairo::SurfaceType) -> Self {
        match surface_type {
            cairo::SurfaceType::Image => SurfaceType::Image,
            cairo::SurfaceType::Pdf => SurfaceType::Pdf,
            cairo::SurfaceType::Ps => SurfaceType::Ps,
            cairo::SurfaceType::Svg => SurfaceType::Svg,
            _ => SurfaceType::Image,
        }
    }
}
