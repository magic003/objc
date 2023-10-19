module objc

fn test_id_class() {
	cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := cls.message(Sel.get('new')).request[Id]()

	assert cls == obj.class()
}
