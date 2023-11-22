module objc

#include <Foundation/Foundation.h>
#flag -framework Foundation

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
	assert '*' == encode[&char]()!.str()
}

fn test_encode_voidptr() {
	assert '^v' == encode[voidptr]()!.str()
}

fn test_encode_object() {
	assert '@' == encode[Id]()!.str()
}

fn test_encode_sel() {
	assert ':' == encode[Sel]()!.str()
}

fn test_encode_class() {
	assert '#' == encode[Class]()!.str()
}

struct Example {
	obj Id
	str string
	num int
}

fn test_encode_struct() {
	assert '{Example=@*i}' == encode[Example]()!.str()
}

type AnotherExample = Example

type NSRect = C.NSRect

type CGFloat = f64

struct C.CGPoint {
	x CGFloat @[required]
	y CGFloat @[required]
}

type CGPoint = C.CGPoint

struct C.CGSize {
	height CGFloat @[required]
	width  CGFloat @[required]
}

type CGSize = C.CGSize

@[typedef]
struct C.NSRect {
	origin CGPoint @[required]
	size   CGSize  @[required]
}

fn test_encode_alias() {
	assert '{Example=@*i}' == encode[AnotherExample]()!.str()
	assert '{NSRect={CGPoint=dd}{CGSize=dd}}' == encode[NSRect]()!.str()
}

@[objc_encoding_name: CGRect]
struct NSRect2 {
	origin CGPoint @[required]
	size   CGSize  @[required]
}

fn test_encode_struct_name_attr() {
	assert '{CGRect={CGPoint=dd}{CGSize=dd}}' == encode[NSRect2]()!.str()
}
