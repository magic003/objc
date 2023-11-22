module objc

// A type that represents an instance variable in an Objective-C class.
@[noinit]
pub struct Ivar {
	ptr voidptr @[required]
}

// name returns the name of an instance variable.
pub fn (v Ivar) name() string {
	name := C.ivar_getName(v.ptr)
	unsafe {
		return name.vstring()
	}
}

// type_encoding returns the type string of an instance variable.
pub fn (v Ivar) type_encoding() string {
	te := C.ivar_getTypeEncoding(v.ptr)
	unsafe {
		return te.vstring()
	}
}

// offset returns the offset of an instance variable.
pub fn (v Ivar) offset() isize {
	return C.ivar_getOffset(v.ptr)
}
