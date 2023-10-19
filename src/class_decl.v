module objc

import math.bits

// A type used to declare a new class.
[noinit]
pub struct ClassDecl {
	cls voidptr [required] // the Objective-C Class object
}

// ClassDecl.new creates a new class. It returns `none` if the class could not be created (for example,
// the desired name is already in use).
pub fn ClassDecl.new(superclass Class, name string, extra_bytes usize) ?ClassDecl {
	unsafe {
		cls := C.objc_allocateClassPair(superclass.ptr, &char(name.str), extra_bytes)
		if cls != nil {
			return ClassDecl{cls}
		}
		return none
	}
}

// add_ivar adds a new instance variable of type `T` to a class.
pub fn (d ClassDecl) add_ivar[T](name string) bool {
	size := sizeof(T)
	// WARNING: this may not work in all circumstances. It's not the optimal solution either.
	// It assumes:
	//   * sizeof(T) >= alignOf(T)
	//   * sizeof(T) is always a power of 2
	// log2 of a power of 2 is the number of trailing zeros.
	log2_alignment := u8(bits.trailing_zeros_32(size))
	types := encode[T]() or { panic(err) }
	return C.class_addIvar(d.cls, &char(name.str), size, log2_alignment, &char(types.str().str))
}

// add_method adds a new method to a class.
pub fn (d ClassDecl) add_method(name Sel, method MethodImpl) bool {
	types := method.encodings().map(it.str()).join('')
	return C.class_addMethod(d.cls, name, method.imp, &char(types.str))
}

// register registers the class.
pub fn (d ClassDecl) register() Class {
	C.objc_registerClassPair(d.cls)
	return Class{d.cls}
}
