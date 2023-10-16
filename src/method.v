module objc

import encode as ec

// An interface of the method implementation which can be added to a class declaration.
pub interface MethodImpl {
	// imp returns the function implementation.
	imp() Imp
	// encodings returns the encodings of the method.
	encodings() []ec.Encoding
}

// void_method creates a `MethodImpl` which doesn't have an argument and return value.
pub fn void_method(imp fn (self Id, cmd Sel)) MethodImpl {
	return VoidMethod{imp}
}

struct VoidMethod {
	func fn (self Id, cmd Sel) [required]
}

[unsafe]
fn (m VoidMethod) imp() Imp {
	unsafe {
		return Imp(m.func)
	}
}

fn (m VoidMethod) encodings() []ec.Encoding {
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	return [ec.Encoding.void(), id_encoding, sel_encoding]
}
