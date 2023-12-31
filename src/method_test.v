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
	method := void_method_1[string](func)
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

fn test_void_method_2_encodings() {
	func := fn (self Id, cmd Sel, str string, v u32) {}
	method := void_method_2[string, u32](func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.string(), ec.Encoding.uint()] == method.encodings()
}

fn test_method_2_encodings() {
	func := fn (self Id, cmd Sel, b bool, v i64) int {
		return 0
	}
	method := method_2[int, bool, i64](func)
	assert [ec.Encoding.int(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.bool(), ec.Encoding.long_long()] == method.encodings()
}

fn test_void_method_3_encodings() {
	func := fn (self Id, cmd Sel, str string, v u32, b bool) {}
	method := void_method_3[string, u32, bool](func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.string(), ec.Encoding.uint(), ec.Encoding.bool()] == method.encodings()
}

fn test_method_3_encodings() {
	func := fn (self Id, cmd Sel, b bool, v i64, str string) int {
		return 0
	}
	method := method_3[int, bool, i64, string](func)
	assert [ec.Encoding.int(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.bool(), ec.Encoding.long_long(), ec.Encoding.string()] == method.encodings()
}

fn test_void_method_4_encodings() {
	func := fn (self Id, cmd Sel, str string, v u32, b bool, s i16) {}
	method := void_method_4[string, u32, bool, i16](func)
	assert [ec.Encoding.void(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.string(), ec.Encoding.uint(), ec.Encoding.bool(),
		ec.Encoding.short()] == method.encodings()
}

fn test_method_4_encodings() {
	func := fn (self Id, cmd Sel, b bool, v i64, str string, uc u8) int {
		return 0
	}
	method := method_4[int, bool, i64, string, u8](func)
	assert [ec.Encoding.int(), ec.Encoding.object(), ec.Encoding.sel(),
		ec.Encoding.bool(), ec.Encoding.long_long(), ec.Encoding.string(),
		ec.Encoding.uchar()] == method.encodings()
}
