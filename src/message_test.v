module objc

// The Cocoa types used in this unit test.
#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#flag -framework Foundation
#flag -framework Cocoa

struct C.CGPoint {
	x f64
	y f64
}

struct C.CGSize {
	height f64
	width  f64
}

struct C.CGRect {
	origin C.CGPoint
	size   C.CGSize
}

type CGRect = C.CGRect

const obj_cls = Class.get('NSObject') or { panic('failed to load class NSObject') }

const str_cls = Class.get('NSString') or { panic('failed to load class NSString') }

const set_cls = Class.get('NSSet') or { panic('failed to load class NSSet') }

const mutable_arr_cls = Class.get('NSMutableArray') or {
	panic('failed to load class NSMutableArray')
}

const mutable_dict_cls = Class.get('NSMutableDictionary') or {
	panic('failed to load class NSMutableDictionary')
}

const ns_view_cls = Class.get('NSView') or { panic('failed to load class NSView') }

fn test_send_message_0_argument() {
	unsafe {
		arr := objc.mutable_arr_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('init')).request[Id]()
		obj := objc.obj_cls.message(Sel.get('new')).request[Id]()
		arr.message(Sel.get('addObject:')).args1(obj).notify()
		mut size := arr.message(Sel.get('count')).request[u64]()
		assert size == 1

		arr.message(Sel.get('removeAllObjects')).notify()
		size = arr.message(Sel.get('count')).request[u64]()
		assert size == 0
	}
}

fn test_send_message_1_argument() {
	unsafe {
		obj := objc.obj_cls.message(Sel.get('new')).request[Id]()

		s := objc.set_cls.message(Sel.get('setWithObject:')).args1[voidptr](obj).request[Id]()
		size := s.message(Sel.get('count')).request[u64]()
		assert size == 1

		contains := s.message(Sel.get('containsObject:')).args1(obj).request[Bool]()
		assert contains == yes
	}
}

fn test_send_message_2_arguments() {
	unsafe {
		dict := objc.mutable_dict_cls.message(Sel.get('dictionaryWithCapacity:')).args1(u64(5)).request[Id]()

		k1 := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithCString:encoding:')).args2(c'k1', u64(1)).request[Id]()
		v1 := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithCString:encoding:')).args2(c'v1', u64(1)).request[Id]()
		dict.message(Sel.get('setValue:forKey:')).args2(v1, k1).notify()
		mut size := dict.message(Sel.get('count')).request[u64]()
		assert size == 1

		k2 := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithCString:encoding:')).args2(c'k2', u64(1)).request[Id]()
		v2 := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithCString:encoding:')).args2(c'v2', u64(1)).request[Id]()
		dict.message(Sel.get('setValue:forKey:')).args2(v2, k2).notify()
		size = dict.message(Sel.get('count')).request[u64]()
		assert size == 2

		v2_obj := dict.message(Sel.get('valueForKey:')).args1(k2).request[Id]()
		v2_cstring := v2_obj.message(Sel.get('cStringUsingEncoding:')).args1(u64(1)).request[&char]()
		assert v2_cstring.vstring() == 'v2'
	}
}

fn test_send_message_3_arguments() {
	unsafe {
		vstr := 'hello world'
		str := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithBytes:length:encoding:'))
			.args3(vstr.str, vstr.len, u64(1)).request[Id]()

		cstr := str.message(Sel.get('cStringUsingEncoding:')).args1(u64(1)).request[&char]()
		assert cstr.vstring() == vstr
	}
}

fn test_send_message_4_arguments() {
	unsafe {
		vstr := 'foo bar'
		str := objc.str_cls.message(Sel.get('alloc')).request[Id]()
			.message(Sel.get('initWithBytesNoCopy:length:encoding:freeWhenDone:'))
			.args4(vstr.str, vstr.len, u64(1), no).request[Id]()

		cstr := str.message(Sel.get('cStringUsingEncoding:')).args1(u64(1)).request[&char]()
		assert cstr.vstring() == vstr
	}
}

fn test_send_message_ns_view() {
	unsafe {
		rect := CGRect{
			origin: C.CGPoint{
				x: 10.0
				y: 20.0
			}
			size: C.CGSize{
				height: 300.0
				width: 400.0
			}
		}
		mut obj := objc.ns_view_cls.message(Sel.get('alloc')).request[Id]()
		obj = obj.message(Sel.get('initWithFrame:')).args1(rect).request[Id]()

		obj.message(Sel.get('setFrameRotation:')).args1(f64(20)).notify()
		rotation := obj.message(Sel.get('frameRotation')).request[f64]()
		assert rotation == 20

		frame := obj.message(Sel.get('frame')).request[CGRect]()
		assert frame.origin.x == 10.0
		assert frame.origin.y == 20.0
		assert frame.size.height == 300.0
		assert frame.size.width == 400.0
	}
}
