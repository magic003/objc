module runtime

fn test_class_get() {
	cls := Class.get('NSObject')
	assert cls != none

	cls_none := Class.get('NonExistsClass')
	assert cls_none == none
}

fn test_class_message() {
	cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := cls.message(Sel.get('new')).request[Id]()
	unsafe {
		assert obj != nil
	}
}
