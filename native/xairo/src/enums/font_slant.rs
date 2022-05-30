#[derive(rustler::NifUnitEnum)]
pub enum FontSlant {
    Normal,
    Italic,
    Oblique,
}

impl From<FontSlant> for cairo::FontSlant {
    fn from(slant: FontSlant) -> Self {
        match slant {
            FontSlant::Normal => cairo::FontSlant::Normal,
            FontSlant::Italic => cairo::FontSlant::Italic,
            FontSlant::Oblique => cairo::FontSlant::Oblique,
        }
    }
}

impl From<cairo::FontSlant> for FontSlant {
    fn from(slant: cairo::FontSlant) -> Self {
        match slant {
            cairo::FontSlant::Normal => FontSlant::Normal,
            cairo::FontSlant::Italic => FontSlant::Italic,
            cairo::FontSlant::Oblique => FontSlant::Oblique,
            _ => {
                println!("{:?}", slant);
                FontSlant::Normal
            }
        }
    }
}
