module runtime

// A type that represents an Objective-C class.
[noinit]
pub struct Class {
	ptr &C.objc_object [required] // the Objective-C Class object
}

// Class.get returns the class definition of a specified class. It returns `none` if
// the class is not registered with the Objective-C runtime.
pub fn Class.get(name string) ?Class {
	unsafe {
		class := C.objc_getClass(&char(name.str))
		if class != nil {
			return Class{class}
		}
		return none
	}
}

// message creates a message with the class instance as the receiver and `op` as the method selector.
pub fn (c Class) message(op Sel) MsgBuilder {
	return MsgBuilder{c.ptr, op.ptr}
}
