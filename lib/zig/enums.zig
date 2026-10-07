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
