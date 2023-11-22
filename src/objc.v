module objc

// class returns the class definition of a specified class. It returns `none` if
// the class is not registered with the Objective-C runtime.
//
// Example:
// ```v
// cls := class('NSObject') or { panic('failed to load class NSObject') }
// ```
@[inline]
pub fn class(name string) ?Class {
	return Class.get(name)
}

// sel registers a method with the Objective-C runtime system, maps the method name to a
// selector, and returns the selector value.
//
// Example:
// ```v
// sel1 := sel('new')
// sel2 := sel('allocWithZone:')
// ```
@[inline]
pub fn sel(name string) Sel {
	return Sel.get(name)
}
