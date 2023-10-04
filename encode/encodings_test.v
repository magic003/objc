module encode

fn test_int_str() {
	encoding := Encoding.int()
	assert 'i' == encoding.str()
}

fn test_array_str() {
	e := Encoding.array(12, Encoding.long())
	assert '[12l]' == e.str()
}

fn test_pointer_str() {
	e := Encoding.pointer(Encoding.short())
	assert '^s' == e.str()
}

fn test_struct_str() {
	fields := [Encoding.uint(), Encoding.float()]
	e := Encoding.@struct('CGPoint', fields)
	assert '{CGPoint=If}' == e.str()
}

fn test_union_str() {
	fields := [Encoding.long_long(), Encoding.double()]
	e := Encoding.@union('Union', fields)
	assert '(Union=qd)' == e.str()
}

fn test_bit_field_str() {
	e := Encoding.bit_field(2)
	assert 'b2' == e.str()
}
