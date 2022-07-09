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
            cairo::SurfaceType::Image => Self::Image,
            cairo::SurfaceType::Pdf => Self::Pdf,
            cairo::SurfaceType::Ps => Self::Ps,
            cairo::SurfaceType::Svg => Self::Svg,
            _ => {
                println!("unknown surface type: {:?}", surface_type);
                Self::Image
            }
        }
    }
}
