module runtime

// A type that represents an Objective-C class.
[noinit]
pub struct Class {
	class &Id [required] // the Objective-C Class object
}

pub fn Class.get(name string) ?Class {
	unsafe {
		class := C.objc_getClass(&char(name.str))
		if class != nil {
			return Class{class}
		}
		return none
	}
}
