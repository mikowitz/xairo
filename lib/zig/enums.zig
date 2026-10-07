const std = @import("std");
const beam = @import("beam");
const c = @import("cairo");

pub const LineCap = enum(c.cairo_line_cap_t) {
    butt = c.CAIRO_LINE_CAP_BUTT,
    round,
    square,
};

pub const FontSlant = enum(c.cairo_font_slant_t) {
    normal = c.CAIRO_FONT_SLANT_NORMAL,
    italic,
    oblique,
};

pub const FontWeight = enum(c.cairo_font_weight_t) {
    normal = c.CAIRO_FONT_WEIGHT_NORMAL,
    bold,
};

pub const SurfaceType = enum(c.cairo_surface_type_t) {
    image = c.CAIRO_SURFACE_TYPE_IMAGE,
    pdf,
    ps,
    xlib,
    xcb,
    glitz,
    quartz,
    win32,
    beos,
    directfb,
    svg,
    os2,
    win32_printing,
    quartz_image,
    script,
    qt,
    recording,
    vg,
    gl,
    drm,
    tee,
    xml,
    skia,
    subsurface,
    cogl,
};
