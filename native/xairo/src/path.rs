use crate::enums::PathSegment;
use rustler::ResourceArc;

pub struct Raw {
    pub path: cairo::Path,
}

unsafe impl Send for Raw {}
unsafe impl Sync for Raw {}

pub type Path = ResourceArc<Raw>;

#[rustler::nif]
fn path_iter(path: Path) -> Vec<PathSegment> {
    path.path
        .iter()
        .map(std::convert::Into::into)
        .collect::<Vec<PathSegment>>()
}
