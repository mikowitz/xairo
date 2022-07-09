#[derive(rustler::NifUnitEnum)]
pub enum LineCap {
    Butt,
    Round,
    Square,
}

impl From<cairo::LineCap> for LineCap {
    fn from(line_cap: cairo::LineCap) -> Self {
        match line_cap {
            cairo::LineCap::Butt => Self::Butt,
            cairo::LineCap::Round => Self::Round,
            cairo::LineCap::Square => Self::Square,
            _ => {
                println!("unknown line cap {:?}", line_cap);
                Self::Butt
            }
        }
    }
}

impl From<LineCap> for cairo::LineCap {
    fn from(line_cap: LineCap) -> Self {
        match line_cap {
            LineCap::Butt => Self::Butt,
            LineCap::Round => Self::Round,
            LineCap::Square => Self::Square,
        }
    }
}
