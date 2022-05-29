pub type Point = (f64, f64);

#[derive(rustler::NifTaggedEnum)]
pub enum PathSegment {
    MoveTo(Point),
    LineTo(Point),
    CurveTo(Point, Point, Point),
    ClosePath,
}

impl From<cairo::PathSegment> for PathSegment {
    fn from(segment: cairo::PathSegment) -> PathSegment {
        match segment {
            cairo::PathSegment::MoveTo(point) => PathSegment::MoveTo(point),
            cairo::PathSegment::LineTo(point) => PathSegment::LineTo(point),
            cairo::PathSegment::CurveTo(point1, point2, point3) => {
                PathSegment::CurveTo(point1, point2, point3)
            }
            cairo::PathSegment::ClosePath => PathSegment::ClosePath,
        }
    }
}
