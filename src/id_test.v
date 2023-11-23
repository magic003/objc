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
	decl.add_ivar[voidptr]('ptr')
	cls := decl.register()

	unsafe {
		obj := cls.message(Sel.get('alloc')).request[Id]()
		obj.set_ivar('num', 10)
		other_obj := superclass.message(Sel.get('alloc')).request[Id]()
		obj.set_ivar('obj', other_obj)
		st := &IvarStruct{
			n: 1
			s: 'str'
			b: false
		}
		obj.set_ivar('ptr', voidptr(st))
		assert 10 == obj.get_ivar[i64]('num')
		assert other_obj == obj.get_ivar[Id]('obj')
		ivar_st := &IvarStruct(obj.get_ivar[voidptr]('ptr'))
		assert st == ivar_st
		assert st.n == ivar_st.n
		assert st.s == ivar_st.s
		assert st.b == ivar_st.b
	}
}

struct IvarStruct {
	n int
	s string
	b bool
}
