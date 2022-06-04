#[derive(rustler::NifUnitEnum)]
pub enum LineJoin {
    Miter,
    Round,
    Bevel,
}

impl From<LineJoin> for cairo::LineJoin {
    fn from(line_join: LineJoin) -> Self {
        match line_join {
            LineJoin::Miter => cairo::LineJoin::Miter,
            LineJoin::Round => cairo::LineJoin::Round,
            LineJoin::Bevel => cairo::LineJoin::Bevel,
        }
    }
}

impl From<cairo::LineJoin> for LineJoin {
    fn from(line_join: cairo::LineJoin) -> Self {
        match line_join {
            cairo::LineJoin::Miter => LineJoin::Miter,
            cairo::LineJoin::Round => LineJoin::Round,
            cairo::LineJoin::Bevel => LineJoin::Bevel,
            _ => {
                println!("unknown line join: {:?}", line_join);
                LineJoin::Miter
            }
        }
    }
}
