#[derive(rustler::NifUnitEnum)]
pub enum FillRule {
    Winding,
    EvenOdd,
}

impl From<cairo::FillRule> for FillRule {
    fn from(rule: cairo::FillRule) -> Self {
        match rule {
            cairo::FillRule::Winding => Self::Winding,
            cairo::FillRule::EvenOdd => Self::EvenOdd,
            _ => {
                println!("unknown fill rule {:?}", rule);
                Self::Winding
            }
        }
    }
}

impl From<FillRule> for cairo::FillRule {
    fn from(rule: FillRule) -> Self {
        match rule {
            FillRule::Winding => Self::Winding,
            FillRule::EvenOdd => Self::EvenOdd,
        }
    }
}
