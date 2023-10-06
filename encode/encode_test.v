module encode

import objc

fn test_encode_integers() {
	assert 'c' == encode[i8]()!.str()
	assert 's' == encode[i16]()!.str()
	assert 'i' == encode[int]()!.str()
	assert 'q' == encode[i64]()!.str()
	assert 'C' == encode[u8]()!.str()
	assert 'S' == encode[u16]()!.str()
	assert 'I' == encode[u32]()!.str()
	assert 'Q' == encode[u64]()!.str()
}

fn test_encode_floats() {
	assert 'f' == encode[f32]()!.str()
	assert 'd' == encode[f64]()!.str()
}

fn test_encode_bool() {
	assert 'B' == encode[bool]()!.str()
}

fn test_encode_strings() {
	assert '*' == encode[string]()!.str()
	assert '*' == encode[rune]()!.str()
}

fn test_encode_voidptr() {
	assert '^v' == encode[voidptr]()!.str()
}

fn test_encode_object() {
	assert '@' == encode[objc.Id]()!.str()
}

fn test_encode_sel() {
	assert ':' == encode[objc.Sel]()!.str()
}

fn test_encode_class() {
	assert '#' == encode[objc.Class]()!.str()
}

struct Example {
	obj objc.Id
	str string
	num int
}

fn test_encode_struct() {
	assert '{Example=@*i}' == encode[Example]()!.str()
}
