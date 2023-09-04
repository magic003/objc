module runtime

[noinit]
pub struct Id {
	ptr &C.objc_object [required]
}

pub fn (id Id) message(op Sel) MsgBuilder {
	return MsgBuilder{id.ptr, op.ptr}
}

type ID = voidptr

pub fn (id ID) message(op Sel) MsgBuilder {
	unsafe {
		return MsgBuilder{&C.objc_object(id), op.ptr}
	}
}
