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
    fn from(unit: cairo::SvgUnit) -> SvgUnit {
        match unit {
            cairo::SvgUnit::User => SvgUnit::User,
            cairo::SvgUnit::Em => SvgUnit::Em,
            cairo::SvgUnit::Ex => SvgUnit::Ex,
            cairo::SvgUnit::Px => SvgUnit::Px,
            cairo::SvgUnit::In => SvgUnit::In,
            cairo::SvgUnit::Cm => SvgUnit::Cm,
            cairo::SvgUnit::Mm => SvgUnit::Mm,
            cairo::SvgUnit::Pt => SvgUnit::Pt,
            cairo::SvgUnit::Pc => SvgUnit::Pc,
            cairo::SvgUnit::Percent => SvgUnit::Percent,
            unit => {
                println!("{:#?}", unit);
                SvgUnit::User
            }
        }
    }
}

impl From<SvgUnit> for cairo::SvgUnit {
    fn from(unit: SvgUnit) -> cairo::SvgUnit {
        match unit {
            SvgUnit::User => cairo::SvgUnit::User,
            SvgUnit::Em => cairo::SvgUnit::Em,
            SvgUnit::Ex => cairo::SvgUnit::Ex,
            SvgUnit::Px => cairo::SvgUnit::Px,
            SvgUnit::In => cairo::SvgUnit::In,
            SvgUnit::Cm => cairo::SvgUnit::Cm,
            SvgUnit::Mm => cairo::SvgUnit::Mm,
            SvgUnit::Pt => cairo::SvgUnit::Pt,
            SvgUnit::Pc => cairo::SvgUnit::Pc,
            SvgUnit::Percent => cairo::SvgUnit::Percent,
        }
    }
}
