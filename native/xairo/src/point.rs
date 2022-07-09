#[derive(rustler::NifStruct)]
#[module = "Xairo.Point"]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

impl Point {
    pub const fn to_tuple(&self) -> (f64, f64) {
        (self.x, self.y)
    }
}
