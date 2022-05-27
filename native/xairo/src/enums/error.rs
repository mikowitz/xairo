#[derive(rustler::NifUnitEnum)]
pub enum Error {
    InvalidSize,
    WriteError,
    Error,
}

impl From<cairo::Error> for Error {
    fn from(error: cairo::Error) -> Self {
        match error {
            cairo::Error::InvalidSize => Error::InvalidSize,
            cairo::Error::WriteError => Error::WriteError,
            _ => {
                println!("Unmapped Error type: {:#?}", error);
                Error::Error
            }
        }
    }
}

impl From<Error> for cairo::Error {
    fn from(error: Error) -> Self {
        match error {
            Error::InvalidSize => cairo::Error::InvalidSize,
            Error::WriteError => cairo::Error::WriteError,
            Error::Error => cairo::Error::LastStatus,
        }
    }
}
