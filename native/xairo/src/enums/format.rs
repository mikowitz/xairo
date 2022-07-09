#[derive(rustler::NifUnitEnum)]
pub enum Format {
    Invalid,
    Argb32,
    Rgb24,
    A8,
    A1,
    Rgb16_565,
    Rgb30,
}

impl From<cairo::Format> for Format {
    fn from(format: cairo::Format) -> Self {
        match format {
            cairo::Format::Invalid => Self::Invalid,
            cairo::Format::ARgb32 => Self::Argb32,
            cairo::Format::Rgb24 => Self::Rgb24,
            cairo::Format::A8 => Self::A8,
            cairo::Format::A1 => Self::A1,
            cairo::Format::Rgb16_565 => Self::Rgb16_565,
            cairo::Format::Rgb30 => Self::Rgb30,
            format => {
                println!("{:#?}", format);
                Self::Invalid
            }
        }
    }
}

impl From<Format> for cairo::Format {
    fn from(format: Format) -> Self {
        match format {
            Format::Invalid => Self::Invalid,
            Format::Argb32 => Self::ARgb32,
            Format::Rgb24 => Self::Rgb24,
            Format::A8 => Self::A8,
            Format::A1 => Self::A1,
            Format::Rgb16_565 => Self::Rgb16_565,
            Format::Rgb30 => Self::Rgb30,
        }
    }
}
