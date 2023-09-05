module runtime

// A message builder.
[noinit]
struct MsgBuilder {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
}

// args1 adds 1 argument to the message.
pub fn (m MsgBuilder) args1[A](a A) Msg1[A] {
	return Msg1[A]{m.id, m.op, a}
}

// args2 adds 2 arguments to the message.
pub fn (m MsgBuilder) args2[A, B](a A, b B) Msg2[A, B] {
	return Msg2[A, B]{m.id, m.op, a, b}
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
	id &C.objc_object   [required]
	op &C.objc_selector [required]
	a  A                [required]
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
	id &C.objc_object   [required]
	op &C.objc_selector [required]
	a  A                [required]
	b  B                [required]
}

// request sends a message requesting for a value of type `R`.
pub fn (m Msg2[A, B]) request[R]() R {
	return send_msg_2[R, A, B](m.id, m.op, m.a, m.b)
}

// notify sends a message without a return value.
pub fn (m Msg2[A, B]) notify() {
	send_msg_2[Id, A, B](m.id, m.op, m.a, m.b)
}

// It represents the generic signature of objc_msgSend and objc_msgSend_stret functions.
type FnSendMsgGeneric = fn ()

// Cast objc_msgSend* functions to this function for 0 argument and return type `R`.
type FnSendMsg0[R] = fn (&C.objc_object, &C.objc_selector) R

// Cast objc_msgSend* functions to this function for 1 argument and return type `R`.
type FnSendMsg1[R, A] = fn (&C.objc_object, &C.objc_selector, A) R

// Cast objc_msgSend* functions to this function for 2 arguments and return type `R`.
type FnSendMsg2[R, A, B] = fn (&C.objc_object, &C.objc_selector, A, B) R

// send_msg_0 calls objc_msgSend* function for 0 argument and return type `R`.
fn send_msg_0[R](id &C.objc_object, op &C.objc_selector) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg0[R](msg_send_fn) }
	return casted_fn[R](id, op)
}

// send_msg_1 calls objc_msgSend* function for 1 argument and return type `R`.
fn send_msg_1[R, A](id &C.objc_object, op &C.objc_selector, a A) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg1[R, A](msg_send_fn) }
	return casted_fn[R, A](id, op, a)
}

// send_msg_2 calls objc_msgSend* function for 2 arguments and return type `R`.
fn send_msg_2[R, A, B](id &C.objc_object, op &C.objc_selector, a A, b B) R {
	msg_send_fn := get_msg_send_fn[R]()
	casted_fn := unsafe { FnSendMsg2[R, A, B](msg_send_fn) }
	return casted_fn[R, A, B](id, op, a, b)
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
