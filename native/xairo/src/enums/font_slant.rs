#[derive(rustler::NifUnitEnum)]
pub enum FontSlant {
    Normal,
    Italic,
    Oblique,
}

impl From<cairo::FontSlant> for FontSlant {
    fn from(slant: cairo::FontSlant) -> Self {
        match slant {
            cairo::FontSlant::Normal => Self::Normal,
            cairo::FontSlant::Italic => Self::Italic,
            cairo::FontSlant::Oblique => Self::Oblique,
            _ => {
                println!("{:?}", slant);
                Self::Normal
            }
        }
    }
}

impl From<FontSlant> for cairo::FontSlant {
    fn from(slant: FontSlant) -> Self {
        match slant {
            FontSlant::Normal => Self::Normal,
            FontSlant::Italic => Self::Italic,
            FontSlant::Oblique => Self::Oblique,
        }
    }
}
