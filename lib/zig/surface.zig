const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const enums = @import("enums.zig");
const status = @import("status.zig");

const allocator = std.heap.c_allocator;

const SurfaceType = enum(c.cairo_surface_type_t) {
    image = c.CAIRO_SURFACE_TYPE_IMAGE,
    svg = c.CAIRO_SURFACE_TYPE_SVG,
};

const Format = enum(c.cairo_format_t) {
    invalid = c.CAIRO_FORMAT_INVALID,
    argb32 = c.CAIRO_FORMAT_ARGB32,
    rgb24,
    a8,
    a1,
    rgb16_565,
    rgb96f,
    rgba128f,
};

const Surface = struct { ptr: *c.cairo_surface_t, buffer: ?*std.ArrayList(u8) };

pub const SurfaceResourceCallbacks = struct {
    pub fn dtor(s: *Surface) void {
        c.cairo_surface_destroy(s.ptr);
        beam.allocator.destroy(s);
    }
};

pub const SurfaceResource = beam.Resource(Surface, root, .{ .Callbacks = SurfaceResourceCallbacks });

fn checkSurface(surface: SurfaceResource) beam.term {
    const raw = c.cairo_surface_status(surface.unpack().ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        return beam.make(.{ .@"error", status.atom(raw) }, .{});
    }
    return beam.make(surface, .{});
}

pub fn image_surface_create(format: Format, width: i32, height: i32) !beam.term {
    const ptr = c.cairo_image_surface_create(@intFromEnum(format), width, height).?;
    const raw = c.cairo_surface_status(ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        c.cairo_surface_destroy(ptr);
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    const resource = try SurfaceResource.create(.{ .ptr = ptr, .buffer = null }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

pub fn image_surface_create_from_png(filename: []const u8) !beam.term {
    const filename_c = try allocator.dupeZ(u8, filename);
    defer allocator.free(filename_c);
    const ptr = c.cairo_image_surface_create_from_png(filename_c).?;
    const raw = c.cairo_surface_status(ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        c.cairo_surface_destroy(ptr);
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    const resource = try SurfaceResource.create(.{ .ptr = ptr, .buffer = null }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

pub fn image_surface_get_width(surface: SurfaceResource) beam.term {
    return beam.make(c.cairo_image_surface_get_width(surface.unpack().ptr), .{});
}

pub fn image_surface_get_height(surface: SurfaceResource) beam.term {
    return beam.make(c.cairo_image_surface_get_height(surface.unpack().ptr), .{});
}

pub fn image_surface_get_format(surface: SurfaceResource) beam.term {
    const format = c.cairo_image_surface_get_format(surface.unpack().ptr);
    if (std.enums.fromInt(Format, format)) |found| {
        return beam.make(found, .{});
    }
    return beam.make(.{ .@"error", .unknown_status, format }, .{});
}

pub fn image_surface_get_stride(surface: SurfaceResource) beam.term {
    return beam.make(c.cairo_image_surface_get_stride(surface.unpack().ptr), .{});
}

pub fn surface_write_to_png(surface: SurfaceResource, filename: []const u8) !beam.term {
    const filename_c = try allocator.dupeZ(u8, filename);
    defer allocator.free(filename_c);
    const ptr = surface.unpack().ptr;
    const raw = c.cairo_surface_write_to_png(ptr, filename_c);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    return beam.make(.ok, .{});
}

fn writeToBuffer(closure: ?*anyopaque, data: [*c]const u8, length: c_uint) callconv(.c) c.cairo_status_t {
    const buffer: *std.ArrayList(u8) = @ptrCast(@alignCast(closure));
    buffer.appendSlice(allocator, data[0..length]) catch return c.CAIRO_STATUS_NO_MEMORY;
    return c.CAIRO_STATUS_SUCCESS;
}

pub fn surface_write_to_png_stream(surface: SurfaceResource) beam.term {
    const ptr = surface.unpack().ptr;
    var buffer: std.ArrayList(u8) = .empty;
    const raw = c.cairo_surface_write_to_png_stream(ptr, writeToBuffer, &buffer);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    return beam.make(.{ .ok, buffer.items }, .{});
}

pub fn get_type(surface: SurfaceResource) beam.term {
    const raw = c.cairo_surface_get_type(surface.unpack().ptr);
    if (std.enums.fromInt(enums.SurfaceType, raw)) |found| return beam.make(found, .{});
    return beam.make(.{ .@"error", .unknown_surface_type, raw }, .{});
}

pub fn flush(surface: SurfaceResource) beam.term {
    c.cairo_surface_flush(surface.unpack().ptr);
    return checkSurface(surface);
}

pub fn finish(surface: SurfaceResource) beam.term {
    c.cairo_surface_finish(surface.unpack().ptr);
    return checkSurface(surface);
}

pub fn svg_surface_create(filename: []const u8, width: f64, height: f64) !beam.term {
    const filename_z = try allocator.dupeZ(u8, filename);
    defer allocator.free(filename_z);
    const ptr = c.cairo_svg_surface_create(filename_z, width, height).?;
    const raw = c.cairo_surface_status(ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        c.cairo_surface_destroy(ptr);
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    const resource = try SurfaceResource.create(.{ .ptr = ptr, .buffer = null }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

pub fn svg_surface_create_for_stream(width: f64, height: f64) !beam.term {
    const buffer = try allocator.create(std.ArrayList(u8));
    buffer.* = .empty;
    const ptr = c.cairo_svg_surface_create_for_stream(writeToBuffer, buffer, width, height).?;
    const raw = c.cairo_surface_status(ptr);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        c.cairo_surface_destroy(ptr);
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    const resource = try SurfaceResource.create(.{ .ptr = ptr, .buffer = buffer }, .{});
    return beam.make(.{ .ok, resource }, .{});
}

pub fn svg_surface_to_binary(surface: SurfaceResource) beam.term {
    const buffer = surface.unpack().buffer orelse return beam.make(.{ .@"error", .not_in_memory }, .{});
    return beam.make(.{ .ok, buffer.items }, .{});
}
