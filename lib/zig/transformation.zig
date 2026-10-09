const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const ContextResource = @import("context.zig").ContextResource;
const checkContext = @import("context.zig").checkContext;
const matrix = @import("matrix.zig");

pub fn translate(ctx: ContextResource, tx: f64, ty: f64) beam.term {
    c.cairo_translate(ctx.unpack().ptr, tx, ty);
    return checkContext(ctx);
}

pub fn scale(ctx: ContextResource, sx: f64, sy: f64) beam.term {
    c.cairo_scale(ctx.unpack().ptr, sx, sy);
    return checkContext(ctx);
}

pub fn rotate(ctx: ContextResource, angle: f64) beam.term {
    c.cairo_rotate(ctx.unpack().ptr, angle);
    return checkContext(ctx);
}

pub fn transform(ctx: ContextResource, m: matrix.Matrix) beam.term {
    const matrix_c = m.to_cairo();
    c.cairo_transform(ctx.unpack().ptr, &matrix_c);
    return checkContext(ctx);
}

pub fn set_matrix(ctx: ContextResource, m: matrix.Matrix) beam.term {
    const matrix_c = m.to_cairo();
    c.cairo_set_matrix(ctx.unpack().ptr, &matrix_c);
    return checkContext(ctx);
}

pub fn get_matrix(ctx: ContextResource) matrix.Matrix {
    var m: c.cairo_matrix_t = undefined;
    c.cairo_get_matrix(ctx.unpack().ptr, &m);
    return matrix.Matrix.from_cairo(m);
}

pub fn identity_matrix(ctx: ContextResource) beam.term {
    c.cairo_identity_matrix(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn device_to_user(ctx: ContextResource, x: f64, y: f64) beam.term {
    var nx: f64 = x;
    var ny: f64 = y;
    c.cairo_device_to_user(ctx.unpack().ptr, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}

pub fn device_to_user_distance(ctx: ContextResource, dx: f64, dy: f64) beam.term {
    var nx: f64 = dx;
    var ny: f64 = dy;
    c.cairo_device_to_user(ctx.unpack().ptr, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}

pub fn user_to_device(ctx: ContextResource, x: f64, y: f64) beam.term {
    var nx: f64 = x;
    var ny: f64 = y;
    c.cairo_user_to_device(ctx.unpack().ptr, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}

pub fn user_to_device_distance(ctx: ContextResource, dx: f64, dy: f64) beam.term {
    var nx: f64 = dx;
    var ny: f64 = dy;
    c.cairo_user_to_device(ctx.unpack().ptr, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}
