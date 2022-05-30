use rustler::{Env, Term};

mod context;
mod enums;
mod image_surface;
mod linear_gradient;
mod mesh;
mod path;
mod pdf_surface;
mod ps_surface;
mod radial_gradient;
mod solid_pattern;
mod surface_pattern;
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
        context::context_set_source_linear_gradient,
        context::context_set_source_radial_gradient,
        context::context_set_source_solid_pattern,
        context::context_set_source_surface_pattern,
        context::context_set_source_mesh,
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
        // linear gradient
        linear_gradient::linear_gradient_new,
        linear_gradient::linear_gradient_linear_points,
        linear_gradient::linear_gradient_color_stop_count,
        linear_gradient::linear_gradient_add_color_stop_rgb,
        linear_gradient::linear_gradient_add_color_stop_rgba,
        linear_gradient::linear_gradient_color_stop_rgba,
        // radial gradient
        radial_gradient::radial_gradient_new,
        radial_gradient::radial_gradient_radial_circles,
        radial_gradient::radial_gradient_color_stop_count,
        radial_gradient::radial_gradient_add_color_stop_rgb,
        radial_gradient::radial_gradient_add_color_stop_rgba,
        radial_gradient::radial_gradient_color_stop_rgba,
        // solid pattern
        solid_pattern::solid_pattern_from_rgb,
        solid_pattern::solid_pattern_from_rgba,
        solid_pattern::solid_pattern_rgba,
        // surface pattern
        surface_pattern::surface_pattern_create_from_image_surface,
        surface_pattern::surface_pattern_create_from_pdf_surface,
        surface_pattern::surface_pattern_create_from_ps_surface,
        surface_pattern::surface_pattern_create_from_svg_surface,
        // mesh
        mesh::mesh_new,
        mesh::mesh_patch_count,
        mesh::mesh_begin_patch,
        mesh::mesh_end_patch,
        mesh::mesh_move_to,
        mesh::mesh_line_to,
        mesh::mesh_curve_to,
        mesh::mesh_set_control_point,
        mesh::mesh_control_point,
        mesh::mesh_set_corner_color_rgb,
        mesh::mesh_set_corner_color_rgba,
        mesh::mesh_corner_color_rgba,
        mesh::mesh_path,
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
    rustler::resource!(linear_gradient::LinearGradientRaw, env);
    rustler::resource!(radial_gradient::RadialGradientRaw, env);
    rustler::resource!(solid_pattern::SolidPatternRaw, env);
    rustler::resource!(surface_pattern::SurfacePatternRaw, env);
    rustler::resource!(mesh::MeshRaw, env);
    true
}
