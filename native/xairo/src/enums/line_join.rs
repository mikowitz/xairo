#[derive(rustler::NifUnitEnum)]
pub enum LineJoin {
    Miter,
    Round,
    Bevel,
}

impl From<cairo::LineJoin> for LineJoin {
    fn from(line_join: cairo::LineJoin) -> Self {
        match line_join {
            cairo::LineJoin::Miter => Self::Miter,
            cairo::LineJoin::Round => Self::Round,
            cairo::LineJoin::Bevel => Self::Bevel,
            _ => {
                println!("unknown line join: {:?}", line_join);
                Self::Miter
            }
        }
    }
}

impl From<LineJoin> for cairo::LineJoin {
    fn from(line_join: LineJoin) -> Self {
        match line_join {
            LineJoin::Miter => Self::Miter,
            LineJoin::Round => Self::Round,
            LineJoin::Bevel => Self::Bevel,
        }
    }
}
