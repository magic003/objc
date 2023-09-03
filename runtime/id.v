module runtime

[noinit]
pub struct Id {
	ptr &C.objc_object [required]
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
