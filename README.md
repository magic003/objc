This vlang package provides Objective-C Runtime bindings for V.

## Status
It is currently working in progress and should be considered experimental. It's only tested on 
x86\_64 architecture, macOS Ventura 13.5.

Supported features:
* Bool type
* Id type
* Load classes
* Create instances
* Register selectors
* Send messages (varargs are not supported)

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
```

## Examples

The unit tests have basic usages.

Check out the `examples` folder for more examples. 

## Documentation

Documentation: http://magic003.github.io/objc

## References

* [Programming with Objective-C](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC) 
* [Objective-C Runtime APIs](https://developer.apple.com/documentation/objectivec?language=objc)
* [rust-objc](https://github.com/SSheldon/rust-objc): Objective-C bindings for Rust.
