module objc

fn test_id_class() {
	cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := unsafe { cls.message(Sel.get('new')).request[Id]() }

	assert cls == obj.class()
}

fn test_id_ivar() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'TestSetIvar', 0) or {
		panic('failed to create new ClassDecl')
	}

	decl.add_ivar[i64]('num')
	decl.add_ivar[Id]('obj')
	cls := decl.register()

	unsafe {
		obj := cls.message(Sel.get('alloc')).request[Id]()
		obj.set_ivar('num', 10)
		other_obj := superclass.message(Sel.get('alloc')).request[Id]()
		obj.set_ivar('obj', other_obj)
		assert 10 == obj.get_ivar[i64]('num')
		assert other_obj == obj.get_ivar[Id]('obj')
	}
}
