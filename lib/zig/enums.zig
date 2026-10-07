const std = @import("std");
const beam = @import("beam");
const c = @import("cairo");

pub const LineCap = enum(c.cairo_line_cap_t) {
    butt = c.CAIRO_LINE_CAP_BUTT,
    round,
    square,
};
