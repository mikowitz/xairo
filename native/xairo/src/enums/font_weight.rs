#[derive(rustler::NifUnitEnum)]
pub enum FontWeight {
    Normal,
    Bold,
}

impl From<cairo::FontWeight> for FontWeight {
    fn from(weight: cairo::FontWeight) -> Self {
        match weight {
            cairo::FontWeight::Normal => Self::Normal,
            cairo::FontWeight::Bold => Self::Bold,
            _ => {
                println!("{:?}", weight);
                Self::Normal
            }
        }
    }
}

impl From<FontWeight> for cairo::FontWeight {
    fn from(weight: FontWeight) -> Self {
        match weight {
            FontWeight::Normal => Self::Normal,
            FontWeight::Bold => Self::Bold,
        }
    }
}
