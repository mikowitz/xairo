use crate::enums::path_segment::PathSegment;
use rustler::ResourceArc;

pub struct PathRaw {
    pub path: cairo::Path,
}

unsafe impl Send for PathRaw {}
unsafe impl Sync for PathRaw {}

pub type Path = ResourceArc<PathRaw>;

#[rustler::nif]
fn path_iter(path: Path) -> Vec<PathSegment> {
    path.path
        .iter()
        .map(|ps| ps.into())
        .collect::<Vec<PathSegment>>()
}
