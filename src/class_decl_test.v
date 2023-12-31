module objc

fn test_class_decl_new() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'ClassDeclTest', 0)
	assert decl != none

	invalid_decl := ClassDecl.new(superclass, 'NSObject', 0)
	assert invalid_decl == none
}

fn test_class_decl_methods() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'BasicClassDecl', 0) or {
		panic('failed to create new ClassDecl')
	}

	vm0 := void_method_0(fn (self Id, cmd Sel) {})
	unsafe {
		assert decl.add_method(sel('vMethod0'), vm0)
	}
	m0 := method_0[int](fn (self Id, cmd Sel) int {
		return 10
	})
	unsafe {
		assert decl.add_method(sel('method0'), m0)
	}
	vm1 := void_method_1[string](fn (self Id, cmd Sel, str string) {})
	unsafe {
		assert decl.add_method(sel('vMethod1:'), vm1)
	}
	m1 := method_1[int, Id](fn (self Id, cmd Sel, obj Id) int {
		return 20
	})
	unsafe {
		assert decl.add_method(sel('method1:'), m1)
	}
	vm2 := void_method_2[string, u32](fn (self Id, cmd Sel, str string, v u32) {})
	unsafe {
		assert decl.add_method(sel('vMethod2:v:'), vm2)
	}
	m2 := method_2[bool, Id, i64](fn (self Id, cmd Sel, obj Id, v i64) bool {
		return true
	})
	unsafe {
		assert decl.add_method(sel('method2:v:'), m2)
	}
	vm3 := void_method_3[string, u32, bool](fn (self Id, cmd Sel, str string, v u32, b bool) {})
	unsafe {
		assert decl.add_method(sel('vMethod3:v:b:'), vm3)
	}
	m3 := method_3[i64, Id, i64, string](fn (self Id, cmd Sel, obj Id, v i64, str string) i64 {
		return v
	})
	unsafe {
		assert decl.add_method(sel('method3:v:str:'), m3)
	}
	vm4 := void_method_4[string, u32, bool, i16](fn (self Id, cmd Sel, str string, v u32, b bool, s i16) {})
	unsafe {
		assert decl.add_method(sel('vMethod4:v:b:s:'), vm4)
	}
	m4 := method_4[u8, Id, i64, string, u8](fn (self Id, cmd Sel, obj Id, v i64, str string, uc u8) u8 {
		return uc
	})
	unsafe {
		assert decl.add_method(sel('method4:v:str:uc:'), m4)
	}
	cls := decl.register()
	unsafe {
		obj := cls.message(sel('new')).request[Id]()

		obj.message(sel('vMethod0')).notify()
		assert 10 == obj.message(sel('method0')).request[int]()
		obj.message(sel('vMethod1:')).args1('str').notify()
		assert 20 == obj.message(sel('method1:')).args1(obj).request[int]()
		obj.message(sel('vMethod2:v:')).args2('str', 1).notify()
		assert obj.message(sel('method2:v:')).args2(obj, 10000).request[bool]()
		obj.message(sel('vMethod3:v:b:')).args3('str', 1, true).notify()
		assert 10000 == obj.message(sel('method3:v:str:')).args3(obj, 10000, 'm3').request[i64]()
		obj.message(sel('vMethod4:v:b:s:')).args4('str', 1, true, 2).notify()
		assert 3 == obj.message(sel('method4:v:str:uc:')).args4(obj, 10000, 'm4', 3).request[u8]()
	}
}

fn test_add_ivar() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'TestAddIvar', 0) or {
		panic('failed to create new ClassDecl')
	}

	assert decl.add_ivar[i64]('num')
	assert false == decl.add_ivar[i64]('num')
}
