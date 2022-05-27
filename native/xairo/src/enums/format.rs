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
            cairo::Format::Invalid => Format::Invalid,
            cairo::Format::ARgb32 => Format::Argb32,
            cairo::Format::Rgb24 => Format::Rgb24,
            cairo::Format::A8 => Format::A8,
            cairo::Format::A1 => Format::A1,
            cairo::Format::Rgb16_565 => Format::Rgb16_565,
            cairo::Format::Rgb30 => Format::Rgb30,
            format => {
                println!("{:#?}", format);
                Format::Invalid
            }
        }
    }
}

impl From<Format> for cairo::Format {
    fn from(format: Format) -> Self {
        match format {
            Format::Invalid => cairo::Format::Invalid,
            Format::Argb32 => cairo::Format::ARgb32,
            Format::Rgb24 => cairo::Format::Rgb24,
            Format::A8 => cairo::Format::A8,
            Format::A1 => cairo::Format::A1,
            Format::Rgb16_565 => cairo::Format::Rgb16_565,
            Format::Rgb30 => cairo::Format::Rgb30,
        }
    }
}
