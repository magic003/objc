module objc

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

fn test_class_instance_variable() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'TestClassIvar', 0) or {
		panic('failed to create new ClassDecl')
	}

	decl.add_ivar[i64]('num')

	cls := decl.register()

	ivar := cls.instance_variable('num')
	unsafe {
		assert ivar.ptr != nil
	}
}
