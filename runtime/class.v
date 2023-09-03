module runtime

// A type that represents an Objective-C class.
[noinit]
pub struct Class {
	class &C.objc_object [required] // the Objective-C Class object
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
