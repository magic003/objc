module objc

// This file defines the bindings for Objective-C runtime classes and functions.

#flag -lobjc
#include <objc/runtime.h>
#include <objc/message.h>

fn C.objc_getClass(&char) voidptr
fn C.sel_registerName(&char) voidptr

fn C.objc_msgSend()
fn C.objc_msgSend_stret()

fn C.objc_allocateClassPair(superclass voidptr, name &char, extra_bytes usize) voidptr
fn C.class_addIvar(cls voidptr, name &char, size u32, alignment u8, types &char) bool
fn C.class_getInstanceVariable(cls voidptr, name &char) voidptr
fn C.class_addMethod(cls voidptr, sel voidptr, imp fn (), types &char) bool
fn C.objc_registerClassPair(cls voidptr)

fn C.ivar_getName(ivar voidptr) &char
fn C.ivar_getTypeEncoding(ivar voidptr) &char
fn C.ivar_getOffset(ivar voidptr) isize

fn C.object_getClass(id voidptr) voidptr
