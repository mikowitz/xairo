#[derive(rustler::NifUnitEnum)]
pub enum LineCap {
    Butt,
    Round,
    Square,
}

impl From<cairo::LineCap> for LineCap {
    fn from(line_cap: cairo::LineCap) -> Self {
        match line_cap {
            cairo::LineCap::Butt => LineCap::Butt,
            cairo::LineCap::Round => LineCap::Round,
            cairo::LineCap::Square => LineCap::Square,
            _ => {
                println!("unknown line cap {:?}", line_cap);
                LineCap::Butt
            }
        }
    }
}

impl From<LineCap> for cairo::LineCap {
    fn from(line_cap: LineCap) -> Self {
        match line_cap {
            LineCap::Butt => cairo::LineCap::Butt,
            LineCap::Round => cairo::LineCap::Round,
            LineCap::Square => cairo::LineCap::Square,
        }
    }
}
