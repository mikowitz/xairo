use crate::point::Point;

#[derive(rustler::NifTaggedEnum)]
pub enum PathSegment {
    MoveTo(Point),
    LineTo(Point),
    CurveTo(Point, Point, Point),
    ClosePath,
}

impl From<cairo::PathSegment> for PathSegment {
    fn from(segment: cairo::PathSegment) -> Self {
        match segment {
            cairo::PathSegment::MoveTo((x, y)) => Self::MoveTo(Point { x, y }),
            cairo::PathSegment::LineTo((x, y)) => Self::LineTo(Point { x, y }),
            cairo::PathSegment::CurveTo((x1, y1), (x2, y2), (x3, y3)) => Self::CurveTo(
                Point { x: x1, y: y1 },
                Point { x: x2, y: y2 },
                Point { x: x3, y: y3 },
            ),
            cairo::PathSegment::ClosePath => Self::ClosePath,
        }
    }
}
