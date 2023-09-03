module runtime

[noinit]
pub struct Id {
	ptr &C.objc_object [required]
}

type FN_SEND_MSG_0[R] = fn (&C.objc_object, &C.objc_selector) R

type FN_SEND_MSG_1[R, A] = fn (&C.objc_object, &C.objc_selector, A) R

type FN_SEND_MSG[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

type FN_SEND_MSG_RECT[A, R] = fn (&C.objc_object, &C.objc_selector, A) R

type FN_SEND_MSG_STRET[R] = fn (&C.objc_object, &C.objc_selector, ...voidptr) R

pub interface Invokable[R] {
	invoke(id Id, op Sel) R
}

pub struct Args0[R] {}

pub fn (a Args0[R]) invoke(id Id, op Sel) R {
	return invoke0[R](id, op)
}

pub struct Args1[R, A] {
	arg1 A
}

pub fn (a Args1[R, A]) invoke(id Id, op Sel) R {
	return invoke1[R, A](id, op, a.arg1)
}

pub fn (id Id) send_message[R](op Sel, args Invokable[R]) R {
	return args.invoke(id, op)
	/*$if args is Invokable[R] {
		return args.invoke[R](id, op)
		// return invoke1[R, T](id, op, args.arg1)
	} $else $if args is Args0 {
		return invoke0[R](id, op)
	} $else {
		$compile_error('args is not supported')
	}*/
}

[noinit]
struct MessageBuilder {
	id Id  [required]
	op Sel [required]
}

[noinit]
struct Message0[R] {
	id Id  [required]
	op Sel [required]
}

pub fn (m Message0[R]) send() R {
	return invoke0[R](m.id, m.op)
}

pub fn (b MessageBuilder) add_1_arg[A](arg1 A) MessageArg1[A] {
	return MessageArg1[A]{b.id, b.op, arg1}
}

pub fn (b MessageBuilder) return_type[R]() Message0[R] {
	return Message0[R]{b.id, b.op}
}

type ObjPtr = C.objc_object

pub fn (b MessageBuilder) send() Id {
	id := invoke0[&ObjPtr](b.id, b.op)
	return Id{id}
}

[noinit]
struct MessageArg1[A] {
	id Id  [required]
	op Sel [required]
	a  A
}

pub fn (a1 MessageArg1[A]) send[R]() R {
	return invoke1[R, A](a1.id, a1.op, a1.a)
}

pub fn (id Id) message(op Sel) MessageBuilder {
	return MessageBuilder{id, op}
}

fn invoke0[R](id Id, op Sel) R {
	msg_send_fn := unsafe { FN_SEND_MSG_0[R](C.objc_msgSend) }
	return msg_send_fn[R](id.ptr, op.sel)
}

fn invoke1[R, A](id Id, op Sel, arg1 A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_1[R, A](C.objc_msgSend) }
	return msg_send_fn[R, A](id.ptr, op.sel, arg1)
}

pub fn (id Id) send_message_f64[R](op Sel, v f64) R {
	msg_send_fn := unsafe { FN_SEND_MSG[R](C.objc_msgSend) }
	return msg_send_fn[R](id.ptr, op.sel, v)
}

pub fn (id Id) send_message_rect[A, R](op Sel, rect A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_RECT[A, R](C.objc_msgSend) }
	return msg_send_fn[A, R](id.ptr, op.sel, rect)
}

pub fn (id Id) send_message_stret[R](op Sel, args ...voidptr) R {
	msg_send_fn := unsafe { FN_SEND_MSG_STRET[R](C.objc_msgSend_stret) }
	return msg_send_fn[R](id.ptr, op.sel, ...args)
}
