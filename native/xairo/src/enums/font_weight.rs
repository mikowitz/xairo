#[derive(rustler::NifUnitEnum)]
pub enum FontWeight {
    Normal,
    Bold,
}

impl From<FontWeight> for cairo::FontWeight {
    fn from(weight: FontWeight) -> Self {
        match weight {
            FontWeight::Normal => cairo::FontWeight::Normal,
            FontWeight::Bold => cairo::FontWeight::Bold,
        }
    }
}

impl From<cairo::FontWeight> for FontWeight {
    fn from(weight: cairo::FontWeight) -> Self {
        match weight {
            cairo::FontWeight::Normal => FontWeight::Normal,
            cairo::FontWeight::Bold => FontWeight::Bold,
            _ => {
                println!("{:?}", weight);
                FontWeight::Normal
            }
        }
    }
}
