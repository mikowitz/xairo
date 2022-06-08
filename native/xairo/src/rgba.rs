#[derive(rustler::NifStruct)]
#[module = "Xairo.Rgba"]
pub struct Rgba {
    pub red: f64,
    pub green: f64,
    pub blue: f64,
    pub alpha: f64,
}

impl Rgba {
    pub fn new(red: f64, green: f64, blue: f64, alpha: f64) -> Self {
        Self {
            red,
            green,
            blue,
            alpha,
        }
    }

    pub fn to_tuple(&self) -> (f64, f64, f64, f64) {
        (self.red, self.green, self.blue, self.alpha)
    }
}
