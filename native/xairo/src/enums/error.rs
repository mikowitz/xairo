#[allow(clippy::enum_variant_names)]
#[derive(rustler::NifUnitEnum)]
pub enum Error {
    ClipNotRepresentable,
    InvalidIndex,
    InvalidMatrix,
    InvalidMeshConstruction,
    InvalidSize,
    SurfaceFinished,
    SurfaceTypeMismatch,
    WriteError,
    Error,
}

impl From<cairo::Error> for Error {
    fn from(error: cairo::Error) -> Self {
        match error {
            cairo::Error::ClipNotRepresentable => Self::ClipNotRepresentable,
            cairo::Error::InvalidIndex => Self::InvalidIndex,
            cairo::Error::InvalidMatrix => Self::InvalidMatrix,
            cairo::Error::InvalidMeshConstruction => Self::InvalidMeshConstruction,
            cairo::Error::InvalidSize => Self::InvalidSize,
            cairo::Error::SurfaceFinished => Self::SurfaceFinished,
            cairo::Error::SurfaceTypeMismatch => Self::SurfaceTypeMismatch,
            cairo::Error::WriteError => Self::WriteError,
            _ => {
                println!("Unmapped Error type: {:#?}", error);
                Self::Error
            }
        }
    }
}
