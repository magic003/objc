module objc

// A pointer to the start of a method implementation.
pub type Imp = fn (voidptr, voidptr) voidptr
