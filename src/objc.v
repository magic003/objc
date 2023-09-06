module objc

// class returns the class definition of a specified class. It returns `none` if
// the class is not registered with the Objective-C runtime.
pub fn class(name string) ?Class {
	return Class.get(name)
}
