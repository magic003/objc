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

// return_type sets the return type of the message.
pub fn (b MsgBuilder) return_type[R]() Msg0[R] {
	return Msg0[R]{b.id, b.op}
}

// send sends the message without a return value.
pub fn (b MsgBuilder) send() {
	invoke0[&ObjStruct](b.id, b.op)
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
		id := invoke0[&ObjStruct](m.id, m.op)
		return Id{id}
	}
	return invoke0[R](m.id, m.op)
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
pub fn (m MsgArgs1[A]) send() {
	invoke1[&ObjStruct, A](m.id, m.op, m.a)
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
		id := invoke1[&ObjStruct, A](m.id, m.op, m.a)
		return Id{id}
	}
	return invoke1[R, A](m.id, m.op, m.a)
}

// The `&C.objc_object` cannot be used as a type in generics. Not sure if it is a
// V bug or I didn't use it correctly. Defining a type alias and using `&ObjStruct` works.
// This type should only be used for such workaround.
type ObjStruct = C.objc_object

type FN_SEND_MSG_0[R] = fn (&C.objc_object, &C.objc_selector) R

type FN_SEND_MSG_1[R, A] = fn (&C.objc_object, &C.objc_selector, A) R

type FN_SEND_MSG[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

type FN_SEND_MSG_RECT[A, R] = fn (&C.objc_object, &C.objc_selector, A) R

type FN_SEND_MSG_STRET[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

fn invoke0[R](id &C.objc_object, op &C.objc_selector) R {
	msg_send_fn := unsafe { FN_SEND_MSG_0[R](C.objc_msgSend) }
	return msg_send_fn[R](id, op)
}

fn invoke1[R, A](id &C.objc_object, op &C.objc_selector, arg1 A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_1[R, A](C.objc_msgSend) }
	return msg_send_fn[R, A](id, op, arg1)
}

pub fn (id Id) send_message_rect[A, R](op Sel, rect A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_RECT[A, R](C.objc_msgSend) }
	return msg_send_fn[A, R](id.ptr, op.ptr, rect)
}

pub fn (id Id) send_message_stret[R](op Sel, args ...voidptr) R {
	msg_send_fn := unsafe { FN_SEND_MSG_STRET[R](C.objc_msgSend_stret) }
	return msg_send_fn[R](id.ptr, op.ptr, ...args)
}
