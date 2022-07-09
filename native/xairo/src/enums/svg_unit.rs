#[derive(rustler::NifUnitEnum)]
pub enum SvgUnit {
    User,
    Em,
    Ex,
    Px,
    In,
    Cm,
    Mm,
    Pt,
    Pc,
    Percent,
}

impl From<cairo::SvgUnit> for SvgUnit {
    fn from(unit: cairo::SvgUnit) -> Self {
        match unit {
            cairo::SvgUnit::User => Self::User,
            cairo::SvgUnit::Em => Self::Em,
            cairo::SvgUnit::Ex => Self::Ex,
            cairo::SvgUnit::Px => Self::Px,
            cairo::SvgUnit::In => Self::In,
            cairo::SvgUnit::Cm => Self::Cm,
            cairo::SvgUnit::Mm => Self::Mm,
            cairo::SvgUnit::Pt => Self::Pt,
            cairo::SvgUnit::Pc => Self::Pc,
            cairo::SvgUnit::Percent => Self::Percent,
            unit => {
                println!("{:#?}", unit);
                Self::User
            }
        }
    }
}

impl From<SvgUnit> for cairo::SvgUnit {
    fn from(unit: SvgUnit) -> Self {
        match unit {
            SvgUnit::User => Self::User,
            SvgUnit::Em => Self::Em,
            SvgUnit::Ex => Self::Ex,
            SvgUnit::Px => Self::Px,
            SvgUnit::In => Self::In,
            SvgUnit::Cm => Self::Cm,
            SvgUnit::Mm => Self::Mm,
            SvgUnit::Pt => Self::Pt,
            SvgUnit::Pc => Self::Pc,
            SvgUnit::Percent => Self::Percent,
        }
    }
}
