module objc

// This file defines the bindings for Objective-C runtime classes and functions.

#flag -lobjc
#include <objc/runtime.h>
#include <objc/message.h>

fn C.objc_getClass(&char) voidptr
fn C.sel_registerName(&char) voidptr

fn C.objc_msgSend()
fn C.objc_msgSend_stret()
