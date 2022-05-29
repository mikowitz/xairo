use rustler::{Env, Term};

mod context;
mod enums;
mod image_surface;
mod path;
mod pdf_surface;
mod ps_surface;
mod svg_surface;

rustler::init!(
    "Elixir.Xairo.Native",
    [
        // image surface
        image_surface::image_surface_create,
        image_surface::image_surface_write_to_png,
        image_surface::image_surface_width,
        image_surface::image_surface_height,
        image_surface::image_surface_stride,
        image_surface::image_surface_format,
        // pdf surface
        pdf_surface::pdf_surface_new,
        pdf_surface::pdf_surface_finish,
        // ps surface
        ps_surface::ps_surface_new,
        ps_surface::ps_surface_finish,
        // svg surface
        svg_surface::svg_surface_new,
        svg_surface::svg_surface_finish,
        svg_surface::svg_surface_document_unit,
        svg_surface::svg_surface_set_document_unit,
        // context
        context::context_new,
        context::context_new_from_pdf_surface,
        context::context_new_from_ps_surface,
        context::context_new_from_svg_surface,
        context::context_set_source_rgb,
        context::context_set_source_rgba,
        context::context_arc,
        context::context_arc_negative,
        context::context_curve_to,
        context::context_rel_curve_to,
        context::context_line_to,
        context::context_rel_line_to,
        context::context_rectangle,
        context::context_move_to,
        context::context_rel_move_to,
        context::context_close_path,
        context::context_stroke,
        context::context_stroke_preserve,
        context::context_fill,
        context::context_paint,
        context::context_paint_with_alpha,
        context::context_copy_path,
        context::context_copy_path_flat,
        context::context_append_path,
        context::context_tolerance,
        context::context_set_tolerance,
        context::context_has_current_point,
        context::context_current_point,
        context::context_new_path,
        context::context_new_sub_path,
        // path
        path::path_iter,
    ],
    load = on_load
);

fn on_load(env: Env, _info: Term) -> bool {
    rustler::resource!(image_surface::ImageSurfaceRaw, env);
    rustler::resource!(pdf_surface::PdfSurfaceRaw, env);
    rustler::resource!(ps_surface::PsSurfaceRaw, env);
    rustler::resource!(svg_surface::SvgSurfaceRaw, env);
    rustler::resource!(context::ContextRaw, env);
    rustler::resource!(path::PathRaw, env);
    true
}
