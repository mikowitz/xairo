#[derive(rustler::NifStruct)]
#[module = "Xairo.Vector"]
pub struct Vector {
    pub x: f64,
    pub y: f64,
}

impl Vector {
    pub const fn to_tuple(&self) -> (f64, f64) {
        (self.x, self.y)
    }
}
