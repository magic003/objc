module objc

// A type that represents an Objective-C class.
[noinit]
pub struct Class {
	ptr voidptr [required] // the Objective-C Class object
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
	return MsgBuilder{Id(c.ptr), op}
}

// instance_variable returns the `Ivar` for a specified instance variable of a given class.
pub fn (c Class) instance_variable(name string) Ivar {
	ivar := C.class_getInstanceVariable(c.ptr, &char(name.str))
	return Ivar{
		ptr: ivar
	}
}
