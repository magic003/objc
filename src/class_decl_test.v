module objc

fn test_class_decl_new() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'ClassDeclTest', 0)
	assert decl != none

	invalid_decl := ClassDecl.new(superclass, 'NSObject', 0)
	assert invalid_decl == none
}
