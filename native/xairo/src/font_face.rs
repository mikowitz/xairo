use crate::enums::{Error, FontSlant, FontWeight};
use rustler::ResourceArc;

pub struct Raw {
    pub font_face: cairo::FontFace,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type FontFace = ResourceArc<Raw>;

#[rustler::nif]
fn font_face_toy_create(
    family: String,
    slant: FontSlant,
    weight: FontWeight,
) -> Result<FontFace, Error> {
    match cairo::FontFace::toy_create(&family, slant.into(), weight.into()) {
        Ok(font_face) => Ok(ResourceArc::new(Raw { font_face })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn font_face_toy_get_family(font_face: FontFace) -> Option<String> {
    font_face.font_face.toy_get_family()
}

#[rustler::nif]
fn font_face_toy_get_slant(font_face: FontFace) -> FontSlant {
    font_face.font_face.toy_get_slant().into()
}

#[rustler::nif]
fn font_face_toy_get_weight(font_face: FontFace) -> FontWeight {
    font_face.font_face.toy_get_weight().into()
}
