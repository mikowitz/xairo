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

impl From<Operator> for cairo::Operator {
    fn from(operator: Operator) -> Self {
        match operator {
            Operator::Clear => cairo::Operator::Clear,
            Operator::Source => cairo::Operator::Source,
            Operator::Over => cairo::Operator::Over,
            Operator::In => cairo::Operator::In,
            Operator::Out => cairo::Operator::Out,
            Operator::Atop => cairo::Operator::Atop,
            Operator::Dest => cairo::Operator::Dest,
            Operator::DestOver => cairo::Operator::DestOver,
            Operator::DestIn => cairo::Operator::DestIn,
            Operator::DestOut => cairo::Operator::DestOut,
            Operator::DestAtop => cairo::Operator::DestAtop,
            Operator::Xor => cairo::Operator::Xor,
            Operator::Add => cairo::Operator::Add,
            Operator::Saturate => cairo::Operator::Saturate,
            Operator::Multiply => cairo::Operator::Multiply,
            Operator::Screen => cairo::Operator::Screen,
            Operator::Overlay => cairo::Operator::Overlay,
            Operator::Darken => cairo::Operator::Darken,
            Operator::Lighten => cairo::Operator::Lighten,
            Operator::ColorDodge => cairo::Operator::ColorDodge,
            Operator::ColorBurn => cairo::Operator::ColorBurn,
            Operator::HardLight => cairo::Operator::HardLight,
            Operator::SoftLight => cairo::Operator::SoftLight,
            Operator::Difference => cairo::Operator::Difference,
            Operator::Exclusion => cairo::Operator::Exclusion,
            Operator::HslHue => cairo::Operator::HslHue,
            Operator::HslSaturation => cairo::Operator::HslSaturation,
            Operator::HslColor => cairo::Operator::HslColor,
            Operator::HslLuminosity => cairo::Operator::HslLuminosity,
        }
    }
}

impl From<cairo::Operator> for Operator {
    fn from(operator: cairo::Operator) -> Self {
        match operator {
            cairo::Operator::Clear => Operator::Clear,
            cairo::Operator::Source => Operator::Source,
            cairo::Operator::Over => Operator::Over,
            cairo::Operator::In => Operator::In,
            cairo::Operator::Out => Operator::Out,
            cairo::Operator::Atop => Operator::Atop,
            cairo::Operator::Dest => Operator::Dest,
            cairo::Operator::DestOver => Operator::DestOver,
            cairo::Operator::DestIn => Operator::DestIn,
            cairo::Operator::DestOut => Operator::DestOut,
            cairo::Operator::DestAtop => Operator::DestAtop,
            cairo::Operator::Xor => Operator::Xor,
            cairo::Operator::Add => Operator::Add,
            cairo::Operator::Saturate => Operator::Saturate,
            cairo::Operator::Multiply => Operator::Multiply,
            cairo::Operator::Screen => Operator::Screen,
            cairo::Operator::Overlay => Operator::Overlay,
            cairo::Operator::Darken => Operator::Darken,
            cairo::Operator::Lighten => Operator::Lighten,
            cairo::Operator::ColorDodge => Operator::ColorDodge,
            cairo::Operator::ColorBurn => Operator::ColorBurn,
            cairo::Operator::HardLight => Operator::HardLight,
            cairo::Operator::SoftLight => Operator::SoftLight,
            cairo::Operator::Difference => Operator::Difference,
            cairo::Operator::Exclusion => Operator::Exclusion,
            cairo::Operator::HslHue => Operator::HslHue,
            cairo::Operator::HslSaturation => Operator::HslSaturation,
            cairo::Operator::HslColor => Operator::HslColor,
            cairo::Operator::HslLuminosity => Operator::HslLuminosity,
            _ => {
                println!("unknown operator {:?}", operator);
                Operator::Over
            }
        }
    }
}
