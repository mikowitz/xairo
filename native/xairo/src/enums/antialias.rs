#[derive(rustler::NifUnitEnum)]
pub enum Antialias {
    Default,
    None,
    Gray,
    Subpixel,
    Fast,
    Good,
    Best,
}

impl From<cairo::Antialias> for Antialias {
    fn from(antialias: cairo::Antialias) -> Self {
        match antialias {
            cairo::Antialias::Default => Self::Default,
            cairo::Antialias::None => Self::None,
            cairo::Antialias::Gray => Self::Gray,
            cairo::Antialias::Subpixel => Self::Subpixel,
            cairo::Antialias::Fast => Self::Fast,
            cairo::Antialias::Good => Self::Good,
            cairo::Antialias::Best => Self::Best,
            _ => {
                println!("unknown antialias: {:?}", antialias);
                Self::Default
            }
        }
    }
}

impl From<Antialias> for cairo::Antialias {
    fn from(antialias: Antialias) -> Self {
        match antialias {
            Antialias::Default => Self::Default,
            Antialias::None => Self::None,
            Antialias::Gray => Self::Gray,
            Antialias::Subpixel => Self::Subpixel,
            Antialias::Fast => Self::Fast,
            Antialias::Good => Self::Good,
            Antialias::Best => Self::Best,
        }
    }
}
