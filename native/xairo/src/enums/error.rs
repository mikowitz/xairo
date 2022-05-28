#[allow(clippy::enum_variant_names)]
#[derive(rustler::NifUnitEnum)]
pub enum Error {
    InvalidSize,
    SurfaceFinished,
    SurfaceTypeMismatch,
    WriteError,
    Error,
}

impl From<cairo::Error> for Error {
    fn from(error: cairo::Error) -> Self {
        match error {
            cairo::Error::InvalidSize => Error::InvalidSize,
            cairo::Error::SurfaceFinished => Error::SurfaceFinished,
            cairo::Error::SurfaceTypeMismatch => Error::SurfaceTypeMismatch,
            cairo::Error::WriteError => Error::WriteError,
            _ => {
                println!("Unmapped Error type: {:#?}", error);
                Error::Error
            }
        }
    }
}
