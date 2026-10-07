const std = @import("std");
const beam = @import("beam");
const c = @import("cairo");

pub const Antialias = enum(c.cairo_antialias_t) {
    default = c.CAIRO_ANTIALIAS_DEFAULT,
    none,
    gray,
    subpixel,
    fast,
    good,
    best,
};

pub const LineCap = enum(c.cairo_line_cap_t) {
    butt = c.CAIRO_LINE_CAP_BUTT,
    round,
    square,
};

pub const LineJoin = enum(c.cairo_line_join_t) {
    miter = c.CAIRO_LINE_JOIN_MITER,
    round,
    bevel,
};

pub const FillRule = enum(c.cairo_fill_rule_t) {
    winding = c.CAIRO_FILL_RULE_WINDING,
    even_odd,
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

pub const Operator = enum(c.cairo_operator_t) {
    clear = c.CAIRO_OPERATOR_CLEAR,
    source,
    over,
    in,
    out,
    atop,
    dest,
    dest_over,
    dest_in,
    dest_out,
    dest_atop,
    xor,
    add,
    saturate,
    multiply,
    screen,
    overlay,
    darken,
    lighten,
    color_dodge,
    color_burn,
    hard_light,
    soft_light,
    difference,
    exclusion,
    hsl_hue,
    hsl_saturation,
    hsl_color,
    hsl_luminosity,
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
