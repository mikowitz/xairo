use crate::{enums::error::Error, path::Path, path::PathRaw, point::Point, rgba::Rgba};
use rustler::ResourceArc;

pub struct MeshRaw {
    pub mesh: cairo::Mesh,
}

unsafe impl Send for MeshRaw {}
unsafe impl Sync for MeshRaw {}

pub type Mesh = ResourceArc<MeshRaw>;

#[rustler::nif]
fn mesh_new() -> Mesh {
    ResourceArc::new(MeshRaw {
        mesh: cairo::Mesh::new(),
    })
}

#[rustler::nif]
fn mesh_patch_count(mesh: Mesh) -> Result<usize, Error> {
    match mesh.mesh.patch_count() {
        Ok(count) => Ok(count),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn mesh_begin_patch(mesh: Mesh) -> Result<(), Error> {
    mesh.mesh.begin_patch();
    match mesh.mesh.status() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn mesh_end_patch(mesh: Mesh) -> Result<(), Error> {
    mesh.mesh.end_patch();
    match mesh.mesh.status() {
        Ok(_) => Ok(()),
        Err(err) => Err(err.into()),
    }
}

#[rustler::nif]
fn mesh_move_to(mesh: Mesh, point: Point) {
    let (x, y) = point.to_tuple();
    mesh.mesh.move_to(x, y);
}

#[rustler::nif]
fn mesh_line_to(mesh: Mesh, point: Point) {
    let (x, y) = point.to_tuple();
    mesh.mesh.line_to(x, y);
}

#[rustler::nif]
fn mesh_curve_to(mesh: Mesh, point1: Point, point2: Point, point3: Point) {
    let (x1, y1) = point1.to_tuple();
    let (x2, y2) = point2.to_tuple();
    let (x3, y3) = point3.to_tuple();
    mesh.mesh.curve_to(x1, y1, x2, y2, x3, y3);
}

#[rustler::nif]
fn mesh_set_control_point(mesh: Mesh, corner: u8, point: Point) -> Result<(), Error> {
    match mesh_corner(corner) {
        Ok(corner) => {
            let (x, y) = point.to_tuple();
            mesh.mesh.set_control_point(corner, x, y);
            Ok(())
        }
        Err(err) => Err(err),
    }
}

#[rustler::nif]
fn mesh_control_point(mesh: Mesh, patch: usize, corner: u8) -> Result<Point, Error> {
    match mesh_corner(corner) {
        Ok(corner) => match mesh.mesh.control_point(patch, corner) {
            Ok((x, y)) => Ok(Point { x, y }),
            Err(err) => Err(err.into()),
        },
        Err(err) => Err(err),
    }
}

#[rustler::nif]
fn mesh_set_corner_color(mesh: Mesh, corner: u8, rgba: Rgba) -> Result<(), Error> {
    match mesh_corner(corner) {
        Ok(corner) => {
            let (r, g, b, a) = rgba.to_tuple();
            mesh.mesh.set_corner_color_rgba(corner, r, g, b, a);
            Ok(())
        }
        Err(err) => Err(err),
    }
}

#[rustler::nif]
fn mesh_corner_color_rgba(mesh: Mesh, patch: usize, corner: u8) -> Result<Rgba, Error> {
    match mesh_corner(corner) {
        Ok(corner) => match mesh.mesh.corner_color_rgba(patch, corner) {
            Ok((r, g, b, a)) => Ok(Rgba::new(r, g, b, a)),
            Err(err) => Err(err.into()),
        },
        Err(err) => Err(err),
    }
}

#[rustler::nif]
fn mesh_path(mesh: Mesh, patch: usize) -> Result<Path, Error> {
    match mesh.mesh.path(patch) {
        Ok(path) => Ok(ResourceArc::new(PathRaw { path })),
        Err(err) => Err(err.into()),
    }
}

fn mesh_corner(index: u8) -> Result<cairo::MeshCorner, Error> {
    match index {
        0 => Ok(cairo::MeshCorner::MeshCorner0),
        1 => Ok(cairo::MeshCorner::MeshCorner1),
        2 => Ok(cairo::MeshCorner::MeshCorner2),
        3 => Ok(cairo::MeshCorner::MeshCorner3),
        4_u8..=u8::MAX => Err(Error::InvalidIndex),
    }
}
