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

// set_ivar sets the value of an instance variable.
// Unsafe because the caller must ensure the ivar is actually of type `T`.
[unsafe]
pub fn (id Id) set_ivar[T](name string, value T) {
	ivar := id.class().instance_variable(name) or { panic('Ivar ${name} not found.') }
	if typeof[T]() == typeof[Id]() {
		C.object_setIvar(id, ivar.ptr, value)
	} else {
		unsafe {
			mut ptr := &u8(voidptr(id))
			println('${name} offset: ${ivar.offset()}')
			ptr = ptr + ivar.offset()
			*ptr = value
		}
	}
}

// set_ivar returns the value of an instance variable.
// Unsafe because the caller must ensure the ivar is actually of type `T`.
[unsafe]
pub fn (id Id) get_ivar[T](name string) T {
	ivar := id.class().instance_variable(name) or { panic('Ivar ${name} not found.') }
	if typeof[T]() == typeof[Id]() {
		return T(C.object_getIvar(id, ivar.ptr))
	}
	unsafe {
		mut ptr := &u8(voidptr(id))
		ptr = ptr + ivar.offset()
		return T(*ptr)
	}
}
