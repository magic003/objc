module objc

// A pointer to an instance of a class. It represents the `id` type in Objective-C.
type Id = voidptr

// message creates a message with the `id` as the receiver and `op` as the method selector.
pub fn (id Id) message(op Sel) MsgBuilder {
	unsafe {
		return MsgBuilder{id, op}
	}
}

// class returns the class of this instance.
pub fn (id Id) class() Class {
	cls := C.object_getClass(id)
	return Class{
		ptr: cls
	}
}

pub fn (id Id) set_ivar[T](name string, value T) {
}
