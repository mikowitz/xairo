const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const status = @import("status.zig");
const surface = @import("surface.zig");
const LineCap = @import("enums.zig").LineCap;
const enums = @import("enums.zig");

const allocator = std.heap.c_allocator;

const Context = struct {
    ptr: *c.cairo_t,
};

pub const ContextResourceCallbacks = struct {
    pub fn dtor(ctx: *Context) void {
        c.cairo_destroy(ctx.ptr);
        beam.allocator.destroy(ctx);
    }
};

pub const ContextResource = beam.Resource(Context, root, .{ .Callbacks = ContextResourceCallbacks });

pub fn context_create(s: surface.SurfaceResource) !beam.term {
    const ptr = c.cairo_create(s.unpack().ptr).?;
    const raw = c.cairo_status(ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        c.cairo_destroy(ptr);
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    const resource = try ContextResource.create(.{ .ptr = ptr }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

fn checkContext(ctx: ContextResource) beam.term {
    const raw = c.cairo_status(ctx.unpack().ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        return beam.make(.{ .@"error", status.atom(raw) }, .{});
    }
    return beam.make(ctx, .{});
}

pub fn set_source_rgb(ctx: ContextResource, r: f64, g: f64, b: f64) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_set_source_rgb(ptr, r, g, b);
    return checkContext(ctx);
}

pub fn set_source_rgba(ctx: ContextResource, r: f64, g: f64, b: f64, a: f64) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_set_source_rgba(ptr, r, g, b, a);
    return checkContext(ctx);
}

pub fn set_line_width(ctx: ContextResource, width: f64) beam.term {
    c.cairo_set_line_width(ctx.unpack().ptr, width);
    return checkContext(ctx);
}

pub fn set_line_cap(ctx: ContextResource, line_cap: LineCap) beam.term {
    c.cairo_set_line_cap(ctx.unpack().ptr, @intFromEnum(line_cap));
    return checkContext(ctx);
}

pub fn set_dash(ctx: ContextResource, dashes: []f64, offset: f64) beam.term {
    var dashes_c: [*c]f64 = undefined;
    dashes_c = @ptrCast(dashes);
    c.cairo_set_dash(ctx.unpack().ptr, dashes_c, @as(c_int, @intCast(dashes.len)), offset);
    return checkContext(ctx);
}

pub fn select_font_face(ctx: ContextResource, family: []const u8, slant: enums.FontSlant, weight: enums.FontWeight) !beam.term {
    const family_c = try allocator.dupeZ(u8, family);
    defer allocator.free(family_c);
    c.cairo_select_font_face(ctx.unpack().ptr, family_c, @intFromEnum(slant), @intFromEnum(weight));
    return checkContext(ctx);
}

pub fn set_font_size(ctx: ContextResource, size: f64) beam.term {
    c.cairo_set_font_size(ctx.unpack().ptr, size);
    return checkContext(ctx);
}

pub fn move_to(ctx: ContextResource, x: f64, y: f64) beam.term {
    c.cairo_move_to(ctx.unpack().ptr, x, y);
    return checkContext(ctx);
}

pub fn line_to(ctx: ContextResource, x: f64, y: f64) beam.term {
    c.cairo_line_to(ctx.unpack().ptr, x, y);
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

pub fn curve_to(ctx: ContextResource, x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) beam.term {
    c.cairo_curve_to(ctx.unpack().ptr, x1, y1, x2, y2, x3, y3);
    return checkContext(ctx);
}

pub fn translate(ctx: ContextResource, tx: f64, ty: f64) beam.term {
    c.cairo_translate(ctx.unpack().ptr, tx, ty);
    return checkContext(ctx);
}

pub fn rotate(ctx: ContextResource, angle: f64) beam.term {
    c.cairo_rotate(ctx.unpack().ptr, angle);
    return checkContext(ctx);
}

pub fn paint(ctx: ContextResource) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_paint(ptr);
    return checkContext(ctx);
}

pub fn fill(ctx: ContextResource) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_fill(ptr);
    return checkContext(ctx);
}

pub fn fill_preserve(ctx: ContextResource) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_fill_preserve(ptr);
    return checkContext(ctx);
}

pub fn stroke(ctx: ContextResource) beam.term {
    const ptr = ctx.unpack().ptr;
    c.cairo_stroke(ptr);
    return checkContext(ctx);
}

pub fn show_text(ctx: ContextResource, text: []const u8) !beam.term {
    const text_c = try allocator.dupeZ(u8, text);
    defer allocator.free(text_c);
    c.cairo_show_text(ctx.unpack().ptr, text_c);
    return checkContext(ctx);
}

pub fn save(ctx: ContextResource) beam.term {
    c.cairo_save(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn restore(ctx: ContextResource) beam.term {
    c.cairo_restore(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn clip(ctx: ContextResource) beam.term {
    c.cairo_clip(ctx.unpack().ptr);
    return checkContext(ctx);
}

pub fn reset_clip(ctx: ContextResource) beam.term {
    c.cairo_reset_clip(ctx.unpack().ptr);
    return checkContext(ctx);
}
