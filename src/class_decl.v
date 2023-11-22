module objc

import math.bits

// A type used to declare a new class.
@[noinit]
pub struct ClassDecl {
	cls voidptr @[required] // the Objective-C Class object
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
	// WARNING: this is not the optimal solution. It uses the pointer size as the alignment for all types.
	// For type whose size is smaller, it may take more memory unnecessarily.
	min_alignment := sizeof(voidptr)
	// log2 of a power of 2 is the number of trailing zeros.
	log2_alignment := u8(bits.trailing_zeros_32(min_alignment))
	types := encode[T]() or { panic(err) }
	return C.class_addIvar(d.cls, &char(name.str), size, log2_alignment, &char(types.str().str))
}

// add_method adds a new method to a class.
// Unsafe because the caller must ensure the method type matches that is expected by Objective-C.
@[unsafe]
pub fn (d ClassDecl) add_method(name Sel, method MethodImpl) bool {
	types := method.encodings().map(it.str()).join('')
	return C.class_addMethod(d.cls, name, method.imp, &char(types.str))
}

// register registers the class.
pub fn (d ClassDecl) register() Class {
	C.objc_registerClassPair(d.cls)
	return Class{d.cls}
}
