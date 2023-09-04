module runtime

[noinit]
pub struct Id {
	ptr &C.objc_object [required]
}

pub fn (id Id) message(op Sel) MsgBuilder {
	return MsgBuilder{id.ptr, op.ptr}
}
