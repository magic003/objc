module objc

fn test_id_class() {
	cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := cls.message(Sel.get('new')).request[Id]()

	assert cls == obj.class()
}

fn test_id_ivar() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'TestSetIvar', 0) or {
		panic('failed to create new ClassDecl')
	}

	decl.add_ivar[i64]('num')
	cls := decl.register()

	obj := cls.message(Sel.get('alloc')).request[Id]()
	obj.set_ivar('num', 10)
	assert 10 == obj.get_ivar[i64]('num')
}
