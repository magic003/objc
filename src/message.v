module objc

// A message builder.
[noinit]
struct MsgBuilder {
	id Id  [required]
	op Sel [required]
}

// args1 adds 1 argument to the message.
pub fn (m MsgBuilder) args1[A](a A) Msg1[A] {
	return Msg1[A]{m.id, m.op, a}
}

// args2 adds 2 arguments to the message.
pub fn (m MsgBuilder) args2[A, B](a A, b B) Msg2[A, B] {
	return Msg2[A, B]{m.id, m.op, a, b}
}

// args3 adds 3 arguments to the message.
pub fn (m MsgBuilder) args3[A, B, D](a A, b B, d D) Msg3[A, B, D] {
	return Msg3[A, B, D]{m.id, m.op, a, b, d}
}

// args4 adds 4 arguments to the message.
pub fn (m MsgBuilder) args4[A, B, D, E](a A, b B, d D, e E) Msg4[A, B, D, E] {
	return Msg4[A, B, D, E]{m.id, m.op, a, b, d, e}
}

// request sends a message requesting a value of type `R`.
pub fn (m MsgBuilder) request[R]() R {
	return send_msg_0[R](m.id, m.op)
}

// notify sends a message without a return value.
pub fn (m MsgBuilder) notify() {
	send_msg_0[Id](m.id, m.op)
}

// A type that represents a message having 1 argument.
[noinit]
struct Msg1[A] {
	id Id  [required]
	op Sel [required]
	a  A   [required]
}

// request sends a message requesting for a value of type `R`.
pub fn (m Msg1[A]) request[R]() R {
	return send_msg_1[R, A](m.id, m.op, m.a)
}

// notify sends a message without a return value.
pub fn (m Msg1[A]) notify() {
	send_msg_1[Id, A](m.id, m.op, m.a)
}

// A type that represents a message having 2 arguments.
[noinit]
struct Msg2[A, B] {
	id Id  [required]
	op Sel [required]
	a  A   [required]
	b  B   [required]
}

// request sends a message requesting for a value of type `R`.
pub fn (m Msg2[A, B]) request[R]() R {
	return send_msg_2[R, A, B](m.id, m.op, m.a, m.b)
}

// notify sends a message without a return value.
pub fn (m Msg2[A, B]) notify() {
	send_msg_2[Id, A, B](m.id, m.op, m.a, m.b)
}

// A type that represents a message having 3 arguments.
[noinit]
struct Msg3[A, B, D] {
	id Id  [required]
	op Sel [required]
	a  A   [required]
	b  B   [required]
	d  D   [required]
}

// request sends a message requesting for a value of type `R`.
pub fn (m Msg3[A, B, D]) request[R]() R {
	return send_msg_3[R, A, B, D](m.id, m.op, m.a, m.b, m.d)
}

// notify sends a message without a return value.
pub fn (m Msg3[A, B, D]) notify() {
	send_msg_3[Id, A, B, D](m.id, m.op, m.a, m.b, m.d)
}

// A type that represents a message having 4 arguments.
[noinit]
struct Msg4[A, B, D, E] {
	id Id  [required]
	op Sel [required]
	a  A   [required]
	b  B   [required]
	d  D   [required]
	e  E   [required]
}

// request sends a message requesting for a value of type `R`.
pub fn (m Msg4[A, B, D, E]) request[R]() R {
	return send_msg_4[R, A, B, D, E](m.id, m.op, m.a, m.b, m.d, m.e)
}

// notify sends a message without a return value.
pub fn (m Msg4[A, B, D, E]) notify() {
	send_msg_4[Id, A, B, D, E](m.id, m.op, m.a, m.b, m.d, m.e)
}

// It represents the generic signature of objc_msgSend and objc_msgSend_stret functions.
type FnSendMsgGeneric = fn ()

// Cast objc_msgSend* functions to this function for 0 argument and return type `R`.
type FnSendMsg0[R] = fn (voidptr, voidptr) R

// Cast objc_msgSend* functions to this function for 1 argument and return type `R`.
type FnSendMsg1[R, A] = fn (voidptr, voidptr, A) R

// Cast objc_msgSend* functions to this function for 2 arguments and return type `R`.
type FnSendMsg2[R, A, B] = fn (voidptr, voidptr, A, B) R

// Cast objc_msgSend* functions to this function for 3 arguments and return type `R`.
type FnSendMsg3[R, A, B, D] = fn (voidptr, voidptr, A, B, D) R

// Cast objc_msgSend* functions to this function for 4 arguments and return type `R`.
type FnSendMsg4[R, A, B, D, E] = fn (voidptr, voidptr, A, B, D, E) R

// send_msg_0 calls objc_msgSend* function for 0 argument and return type `R`.
fn send_msg_0[R](id Id, op Sel) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg0[R](msg_send_fn) }
	return casted_fn[R](id, op.ptr)
}

// send_msg_1 calls objc_msgSend* function for 1 argument and return type `R`.
fn send_msg_1[R, A](id Id, op Sel, a A) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg1[R, A](msg_send_fn) }
	return casted_fn[R, A](id, op.ptr, a)
}

// send_msg_2 calls objc_msgSend* function for 2 arguments and return type `R`.
fn send_msg_2[R, A, B](id Id, op Sel, a A, b B) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg2[R, A, B](msg_send_fn) }
	return casted_fn[R, A, B](id, op.ptr, a, b)
}

// send_msg_3 calls objc_msgSend* function for 3 arguments and return type `R`.
fn send_msg_3[R, A, B, D](id Id, op Sel, a A, b B, d D) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg3[R, A, B, D](msg_send_fn) }
	return casted_fn[R, A, B, D](id, op.ptr, a, b, d)
}

// send_msg_4 calls objc_msgSend* function for 4 arguments and return type `R`.
fn send_msg_4[R, A, B, D, E](id Id, op Sel, a A, b B, d D, e E) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg4[R, A, B, D, E](msg_send_fn) }
	return casted_fn[R, A, B, D, E](id, op.ptr, a, b, d, e)
}

// get_msg_send_fn determines which objc_msgSend* function to call based on `R`.
fn get_msg_send_fn[R]() FnSendMsgGeneric {
	// WARNING: this is a very naive way to decide calling objc_msgSend or objc_msgSend_stret.
	// If the size of the return type is less or equal than the C pointer size, it assumes the value
	// can be saved in registers and hence the objc_msgSend is used. Otherwise, objc_msgSend_stret
	// is used. It is only tested on x86_64 and may not work on other architecture.
	ptr_size := sizeof(voidptr)
	if sizeof(R) <= ptr_size {
		return C.objc_msgSend
	} else {
		return C.objc_msgSend_stret
	}
}
