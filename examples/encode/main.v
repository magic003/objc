module main

import magic003.objc { encode }

#include <Cocoa/Cocoa.h>
#flag -framework Cocoa

type CGFloat = f64

struct C.CGPoint {
	x CGFloat
	y CGFloat
}

struct C.CGSize {
	height CGFloat
	width  CGFloat
}

struct C.CGRect {
	origin C.CGPoint
	size   C.CGSize
}

type CGRect = C.CGRect

[objc_encoding_name: NSRect]
struct Rect {
	origin C.CGPoint
	size   C.CGSize
}

fn main() {
	println(encode[CGRect]()!.str())
	println(encode[Rect]()!.str())
}
