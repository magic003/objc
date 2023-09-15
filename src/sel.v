module objc

// A type that represents a method selector, `SEL`, in Objective-C.
[noinit]
pub struct Sel {
	ptr voidptr [required]
}

// Sel.get registers a method with the Objective-C runtime system, maps the method name to a
// selector, and returns the selector value.
//
// Example:
// ```v
// sel1 := Sel.get('new')
// sel2 := Sel.get('allocWithZone:')
// ```
pub fn Sel.get(name string) Sel {
	return Sel{C.sel_registerName(&char(name.str))}
}
