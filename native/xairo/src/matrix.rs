use crate::{enums::error::Error, point::Point, vector::Vector};
use rustler::ResourceArc;

pub struct MatrixRaw {
    pub matrix: cairo::Matrix,
}

unsafe impl Send for MatrixRaw {}
unsafe impl Sync for MatrixRaw {}

pub type Matrix = ResourceArc<MatrixRaw>;

#[rustler::nif]
fn matrix_new(xx: f64, yx: f64, xy: f64, yy: f64, tx: f64, ty: f64) -> Matrix {
    ResourceArc::new(MatrixRaw {
        matrix: cairo::Matrix::new(xx, yx, xy, yy, tx, ty),
    })
}

#[rustler::nif]
fn matrix_identity() -> Matrix {
    ResourceArc::new(MatrixRaw {
        matrix: cairo::Matrix::identity(),
    })
}

#[rustler::nif]
fn matrix_transform_distance(matrix: Matrix, vector: Vector) -> Vector {
    let (x, y) = vector.to_tuple();
    let (x, y) = matrix.matrix.transform_distance(x, y);
    Vector { x, y }
}

#[rustler::nif]
fn matrix_transform_point(matrix: Matrix, point: Point) -> Point {
    let (x, y) = point.to_tuple();
    let (x, y) = matrix.matrix.transform_point(x, y);
    Point { x, y }
}

#[rustler::nif]
fn matrix_translate(matrix: Matrix, dx: f64, dy: f64) -> Matrix {
    let mut m = matrix.matrix;
    m.translate(dx, dy);
    ResourceArc::new(MatrixRaw { matrix: m })
}

#[rustler::nif]
fn matrix_scale(matrix: Matrix, dx: f64, dy: f64) -> Matrix {
    let mut m = matrix.matrix;
    m.scale(dx, dy);
    ResourceArc::new(MatrixRaw { matrix: m })
}

#[rustler::nif]
fn matrix_rotate(matrix: Matrix, radians: f64) -> Matrix {
    let mut m = matrix.matrix;
    m.rotate(radians);
    ResourceArc::new(MatrixRaw { matrix: m })
}

#[rustler::nif]
fn matrix_invert(matrix: Matrix) -> Result<Matrix, Error> {
    match matrix.matrix.try_invert() {
        Ok(matrix) => Ok(ResourceArc::new(MatrixRaw { matrix })),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn matrix_multiply(matrix1: Matrix, matrix2: Matrix) -> Matrix {
    ResourceArc::new(MatrixRaw {
        matrix: cairo::Matrix::multiply(&matrix1.matrix, &matrix2.matrix),
    })
}

#[rustler::nif]
fn matrix_to_tuple(matrix: Matrix) -> (f64, f64, f64, f64, f64, f64) {
    let matrix = matrix.matrix;
    (
        matrix.xx, matrix.yx, matrix.xy, matrix.yy, matrix.x0, matrix.y0,
    )
}
