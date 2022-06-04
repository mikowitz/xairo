#[derive(rustler::NifUnitEnum)]
pub enum FillRule {
    Winding,
    EvenOdd,
}

impl From<FillRule> for cairo::FillRule {
    fn from(rule: FillRule) -> Self {
        match rule {
            FillRule::Winding => cairo::FillRule::Winding,
            FillRule::EvenOdd => cairo::FillRule::EvenOdd,
        }
    }
}

impl From<cairo::FillRule> for FillRule {
    fn from(rule: cairo::FillRule) -> Self {
        match rule {
            cairo::FillRule::Winding => FillRule::Winding,
            cairo::FillRule::EvenOdd => FillRule::EvenOdd,
            _ => {
                println!("unknown fill rule {:?}", rule);
                FillRule::Winding
            }
        }
    }
}
