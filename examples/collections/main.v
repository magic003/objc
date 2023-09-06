module main

import magic003.objc { class, sel }

#include <Foundation/Foundation.h>
#flag -framework Foundation

const ns_ascii_string_encoding = u64(1)

fn main() {
	num_cls := class('NSNumber') or { panic('failed to load class NSNumber') }
	str_cls := class('NSString') or { panic('failed to load class NSString') }
	array_cls := class('NSMutableArray') or { panic('failed to load class NSMutableArray') }
	set_cls := class('NSMutableSet') or { panic('failed to load class NSMutableSet') }
	dict_cls := class('NSMutableDictionary') or {
		panic('failed to load class NSMutableDictionary')
	}

	n1 := num_cls.message(sel('numberWithInt:')).args1[int](1).request[objc.Id]()
	n2 := num_cls.message(sel('numberWithInt:')).args1[int](2).request[objc.Id]()
	n3 := num_cls.message(sel('numberWithInt:')).args1[int](3).request[objc.Id]()

	str1 := str_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithCString:encoding:')).args2(c'str1', ns_ascii_string_encoding).request[objc.Id]()
	str2 := str_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithCString:encoding:')).args2(c'str2', ns_ascii_string_encoding).request[objc.Id]()
	str3 := str_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithCString:encoding:')).args2(c'str3', ns_ascii_string_encoding).request[objc.Id]()
	another_str3 := str_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithCString:encoding:')).args2(c'str3', ns_ascii_string_encoding).request[objc.Id]()

	arr := array_cls.message(sel('new')).request[objc.Id]()
	arr.message(sel('addObject:')).args1(n1).notify()
	arr.message(sel('addObject:')).args1(n2).notify()
	arr.message(sel('addObject:')).args1(n3).notify()
	println('Array: ')
	print_id(arr)

	set := set_cls.message(sel('setWithCapacity:')).args1(u64(5)).request[objc.Id]()
	set.message(sel('addObject:')).args1(str1).notify()
	set.message(sel('addObject:')).args1(str2).notify()
	set.message(sel('addObject:')).args1(str3).notify()
	set.message(sel('addObject:')).args1(another_str3).notify()
	println('Set: ')
	print_id(set)

	dict := dict_cls.message(sel('dictionaryWithCapacity:')).args1(u64(2)).request[objc.Id]()
	dict.message(sel('setValue:forKey:')).args2(n1, str1).notify()
	dict.message(sel('setValue:forKey:')).args2(n2, str2).notify()
	dict.message(sel('setValue:forKey:')).args2(n3, str3).notify()
	println('Dictionary: ')
	print_id(dict)
}

fn print_id(id objc.Id) {
	desc := id.message(sel('description')).request[objc.Id]()
	cstr := desc.message(sel('cStringUsingEncoding:')).args1(ns_ascii_string_encoding).request[&char]()
	unsafe { println(cstr.vstring()) }
}
