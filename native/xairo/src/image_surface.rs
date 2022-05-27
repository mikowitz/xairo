use crate::enums::{error::Error, format::Format};
use rustler::ResourceArc;
use std::fs::File;

pub struct ImageSurfaceRaw {
    surface: cairo::ImageSurface,
}

unsafe impl Send for ImageSurfaceRaw {}
unsafe impl Sync for ImageSurfaceRaw {}

pub type ImageSurface = ResourceArc<ImageSurfaceRaw>;

#[rustler::nif]
fn image_surface_create(format: Format, width: i32, height: i32) -> Result<ImageSurface, Error> {
    match cairo::ImageSurface::create(format.into(), width, height) {
        Ok(surface) => Ok(ResourceArc::new(ImageSurfaceRaw { surface })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn image_surface_write_to_png(surface: ImageSurface, filename: String) -> Result<(), Error> {
    match File::create(filename) {
        Ok(mut file) => match surface.surface.write_to_png(&mut file) {
            Ok(_) => Ok(()),
            Err(_) => Err(Error::WriteError),
        },
        Err(_) => Err(Error::WriteError),
    }
}

#[rustler::nif]
fn image_surface_width(surface: ImageSurface) -> i32 {
    surface.surface.width()
}

#[rustler::nif]
fn image_surface_height(surface: ImageSurface) -> i32 {
    surface.surface.height()
}

#[rustler::nif]
fn image_surface_stride(surface: ImageSurface) -> i32 {
    surface.surface.stride()
}

#[rustler::nif]
fn image_surface_format(surface: ImageSurface) -> Format {
    surface.surface.format().into()
}
