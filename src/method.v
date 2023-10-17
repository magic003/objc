module objc

import encode as ec

// An interface of the method implementation which can be added to a class declaration.
pub interface MethodImpl {
	// the function implementation.
	imp Imp
	// encodings returns the encodings of the method.
	encodings() []ec.Encoding
}

// void_method_0 creates a `MethodImpl` which doesn't have an argument and return value.
pub fn void_method_0(imp fn (self Id, cmd Sel)) MethodImpl {
	unsafe {
		return VoidMethod0{Imp(imp)}
	}
}

[noinit]
struct VoidMethod0 {
	imp Imp [required]
}

fn (m VoidMethod0) encodings() []ec.Encoding {
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	return [ec.Encoding.void(), id_encoding, sel_encoding]
}

// method_0 creates a `MethodImpl` which returns a value and doesn't have an argument.
pub fn method_0[R](imp fn (self Id, cmd Sel) R) MethodImpl {
	unsafe {
		return Method0[R]{Imp(imp)}
	}
}

[noinit]
struct Method0[R] {
	imp Imp [required]
}

fn (m Method0[R]) encodings() []ec.Encoding {
	ret_encoding := encode[R]() or { panic(err) }
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	return [ret_encoding, id_encoding, sel_encoding]
}

// void_method_1 creates a `MethodImpl` which has one argument and no return value.
pub fn void_method_1[A](imp fn (self Id, cmd Sel, a A)) MethodImpl {
	unsafe {
		return VoidMethod1[A]{Imp(imp)}
	}
}

[noinit]
struct VoidMethod1[A] {
	imp Imp [required]
}

fn (m VoidMethod1[A]) encodings() []ec.Encoding {
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	return [ec.Encoding.void(), id_encoding, sel_encoding, a_encoding]
}

// method_1 creates a `MethodImpl` which has one argument and returns a value.
pub fn method_1[R, A](imp fn (self Id, cmd Sel, a A) R) MethodImpl {
	unsafe {
		return Method1[R, A]{Imp(imp)}
	}
}

[noinit]
struct Method1[R, A] {
	imp Imp [required]
}

fn (m Method1[R, A]) encodings() []ec.Encoding {
	ret_encoding := encode[R]() or { panic(err) }
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	return [ret_encoding, id_encoding, sel_encoding, a_encoding]
}

// void_method_2 creates a `MethodImpl` which has two arguments and no return value.
pub fn void_method_2[A, B](imp fn (self Id, cmd Sel, a A, b B)) MethodImpl {
	unsafe {
		return VoidMethod2[A, B]{Imp(imp)}
	}
}

[noinit]
struct VoidMethod2[A, B] {
	imp Imp [required]
}

fn (m VoidMethod2[A, B]) encodings() []ec.Encoding {
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	b_encoding := encode[B]() or { panic(err) }
	return [ec.Encoding.void(), id_encoding, sel_encoding, a_encoding, b_encoding]
}

// method_2 creates a `MethodImpl` which has two arguments and returns a value.
pub fn method_2[R, A, B](imp fn (self Id, cmd Sel, a A, b B) R) MethodImpl {
	unsafe {
		return Method2[R, A, B]{Imp(imp)}
	}
}

[noinit]
struct Method2[R, A, B] {
	imp Imp [required]
}

fn (m Method2[R, A, B]) encodings() []ec.Encoding {
	ret_encoding := encode[R]() or { panic(err) }
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	b_encoding := encode[B]() or { panic(err) }
	return [ret_encoding, id_encoding, sel_encoding, a_encoding, b_encoding]
}

// void_method_3 creates a `MethodImpl` which has three arguments and no return value.
pub fn void_method_3[A, B, D](imp fn (self Id, cmd Sel, a A, b B, d D)) MethodImpl {
	unsafe {
		return VoidMethod3[A, B, D]{Imp(imp)}
	}
}

[noinit]
struct VoidMethod3[A, B, D] {
	imp Imp [required]
}

fn (m VoidMethod3[A, B, D]) encodings() []ec.Encoding {
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	b_encoding := encode[B]() or { panic(err) }
	d_encoding := encode[D]() or { panic(err) }
	return [ec.Encoding.void(), id_encoding, sel_encoding, a_encoding, b_encoding, d_encoding]
}

// method_3 creates a `MethodImpl` which has three arguments and returns a value.
pub fn method_3[R, A, B, D](imp fn (self Id, cmd Sel, a A, b B, d D) R) MethodImpl {
	unsafe {
		return Method3[R, A, B, D]{Imp(imp)}
	}
}

[noinit]
struct Method3[R, A, B, D] {
	imp Imp [required]
}

fn (m Method3[R, A, B, D]) encodings() []ec.Encoding {
	ret_encoding := encode[R]() or { panic(err) }
	id_encoding := encode[Id]() or { panic(err) }
	sel_encoding := encode[Sel]() or { panic(err) }
	a_encoding := encode[A]() or { panic(err) }
	b_encoding := encode[B]() or { panic(err) }
	d_encoding := encode[D]() or { panic(err) }
	return [ret_encoding, id_encoding, sel_encoding, a_encoding, b_encoding, d_encoding]
}
