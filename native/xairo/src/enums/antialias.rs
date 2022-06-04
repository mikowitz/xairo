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

impl From<Antialias> for cairo::Antialias {
    fn from(antialias: Antialias) -> Self {
        match antialias {
            Antialias::Default => cairo::Antialias::Default,
            Antialias::None => cairo::Antialias::None,
            Antialias::Gray => cairo::Antialias::Gray,
            Antialias::Subpixel => cairo::Antialias::Subpixel,
            Antialias::Fast => cairo::Antialias::Fast,
            Antialias::Good => cairo::Antialias::Good,
            Antialias::Best => cairo::Antialias::Best,
        }
    }
}

impl From<cairo::Antialias> for Antialias {
    fn from(antialias: cairo::Antialias) -> Self {
        match antialias {
            cairo::Antialias::Default => Antialias::Default,
            cairo::Antialias::None => Antialias::None,
            cairo::Antialias::Gray => Antialias::Gray,
            cairo::Antialias::Subpixel => Antialias::Subpixel,
            cairo::Antialias::Fast => Antialias::Fast,
            cairo::Antialias::Good => Antialias::Good,
            cairo::Antialias::Best => Antialias::Best,
            _ => {
                println!("unknown antialias: {:?}", antialias);
                Antialias::Default
            }
        }
    }
}
