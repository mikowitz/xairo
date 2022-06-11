use crate::{context::Context, enums::error::Error};

#[derive(rustler::NifStruct)]
#[module = "Xairo.TextExtents"]
pub struct TextExtents {
    pub x_bearing: f64,
    pub y_bearing: f64,
    pub width: f64,
    pub height: f64,
    pub x_advance: f64,
    pub y_advance: f64,
    pub text: Option<String>,
}

impl From<cairo::TextExtents> for TextExtents {
    fn from(extents: cairo::TextExtents) -> Self {
        TextExtents {
            x_bearing: extents.x_bearing,
            y_bearing: extents.y_bearing,
            width: extents.width,
            height: extents.height,
            x_advance: extents.x_advance,
            y_advance: extents.y_advance,
            text: None,
        }
    }
}

#[rustler::nif]
fn text_extents_text_extents(text: &str, context: Context) -> Result<TextExtents, Error> {
    match context.context.text_extents(text) {
        Ok(extents) => {
            let mut extents: TextExtents = extents.into();
            extents.text = Some(text.to_string());
            Ok(extents)
        }
        Err(err) => Err(err.into()),
    }
}
