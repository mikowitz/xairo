use crate::{context::Context, enums::Error};

#[derive(rustler::NifStruct)]
#[module = "Xairo.FontExtents"]
pub struct FontExtents {
    pub ascent: f64,
    pub descent: f64,
    pub height: f64,
    pub max_x_advance: f64,
    pub max_y_advance: f64,
}

impl From<cairo::FontExtents> for FontExtents {
    fn from(extents: cairo::FontExtents) -> Self {
        Self {
            ascent: extents.ascent,
            descent: extents.descent,
            height: extents.height,
            max_x_advance: extents.max_x_advance,
            max_y_advance: extents.max_y_advance,
        }
    }
}

#[rustler::nif]
fn font_extents_font_extents(context: Context) -> Result<FontExtents, Error> {
    match context.context.font_extents() {
        Ok(extents) => Ok(extents.into()),
        Err(err) => Err(err.into()),
    }
}
