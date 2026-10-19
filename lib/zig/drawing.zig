const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const ContextResource = @import("context.zig").ContextResource;
const checkContext = @import("context.zig").checkContext;

pub fn paint(ctx: ContextResource) beam.term {
    c.cairo_paint(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn paint_with_alpha(ctx: ContextResource, alpha: f64) beam.term {
    c.cairo_paint_with_alpha(ctx.unpack().ptr, alpha);
    return checkContext(ctx);
}

pub fn fill(ctx: ContextResource) beam.term {
    c.cairo_fill(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn fill_preserve(ctx: ContextResource) beam.term {
    c.cairo_fill_preserve(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn stroke(ctx: ContextResource) beam.term {
    c.cairo_stroke(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn stroke_preserve(ctx: ContextResource) beam.term {
    c.cairo_stroke_preserve(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn stroke_extents(ctx: ContextResource) beam.term {
    var x1: f64 = 0.0;
    var y1: f64 = 0.0;
    var x2: f64 = 0.0;
    var y2: f64 = 0.0;
    c.cairo_stroke_extents(ctx.unpack().ptr, &x1, &y1, &x2, &y2);
    return beam.make(.{ .{ x1, y1 }, .{ x2, y2 } }, .{});
}

pub fn fill_extents(ctx: ContextResource) beam.term {
    var x1: f64 = 0.0;
    var y1: f64 = 0.0;
    var x2: f64 = 0.0;
    var y2: f64 = 0.0;
    c.cairo_fill_extents(ctx.unpack().ptr, &x1, &y1, &x2, &y2);
    return beam.make(.{ .{ x1, y1 }, .{ x2, y2 } }, .{});
}

pub fn in_fill(ctx: ContextResource, x: f64, y: f64) bool {
    return c.cairo_in_fill(ctx.unpack().ptr, x, y) == 1;
}

pub fn in_stroke(ctx: ContextResource, x: f64, y: f64) bool {
    return c.cairo_in_stroke(ctx.unpack().ptr, x, y) == 1;
}

pub fn clip(ctx: ContextResource) beam.term {
    c.cairo_clip(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn clip_preserve(ctx: ContextResource) beam.term {
    c.cairo_clip_preserve(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn reset_clip(ctx: ContextResource) beam.term {
    c.cairo_reset_clip(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn in_clip(ctx: ContextResource, x: f64, y: f64) bool {
    return c.cairo_in_clip(ctx.unpack().ptr, x, y) == 1;
}

pub fn clip_extents(ctx: ContextResource) beam.term {
    var x1: f64 = 0.0;
    var y1: f64 = 0.0;
    var x2: f64 = 0.0;
    var y2: f64 = 0.0;
    c.cairo_clip_extents(ctx.unpack().ptr, &x1, &y1, &x2, &y2);
    return beam.make(.{ .{ x1, y1 }, .{ x2, y2 } }, .{});
}
