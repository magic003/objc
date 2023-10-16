module objc

import encode as ec

fn test_void_method_encodings() {
	func := fn (self Id, cmd Sel) {}
	method := void_method(func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel()] == method.encodings()
}
