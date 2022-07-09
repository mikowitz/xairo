#[derive(rustler::NifUnitEnum)]
pub enum Operator {
    Clear,
    Source,
    Over,
    In,
    Out,
    Atop,
    Dest,
    DestOver,
    DestIn,
    DestOut,
    DestAtop,
    Xor,
    Add,
    Saturate,
    Multiply,
    Screen,
    Overlay,
    Darken,
    Lighten,
    ColorDodge,
    ColorBurn,
    HardLight,
    SoftLight,
    Difference,
    Exclusion,
    HslHue,
    HslSaturation,
    HslColor,
    HslLuminosity,
}

impl From<cairo::Operator> for Operator {
    fn from(operator: cairo::Operator) -> Self {
        match operator {
            cairo::Operator::Clear => Self::Clear,
            cairo::Operator::Source => Self::Source,
            cairo::Operator::Over => Self::Over,
            cairo::Operator::In => Self::In,
            cairo::Operator::Out => Self::Out,
            cairo::Operator::Atop => Self::Atop,
            cairo::Operator::Dest => Self::Dest,
            cairo::Operator::DestOver => Self::DestOver,
            cairo::Operator::DestIn => Self::DestIn,
            cairo::Operator::DestOut => Self::DestOut,
            cairo::Operator::DestAtop => Self::DestAtop,
            cairo::Operator::Xor => Self::Xor,
            cairo::Operator::Add => Self::Add,
            cairo::Operator::Saturate => Self::Saturate,
            cairo::Operator::Multiply => Self::Multiply,
            cairo::Operator::Screen => Self::Screen,
            cairo::Operator::Overlay => Self::Overlay,
            cairo::Operator::Darken => Self::Darken,
            cairo::Operator::Lighten => Self::Lighten,
            cairo::Operator::ColorDodge => Self::ColorDodge,
            cairo::Operator::ColorBurn => Self::ColorBurn,
            cairo::Operator::HardLight => Self::HardLight,
            cairo::Operator::SoftLight => Self::SoftLight,
            cairo::Operator::Difference => Self::Difference,
            cairo::Operator::Exclusion => Self::Exclusion,
            cairo::Operator::HslHue => Self::HslHue,
            cairo::Operator::HslSaturation => Self::HslSaturation,
            cairo::Operator::HslColor => Self::HslColor,
            cairo::Operator::HslLuminosity => Self::HslLuminosity,
            _ => {
                println!("unknown operator {:?}", operator);
                Self::Over
            }
        }
    }
}

impl From<Operator> for cairo::Operator {
    fn from(operator: Operator) -> Self {
        match operator {
            Operator::Clear => Self::Clear,
            Operator::Source => Self::Source,
            Operator::Over => Self::Over,
            Operator::In => Self::In,
            Operator::Out => Self::Out,
            Operator::Atop => Self::Atop,
            Operator::Dest => Self::Dest,
            Operator::DestOver => Self::DestOver,
            Operator::DestIn => Self::DestIn,
            Operator::DestOut => Self::DestOut,
            Operator::DestAtop => Self::DestAtop,
            Operator::Xor => Self::Xor,
            Operator::Add => Self::Add,
            Operator::Saturate => Self::Saturate,
            Operator::Multiply => Self::Multiply,
            Operator::Screen => Self::Screen,
            Operator::Overlay => Self::Overlay,
            Operator::Darken => Self::Darken,
            Operator::Lighten => Self::Lighten,
            Operator::ColorDodge => Self::ColorDodge,
            Operator::ColorBurn => Self::ColorBurn,
            Operator::HardLight => Self::HardLight,
            Operator::SoftLight => Self::SoftLight,
            Operator::Difference => Self::Difference,
            Operator::Exclusion => Self::Exclusion,
            Operator::HslHue => Self::HslHue,
            Operator::HslSaturation => Self::HslSaturation,
            Operator::HslColor => Self::HslColor,
            Operator::HslLuminosity => Self::HslLuminosity,
        }
    }
}
