module runtime

// A message builder.
[noinit]
struct MsgBuilder {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
}

// args1 adds 1 argument to the message.
pub fn (b MsgBuilder) args1[A](a A) MsgArgs1[A] {
	return MsgArgs1[A]{b.id, b.op, a}
}

// request sends a message requesting a value of type `R`.
pub fn (b MsgBuilder) request[R]() R {
	return send_msg_0[R](b.id, b.op)
}

// notify sends the message without a return value.
pub fn (b MsgBuilder) notify() {
	b.request[&ObjStruct]()
}

// A type that represents a message with 0 argument and return type of `R`.
[noinit]
struct Msg0[R] {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
}

// send sends the message with a return value of type `R`.
pub fn (m Msg0[R]) send() R {
	$if R is Id {
		id := send_msg_0[&ObjStruct](m.id, m.op)
		println('msg0 type is: ${typeof(id).name}')
		return Id{id}
	} $else {
		$if R is CGRect {
			$compile_warn('Msg0[R] send(): R is CGRect')
		}
		return send_msg_0[R](m.id, m.op)
	}
}

// A type that represents 1 argument in a message.
[noinit]
struct MsgArgs1[A] {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
	a  A                [required]
}

// return_type sets the return type of the message.
pub fn (m MsgArgs1[A]) return_type[R]() Msg1[R, A] {
	return Msg1[R, A]{m.id, m.op, m.a}
}

// send sends the message without a return value.
pub fn (m MsgArgs1[A]) send[R]() R {
	$if R is ID {
		$compile_warn('MsgArgs1 send[R] is ID')
	}
	return send_msg_1[R, A](m.id, m.op, m.a)
}

// A type that represents a message with 1 argument of `A` and return type of `R`.
[noinit]
struct Msg1[R, A] {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
	a  A                [required]
}

// send sends the message with a return value of type `R`.
pub fn (m Msg1[R, A]) send() R {
	$if R is Id {
		/*
		id := send_msg_0[&ObjStruct](m.id, m.op)
		println('msg1 type is: ${typeof(id).name}')
		return Id{id}*/
		i1 := Invoke1[A, &ObjStruct]{
			id: m.id
			op: m.op
			a: m.a
		}
		return Id{i1.invoke()}
	} $else {
		$compile_warn('msg1 send in else')
		// return send_msg_0[R](m.id, m.op)
		return new_invoke1[A, R](m.id, m.op, m.a).invoke()
	}
}

// The `&C.objc_object` cannot be used as a type in generics. Not sure if it is a
// V bug or I didn't use it correctly. Defining a type alias and using `&ObjStruct` works.
// This type should only be used for such workaround.
type ObjStruct = C.objc_object

// It represents the generic signature of objc_msgSend and objc_msgSend_stret functions.
type FnSendMsgGeneric = fn ()

type FN_SEND_MSG_0[R] = fn (&C.objc_object, &C.objc_selector) R

type FN_SEND_MSG_1[R, A] = fn (&C.objc_object, &C.objc_selector, A) R

type FN_SEND_MSG[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

// type FN_SEND_MSG_RECT[A, R] = fn (&C.objc_object, &C.objc_selector, A) R

// type FN_SEND_MSG_STRET[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

fn send_msg_0[R](id &C.objc_object, op &C.objc_selector) R {
	$if R is Id {
		$compile_warn('send_msg_0: is Id')
	} $else $if R is ID {
		$compile_warn('send_msg_0: is ID')
	} $else $if R is CGRect {
		$compile_warn('send_msg_0[R] is CGRect')
	}
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FN_SEND_MSG_0[R](msg_send_fn) }
	return casted_fn[R](id, op)
}

fn new_invoke1[A, T](id &C.objc_object, op &C.objc_selector, a A) Invoke1[A, T] {
	$if T is ID {
		$compile_warn('new_invoke got type ID')
	} $else {
		$compile_warn('new_invoke got unknown type')
	}
	return Invoke1[A, T]{
		id: id
		op: op
		a: a
	}
}

struct Invoke1[A, T] {
	id &C.objc_object
	op &C.objc_selector
	a  A
}

fn (i Invoke1[A, T]) invoke() T {
	$if T is &ObjStruct {
		$compile_warn('invoke return &ObjStruct')
	} $else $if T is ID {
		$compile_warn('invoke return ID')
	}
	msg_send_fn := i.get_msg_send_fn()
	casted_fn := unsafe { FN_SEND_MSG_1[T](msg_send_fn) }
	return casted_fn[A, T](i.id, i.op, i.a)
}

fn (i Invoke1[A, T]) get_msg_send_fn() FnSendMsgGeneric {
	$if T is ID {
		$compile_warn('get_msg_send_fn got type ID')
	} $else $if T is CGRect {
		$compile_warn('get_msg_send_fn got type CGRect')
	} $else {
		$compile_warn('get_msg_send_fn got unknown type')
	}
	// WARNING: this is a very naive way to decide calling objc_msgSend or objc_msgSend_stret.
	// If the size of the return type is less or equal than the C pointer size, it assumes the value
	// can be saved in registers and hence the objc_msgSend is used. Otherwise, objc_msgSend_stret
	// is used. It is only tested on x86_64 and may not work on other architecture.
	ptr_size := sizeof(voidptr)
	if sizeof(T) <= ptr_size {
		$if T is CGRect {
			println('use C.objc_msgSend for CGRect, sizeof: ${sizeof(T)}')
		}
		return C.objc_msgSend
	} else {
		$if T is CGRect {
			println('use C.objc_msgSend_stret for CGRect')
		}
		return C.objc_msgSend_stret
	}
}

fn send_msg_1[R, A](id &C.objc_object, op &C.objc_selector, a A) R {
	$if R is ID {
		$compile_warn('send_msg_1[T] is ID')
	}
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FN_SEND_MSG_1[R, A](msg_send_fn) }
	/*$if casted_fn is FN_SEND_MSG_1[CGRect, ID] {
		$compile_warn('type is correct')
	} $else {
		$compile_warn('type is incorrect')
	}
	$if T is Id {
		$compile_warn('send_msg_1: is Id')
	} $else $if T is &ObjStruct {
		$compile_warn('send_msg_1: is &OjbStruct')
	}*/
	return casted_fn[R, A](id, op, a)
}

fn get_msg_send_fn[R]() FnSendMsgGeneric {
	$if R is ID {
		$compile_warn('get_msg_send_fn got type ID')
	} $else {
		$compile_warn('get_msg_send_fn got unknown type')
	}
	// WARNING: this is a very naive way to decide calling objc_msgSend or objc_msgSend_stret.
	// If the size of the return type is less or equal than the C pointer size, it assumes the value
	// can be saved in registers and hence the objc_msgSend is used. Otherwise, objc_msgSend_stret
	// is used. It is only tested on x86_64 and may not work on other architecture.
	ptr_size := sizeof(voidptr)
	if sizeof(R) <= ptr_size {
		return C.objc_msgSend
	} else {
		$if R is CGRect {
			println('use C.objc_msgSend_stret for CGRect')
		}
		return C.objc_msgSend_stret
	}
}

/*
pub fn (id Id) send_message_rect[A, R](op Sel, rect A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_RECT[A, R](C.objc_msgSend) }
	return msg_send_fn[A, R](id.ptr, op.ptr, rect)
}

pub fn (id Id) send_message_stret[R](op Sel, args ...voidptr) R {
	msg_send_fn := unsafe { FN_SEND_MSG_STRET[R](C.objc_msgSend_stret) }
	return msg_send_fn[R](id.ptr, op.ptr, ...args)
}*/
