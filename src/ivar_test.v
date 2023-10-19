module objc

import encode as ec

fn test_ivar() {
	superclass := Class.get('NSObject') or { panic('failed to load class NSObject') }
	decl := ClassDecl.new(superclass, 'TestIvar', 0) or { panic('failed to create new ClassDecl') }

	decl.add_ivar[i64]('num')

	cls := decl.register()

	ivar := cls.instance_variable('num') or { panic('failed to get instance variable') }
	assert 'num' == ivar.name()
	assert ec.Encoding.long_long().str() == ivar.type_encoding()
	assert ivar.offset() > 0
}
