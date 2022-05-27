use rustler::{Env, Term};

mod enums;
mod image_surface;

rustler::init!(
    "Elixir.Xairo.Native",
    [
        image_surface::image_surface_create,
        image_surface::image_surface_write_to_png,
        image_surface::image_surface_width,
        image_surface::image_surface_height,
        image_surface::image_surface_stride,
        image_surface::image_surface_format,
    ],
    load = on_load
);

fn on_load(env: Env, _info: Term) -> bool {
    rustler::resource!(image_surface::ImageSurfaceRaw, env);
    true
}
