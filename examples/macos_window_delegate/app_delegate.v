module main

import magic003.objc { class, sel, void_method_1 }

#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#flag -framework Foundation
#flag -framework Cocoa

[typedef]
pub struct C.NSRect {}

fn C.NSMakeRect(x f64, y f64, w f64, h f64) C.NSRect

const ns_string_cls = class('NSString') or { panic('failed to load class NSString') }

const ns_data_cls = class('NSData') or { panic('failed to load class NSData') }

const ns_object_cls = class('NSObject') or { panic('failed to load class NSObject') }

const ns_menu_cls = class('NSMenu') or { panic('failed to load class NSMenu') }

const ns_menu_item_cls = class('NSMenuItem') or { panic('failed to load class NSMenuItem') }

const ns_window_cls = class('NSWindow') or { panic('failed to load class NSWindow') }

const ns_ascii_string_encoding = u64(1)

const app_delegate_cls = register_app_delegate_class()

const window_style_titled = u64(1)

const window_style_closable = u64(1) << 1

const window_style_resizable = u64(1) << 3

const backing_store_type_buffered = u64(2)

[heap]
struct AppDelegate {
	delegate objc.Id [required]
}

fn AppDelegate.new() AppDelegate {
	delegate := app_delegate_cls.message(sel('alloc')).request[objc.Id]()
	return AppDelegate{delegate}
}

fn init_window_and_menu() objc.Id {
	app := ns_application_cls.message(sel('sharedApplication')).request[objc.Id]()

	menu_bar := ns_menu_cls.message(sel('new')).request[objc.Id]()
	app_menu_item := ns_menu_item_cls.message(sel('new')).request[objc.Id]()
	menu_bar.message(sel('addItem:')).args1(app_menu_item).notify()
	app_menu := ns_menu_cls.message(sel('new')).request[objc.Id]()
	quit_menu_item := ns_menu_item_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithTitle:action:keyEquivalent:'))
		.args3(new_ns_string('Quit'), sel('terminate:'), new_ns_string('q'))
		.request[objc.Id]()
	app_menu.message(sel('addItem:')).args1(quit_menu_item).notify()
	app_menu_item.message(sel('setSubmenu:')).args1(app_menu).notify()
	app.message(sel('setMainMenu:')).args1(menu_bar).notify()

	window_style := window_style_titled | window_style_closable | window_style_resizable
	window_rect := C.NSMakeRect(100, 100, 400, 400)
	window := ns_window_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithContentRect:styleMask:backing:defer:'))
		.args4(window_rect, window_style, backing_store_type_buffered, objc.no)
		.request[objc.Id]()
	return window
}

fn register_app_delegate_class() objc.Class {
	decl := objc.ClassDecl.new(ns_object_cls, 'AppDelegate', 0) or {
		panic('failed to declare class AppDelegate')
	}
	decl.add_method(sel('applicationWillFinishLaunching:'), void_method_1(application_will_finish_launching))
	decl.add_method(sel('applicationDidFinishLaunching:'), void_method_1(application_did_finish_launching))

	return decl.register()
}

fn application_will_finish_launching(self objc.Id, cmd objc.Sel, notification objc.Id) {
	println('application_will_finish_launching called')
}

fn application_did_finish_launching(self objc.Id, cmd objc.Sel, notification objc.Id) {
	println('application_did_finish_launching called')
	window := init_window_and_menu()

	app := ns_application_cls.message(sel('sharedApplication')).request[objc.Id]()
	app.message(sel('activateIgnoringOtherApps:')).args1(objc.yes).notify()
	window.message(sel('makeKeyAndOrderFront:')).args1(app).notify()
}

fn new_ns_string(str string) objc.Id {
	data := ns_data_cls.message(sel('dataWithBytes:length:')).args2(str.str, str.len).request[objc.Id]()
	return ns_string_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithData:encoding:'))
		.args2(data, ns_ascii_string_encoding)
		.request[objc.Id]()
}
