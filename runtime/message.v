module runtime

// A message builder.
[noinit]
struct MsgBuilder {
	id &C.objc_object   [required]
	op &C.objc_selector [required]
}

// args1 adds 1 argument to the message.
pub fn (b MsgBuilder) args1[A](a A) Msg1[A] {
	return Msg1[A]{b.id, b.op, a}
}

// request sends a message requesting a value of type `R`.
pub fn (b MsgBuilder) request[R]() R {
	return send_msg_0[R](b.id, b.op)
}

// notify sends a message without a return value.
pub fn (b MsgBuilder) notify() {
	send_msg_0[Id](b.id, b.op)
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

// It represents the generic signature of objc_msgSend and objc_msgSend_stret functions.
type FnSendMsgGeneric = fn ()

// Cast objc_msgSend* functions to this function for 0 argument and return type `R`.
type FnSendMsg0[R] = fn (&C.objc_object, &C.objc_selector) R

// Cast objc_msgSend* functions to this function for 1 argument and return type `R`.
type FnSendMsg1[R, A] = fn (&C.objc_object, &C.objc_selector, A) R

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
