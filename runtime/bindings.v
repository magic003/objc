module runtime

#flag -lobjc
#include <objc/runtime.h>
#include <objc/message.h>

struct C.objc_object {}

struct C.objc_selector {}

fn C.objc_getClass(&char) &Id
fn C.sel_registerName(&char) &C.objc_selector

fn C.objc_msgSend()
fn C.objc_msgSend_stret()
