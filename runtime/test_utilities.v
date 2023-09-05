module runtime

// This file contains the Cocoa bindings used for unit tests.
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
