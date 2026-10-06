const std = @import("std");
const beam = @import("beam");
const c = @import("cairo");

pub const Status = enum(c.cairo_status_t) {
    success = c.CAIRO_STATUS_SUCCESS,
    invalid_size = c.CAIRO_STATUS_INVALID_SIZE,
    write_error = c.CAIRO_STATUS_WRITE_ERROR,
};

pub fn to_atom(status: Status) beam.term {
    return beam.make(status, .{});
}

pub fn to_error(status: Status) beam.term {
    if (status == .success) {
        return beam.make(.ok, .{});
    }
    return beam.make(.{ .@"error", status }, .{});
}
