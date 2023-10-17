module objc

import encode as ec

fn test_void_method_0_encodings() {
	func := fn (self Id, cmd Sel) {}
	method := void_method_0(func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel()] == method.encodings()
}

fn test_method_0_encodings() {
	func := fn (self Id, cmd Sel) int {
		return 0
	}
	method := method_0[int](func)
	assert [ec.Encoding.int(), ec.Encoding.object(), ec.Encoding.sel()] == method.encodings()
}

fn test_void_method_1_encodings() {
	func := fn (self Id, cmd Sel, str string) {}
	method := void_method_1(func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.string()] == method.encodings()
}

fn test_method_1_encodings() {
	func := fn (self Id, cmd Sel, b bool) int {
		return 0
	}
	method := method_1[int, bool](func)
	assert [ec.Encoding.int(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.bool()] == method.encodings()
}
