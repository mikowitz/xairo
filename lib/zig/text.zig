const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const ContextResource = @import("context.zig").ContextResource;
const checkContext = @import("context.zig").checkContext;
const enums = @import("enums.zig");
const matrix = @import("matrix.zig");

const allocator = std.heap.c_allocator;

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

pub fn show_text(ctx: ContextResource, text: []const u8) !beam.term {
    const text_c = try allocator.dupeZ(u8, text);
    defer allocator.free(text_c);
    c.cairo_show_text(ctx.unpack().ptr, text_c);
    return checkContext(ctx);
}

pub fn text_path(ctx: ContextResource, text: []const u8) !beam.term {
    const text_c = try allocator.dupeZ(u8, text);
    defer allocator.free(text_c);
    c.cairo_text_path(ctx.unpack().ptr, text_c);
    return checkContext(ctx);
}

pub fn text_extents(ctx: ContextResource, text: []const u8) !beam.term {
    const text_c = try allocator.dupeZ(u8, text);
    defer allocator.free(text_c);
    var extents: c.cairo_text_extents_t = undefined;
    c.cairo_text_extents(ctx.unpack().ptr, text_c, &extents);
    return beam.make(.{
        .x_bearing = extents.x_bearing,
        .y_bearing = extents.y_bearing,
        .width = extents.width,
        .height = extents.height,
        .x_advance = extents.x_advance,
        .y_advance = extents.y_advance,
    }, .{});
}

pub fn font_extents(ctx: ContextResource) beam.term {
    var extents: c.cairo_font_extents_t = undefined;
    c.cairo_font_extents(ctx.unpack().ptr, &extents);
    return beam.make(.{
        .ascent = extents.ascent,
        .descent = extents.descent,
        .height = extents.height,
        .max_x_advance = extents.max_x_advance,
        .max_y_advance = extents.max_y_advance,
    }, .{});
}
