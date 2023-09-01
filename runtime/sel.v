module runtime

[noinit]
pub struct Sel {
	sel &C.objc_selector [required]
}

pub fn Sel.get(name string) Sel {
	return Sel{C.sel_registerName(&char(name.str))}
}
