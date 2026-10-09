const std = @import("std");
const beam = @import("beam");
const root = @import("root");
const c = @import("cairo");
const status = @import("status.zig");

pub const Matrix = struct {
    xx: f64 = 1.0,
    yx: f64 = 0.0,
    xy: f64 = 0.0,
    yy: f64 = 1.0,
    x0: f64 = 0.0,
    y0: f64 = 0.0,

    pub fn to_cairo(self: Matrix) c.cairo_matrix_t {
        var matrix: c.cairo_matrix_t = undefined;
        c.cairo_matrix_init(&matrix, self.xx, self.yx, self.xy, self.yy, self.x0, self.y0);
        return matrix;
    }

    pub fn from_cairo(matrix: c.cairo_matrix_t) Matrix {
        return Matrix{
            .xx = matrix.xx,
            .yx = matrix.yx,
            .xy = matrix.xy,
            .yy = matrix.yy,
            .x0 = matrix.x0,
            .y0 = matrix.y0,
        };
    }
};

pub fn translate(matrix: Matrix, tx: f64, ty: f64) Matrix {
    var matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    c.cairo_matrix_translate(&matrix_c, tx, ty);
    return Matrix.from_cairo(matrix_c);
}

pub fn scale(matrix: Matrix, sx: f64, sy: f64) Matrix {
    var matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    c.cairo_matrix_scale(&matrix_c, sx, sy);
    return Matrix.from_cairo(matrix_c);
}

pub fn rotate(matrix: Matrix, theta: f64) Matrix {
    var matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    c.cairo_matrix_rotate(&matrix_c, theta);
    return Matrix.from_cairo(matrix_c);
}

pub fn invert(matrix: Matrix) beam.term {
    var matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    const raw = c.cairo_matrix_invert(&matrix_c);
    if (raw != c.CAIRO_STATUS_SUCCESS) {
        if (std.enums.fromInt(status.Status, raw)) |found| {
            return status.to_error(found);
        }
        return beam.make(.{ .@"error", .unknown_status, raw }, .{});
    }
    return beam.make(.{ .ok, Matrix.from_cairo(matrix_c) }, .{});
}

pub fn multiply(m: Matrix, n: Matrix) Matrix {
    var dest: c.cairo_matrix_t = undefined;
    const m_c: c.cairo_matrix_t = m.to_cairo();
    const n_c: c.cairo_matrix_t = n.to_cairo();
    c.cairo_matrix_multiply(&dest, &m_c, &n_c);
    return Matrix.from_cairo(dest);
}

pub fn transform_distance(matrix: Matrix, dx: f64, dy: f64) beam.term {
    const matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    var nx: f64 = dx;
    var ny: f64 = dy;
    c.cairo_matrix_transform_distance(&matrix_c, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}

pub fn transform_point(matrix: Matrix, x: f64, y: f64) beam.term {
    const matrix_c: c.cairo_matrix_t = matrix.to_cairo();
    var nx: f64 = x;
    var ny: f64 = y;
    c.cairo_matrix_transform_point(&matrix_c, &nx, &ny);
    return beam.make(.{ nx, ny }, .{});
}
