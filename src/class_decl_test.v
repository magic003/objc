module objc

fn test_class_decl_new() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'ClassDeclTest', 0)
	assert decl != none

	invalid_decl := ClassDecl.new(superclass, 'NSObject', 0)
	assert invalid_decl == none
}

[export: 'foo']
fn foo(self Id, cmd Sel) {
	println('foo')
}

fn test_basic_class_decl() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'BasicClassDecl', 0) or {
		panic('failed to create new ClassDecl')
	}
	method := void_method(fn (self Id, cmd Sel) {
		println('hello')
	})

	assert decl.add_method(sel('printMsg'), method)
	decl.register()
	cls := Class.get('BasicClassDecl') or { panic('failed to load class BasicClassDecl') }
	obj := cls.message(sel('new')).request[Id]()
	obj.message(sel('printMsg')).request[Id]()
}
