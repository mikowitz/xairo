use crate::enums::{error::Error, font_slant::FontSlant, font_weight::FontWeight};
use rustler::ResourceArc;

pub struct FontFaceRaw {
    pub font_face: cairo::FontFace,
}

unsafe impl Send for FontFaceRaw {}
unsafe impl Sync for FontFaceRaw {}

pub type FontFace = ResourceArc<FontFaceRaw>;

#[rustler::nif]
fn font_face_toy_create(
    family: String,
    slant: FontSlant,
    weight: FontWeight,
) -> Result<FontFace, Error> {
    match cairo::FontFace::toy_create(&family, slant.into(), weight.into()) {
        Ok(font_face) => Ok(ResourceArc::new(FontFaceRaw { font_face })),
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
