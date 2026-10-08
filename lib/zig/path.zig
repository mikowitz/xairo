const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const ContextResource = @import("context.zig").ContextResource;
const checkContext = @import("context.zig").checkContext;

pub fn new_path(ctx: ContextResource) beam.term {
    c.cairo_new_path(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn new_sub_path(ctx: ContextResource) beam.term {
    c.cairo_new_sub_path(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn close_path(ctx: ContextResource) beam.term {
    c.cairo_close_path(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn path_extents(ctx: ContextResource) beam.term {
    var x1: f64 = 0.0;
    var y1: f64 = 0.0;
    var x2: f64 = 0.0;
    var y2: f64 = 0.0;
    c.cairo_path_extents(ctx.unpack().ptr, &x1, &y1, &x2, &y2);

    return beam.make(.{ .{ x1, y1 }, .{ x2, y2 } }, .{});
}

pub fn has_current_point(ctx: ContextResource) bool {
    return c.cairo_has_current_point(ctx.unpack().ptr) == 1;
}

pub fn get_current_point(ctx: ContextResource) beam.term {
    var x: f64 = 0.0;
    var y: f64 = 0.0;
    c.cairo_get_current_point(ctx.unpack().ptr, &x, &y);
    return beam.make(.{ x, y }, .{});
}

pub fn move_to(ctx: ContextResource, x: f64, y: f64) beam.term {
    c.cairo_move_to(ctx.unpack().ptr, x, y);
    return checkContext(ctx);
}

pub fn rel_move_to(ctx: ContextResource, dx: f64, dy: f64) beam.term {
    c.cairo_rel_move_to(ctx.unpack().ptr, dx, dy);
    return checkContext(ctx);
}

pub fn line_to(ctx: ContextResource, x: f64, y: f64) beam.term {
    c.cairo_line_to(ctx.unpack().ptr, x, y);
    return checkContext(ctx);
}

pub fn rel_line_to(ctx: ContextResource, dx: f64, dy: f64) beam.term {
    c.cairo_rel_line_to(ctx.unpack().ptr, dx, dy);
    return checkContext(ctx);
}

pub fn rectangle(ctx: ContextResource, x: f64, y: f64, width: f64, height: f64) beam.term {
    c.cairo_rectangle(ctx.unpack().ptr, x, y, width, height);
    return checkContext(ctx);
}

pub fn arc(ctx: ContextResource, xc: f64, yc: f64, radius: f64, angle1: f64, angle2: f64) beam.term {
    c.cairo_arc(ctx.unpack().ptr, xc, yc, radius, angle1, angle2);
    return checkContext(ctx);
}

pub fn arc_negative(ctx: ContextResource, xc: f64, yc: f64, radius: f64, angle1: f64, angle2: f64) beam.term {
    c.cairo_arc_negative(ctx.unpack().ptr, xc, yc, radius, angle1, angle2);
    return checkContext(ctx);
}

pub fn curve_to(ctx: ContextResource, x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) beam.term {
    c.cairo_curve_to(ctx.unpack().ptr, x1, y1, x2, y2, x3, y3);
    return checkContext(ctx);
}

pub fn rel_curve_to(ctx: ContextResource, dx1: f64, dy1: f64, dx2: f64, dy2: f64, dx3: f64, dy3: f64) beam.term {
    c.cairo_rel_curve_to(ctx.unpack().ptr, dx1, dy1, dx2, dy2, dx3, dy3);
    return checkContext(ctx);
}
