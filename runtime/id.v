module runtime

type Id = C.objc_object

type FN_SEND_MSG_0[R] = fn (&Id, &C.objc_selector) R

type FN_SEND_MSG_1[R, A] = fn (&Id, &C.objc_selector, A) R

type FN_SEND_MSG[R] = fn (&Id, &C.objc_selector, ...voidptr) R

type FN_SEND_MSG_RECT[A, R] = fn (&Id, &C.objc_selector, A) R

type FN_SEND_MSG_STRET[R] = fn (&Id, &C.objc_selector, ...voidptr) R

pub struct Args0 {}

pub struct Args1[A] {
	arg1 A
}

pub fn (id &Id) send_message[R, A](op Sel, args A) R {
	$if args is Args1 {
		return invoke1(id, op, args.arg1)
	} $else $if args is Args0 {
		return invoke0[R](id, op)
	} $else {
		$compile_error('args is not supported')
	}
}

fn invoke0[R](id &Id, op Sel) R {
	msg_send_fn := unsafe { FN_SEND_MSG_0[R](C.objc_msgSend) }
	return msg_send_fn[R](id, op.sel)
}

fn invoke1[R, A](id &Id, op Sel, arg1 A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_1[R, A](C.objc_msgSend) }
	return msg_send_fn[R, A](id, op.sel, arg1)
}

pub fn (id &Id) send_message_f64[R](op Sel, v f64) R {
	msg_send_fn := unsafe { FN_SEND_MSG[R](C.objc_msgSend) }
	return msg_send_fn[R](id, op.sel, v)
}

pub fn (id &Id) send_message_rect[A, R](op Sel, rect A) R {
	msg_send_fn := unsafe { FN_SEND_MSG_RECT[A, R](C.objc_msgSend) }
	return msg_send_fn[A, R](id, op.sel, rect)
}

pub fn (id &Id) send_message_stret[R](op Sel, args ...voidptr) R {
	msg_send_fn := unsafe { FN_SEND_MSG_STRET[R](C.objc_msgSend_stret) }
	return msg_send_fn[R](id, op.sel, ...args)
}
