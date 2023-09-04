module runtime

// This file defines the bindings for Objective-C runtime classes and functions.

#flag -lobjc
#include <objc/runtime.h>
#include <objc/message.h>

[heap]
struct C.objc_object {}

[heap]
struct C.objc_selector {}

fn C.objc_getClass(&char) &C.objc_object
fn C.sel_registerName(&char) &C.objc_selector

fn C.objc_msgSend()
fn C.objc_msgSend_stret()
