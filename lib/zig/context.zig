const std = @import("std");
const beam = @import("beam");
const e = @import("erl_nif");
const root = @import("root");
const c = @import("cairo");
const status = @import("status.zig");
const surface = @import("surface.zig");
const enums = @import("enums.zig");

const allocator = std.heap.c_allocator;

const Context = struct {
    ptr: *c.cairo_t,
    target: surface.SurfaceResource,
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
    const resource = try ContextResource.create(.{ .ptr = ptr, .target = s }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

pub fn checkContext(ctx: ContextResource) beam.term {
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

pub fn get_operator(ctx: ContextResource) beam.term {
    const raw = c.cairo_get_operator(ctx.unpack().ptr);
    if (std.enums.fromInt(enums.Operator, raw)) |found| return beam.make(found, .{});
    unreachable;
}

pub fn set_operator(ctx: ContextResource, operator: beam.term) !beam.term {
    var buf: [256]u8 = undefined;
    const len: usize = @intCast(e.enif_get_atom(beam.context.env, operator.v, &buf, buf.len, e.ERL_NIF_LATIN1));
    if (len == 0) return error.badarg;
    const operator_e = std.meta.stringToEnum(enums.Operator, buf[0 .. len - 1]) orelse return error.badarg;
    c.cairo_set_operator(ctx.unpack().ptr, @intFromEnum(operator_e));
    return checkContext(ctx);
}

pub fn get_antialias(ctx: ContextResource) beam.term {
    const raw = c.cairo_get_antialias(ctx.unpack().ptr);
    if (std.enums.fromInt(enums.Antialias, raw)) |found| return beam.make(found, .{});
    unreachable;
}

pub fn set_antialias(ctx: ContextResource, antialias: enums.Antialias) beam.term {
    c.cairo_set_antialias(ctx.unpack().ptr, @intFromEnum(antialias));
    return checkContext(ctx);
}

pub fn get_fill_rule(ctx: ContextResource) beam.term {
    const raw = c.cairo_get_fill_rule(ctx.unpack().ptr);
    if (std.enums.fromInt(enums.FillRule, raw)) |found| return beam.make(found, .{});
    unreachable;
}

pub fn set_fill_rule(ctx: ContextResource, fill_rule: enums.FillRule) beam.term {
    c.cairo_set_fill_rule(ctx.unpack().ptr, @intFromEnum(fill_rule));
    return checkContext(ctx);
}

pub fn get_miter_limit(ctx: ContextResource) f64 {
    return c.cairo_get_miter_limit(ctx.unpack().ptr);
}

pub fn set_miter_limit(ctx: ContextResource, width: f64) beam.term {
    c.cairo_set_miter_limit(ctx.unpack().ptr, width);
    return checkContext(ctx);
}

pub fn get_tolerance(ctx: ContextResource) f64 {
    return c.cairo_get_tolerance(ctx.unpack().ptr);
}

pub fn set_tolerance(ctx: ContextResource, width: f64) beam.term {
    c.cairo_set_tolerance(ctx.unpack().ptr, width);
    return checkContext(ctx);
}

pub fn get_line_width(ctx: ContextResource) f64 {
    return c.cairo_get_line_width(ctx.unpack().ptr);
}

pub fn set_line_width(ctx: ContextResource, width: f64) beam.term {
    c.cairo_set_line_width(ctx.unpack().ptr, width);
    return checkContext(ctx);
}

pub fn get_line_cap(ctx: ContextResource) beam.term {
    const raw = c.cairo_get_line_cap(ctx.unpack().ptr);
    if (std.enums.fromInt(enums.LineCap, raw)) |found| return beam.make(found, .{});
    unreachable;
}

pub fn set_line_cap(ctx: ContextResource, line_cap: enums.LineCap) beam.term {
    c.cairo_set_line_cap(ctx.unpack().ptr, @intFromEnum(line_cap));
    return checkContext(ctx);
}

pub fn get_line_join(ctx: ContextResource) beam.term {
    const raw = c.cairo_get_line_join(ctx.unpack().ptr);
    if (std.enums.fromInt(enums.LineJoin, raw)) |found| return beam.make(found, .{});
    unreachable;
}

pub fn set_line_join(ctx: ContextResource, line_join: enums.LineJoin) beam.term {
    c.cairo_set_line_join(ctx.unpack().ptr, @intFromEnum(line_join));
    return checkContext(ctx);
}

pub fn get_dash(ctx: ContextResource) !beam.term {
    const count = c.cairo_get_dash_count(ctx.unpack().ptr);
    const dashes = try allocator.alloc(f64, @intCast(count));
    var offset: f64 = 0.0;
    c.cairo_get_dash(ctx.unpack().ptr, dashes.ptr, &offset);
    return beam.make(.{ dashes, offset }, .{});
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

pub fn translate(ctx: ContextResource, tx: f64, ty: f64) beam.term {
    c.cairo_translate(ctx.unpack().ptr, tx, ty);
    return checkContext(ctx);
}

pub fn rotate(ctx: ContextResource, angle: f64) beam.term {
    c.cairo_rotate(ctx.unpack().ptr, angle);
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

pub fn get_target(ctx: ContextResource) beam.term {
    return beam.make(.{ .ok, ctx.unpack().target }, .{});
}
