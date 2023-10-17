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
	assert decl.add_method(sel('vMethod0'), vm0)

	m0 := method_0[int](fn (self Id, cmd Sel) int {
		return 10
	})
	assert decl.add_method(sel('method0'), m0)

	vm1 := void_method_1[string](fn (self Id, cmd Sel, str string) {})
	assert decl.add_method(sel('vMethod1:'), vm1)

	cls := decl.register()
	obj := cls.message(sel('new')).request[Id]()

	obj.message(sel('vMethod0')).notify()
	assert 10 == obj.message(sel('method0')).request[int]()
	obj.message(sel('vMethod1:')).args1('str').notify()
}
