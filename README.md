This vlang package provides Objective-C Runtime bindings for V.

## Status
It is currently working in progress and should be considered experimental. It's only tested on 
x86\_64 architecture, macOS Sonoma 14.0.

Supported features:
* Bool type
* Id type
* Load classes
* Create instances
* Register selectors
* Send messages (varargs are not supported)
* Class declaration

## Installation
```shell
v install magic003.objc
```

## Usage

### Bool type
The `Bool` type is an alias of the V `bool` type.

```v
assert objc.yes == true
assert objc.no == false
```

### Load a class
An Objective-C class can be loaded using either a factory function or a static type method.

```v
cls1 := objc.Class.get('NSMutableArray') or { panic('failed to load class NSMutableArray') }
cls2 := objc.class('NSMutableArray') or { panic('failed to load class NSMutableArray') }
```

### Register and get a selector
An Objective-C selector can be registered using either a factory function or a static type method.

```v
s1 := objc.Sel.get('init')
s2 := objc.sel('init')
```

### Send messages
Messages can be sent to a class or an instance. There are two types of messages:
* `request[R]()`: a message with return type `R`.
* `notify()`: a message without a return value.

```v
unsafe {
    // a mutable array instance is created via chained messages
    arr := cls1.message(objc.sel('alloc')).request[objc.Id]()
            .message(objc.sel('init')).request[objc.Id]()

    // load the NSObject class and create an instance
    obj_cls := objc.class('NSObject') or { panic('failed to load class NSObject') }
    obj := obj_cls.message(sel('new')).request[objc.Id]()

    // add an object to the array. Message with one argument and no return value. 
    // Use `args2()`, `args3()` and etc for more arguments.
    arr.message(sel('addObject:')).args1(obj).notify()

    // message without an argument.
    size := arr.message(sel('count')).request[u64]()
    assert size == 1
}
```

### Declare a new class
New classes can be declared and registered with the Objective-C Runtime.

```v
superclass := objc.class('NSObject') or { panic('failed to load class NSObject') }
// create a new class with `NSObject` as the super class.
decl := ClassDecl.new(superclass, 'NewClass', 0) or {
    panic('failed to create class NewClass')
}

// add ivars
decl.add_ivar[i64]('num')
decl.add_ivar[objc.Id]('obj')

// add methods
m1 := objc.void_method_1[bool](fn (self objc.Id, cmd objc.Sel, flag bool) {
    // do something
})
unsafe { decl.add_method(objc.sel('method1:'), m1) }
m2 := objc.method_1[int, objc.Id](fn (self objc.Id, cmd objc.Sel, obj objc.Id) int {
    return 10
})
unsafe { delc.add_method(objc.sel('method2:'), m2) }

// register the class
cls := decl.register()

unsafe {
    // create an instance from the new class
    obj := cls.message(objc.sel('new')).request[objc.Id]()
    
    // set ivar
    obj.set_ivar('num', 1)

    // call method
    obj.message(objc.sel('method1:')).args1(true).notify()
}
```

## Examples

The unit tests have basic usages.

Check out the `examples` folder for more examples. 

## Documentation

* API Documentation: http://magic003.github.io/objc
* Why this project: [V and Objective-C interoperability](https://open.substack.com/pub/insideout101/p/v-and-objective-c-interoperability?r=2rxz0s&utm_campaign=post&utm_medium=web)

## References

* [Programming with Objective-C](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC) 
* [Objective-C Runtime APIs](https://developer.apple.com/documentation/objectivec?language=objc)
* [rust-objc](https://github.com/SSheldon/rust-objc): Objective-C bindings for Rust.
