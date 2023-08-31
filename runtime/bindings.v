module runtime

#flag -lobjc
#include <objc/runtime.h>

struct C.objc_object {}

fn C.objc_getClass(&char) &Id
