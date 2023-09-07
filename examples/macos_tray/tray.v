module main

import magic003.objc { class, sel }

#include <Cocoa/Cocoa.h>
#flag -framework Cocoa

const ns_string_cls = class('NSString') or { panic('failed to load class NSString') }

const ns_data_cls = class('NSData') or { panic('failed to load class NSData') }

const ns_application_cls = class('NSApplication') or { panic('failed to load class NSApplication') }

const ns_status_bar_cls = class('NSStatusBar') or { panic('failed to load class NSStatusBar') }

const ns_image_cls = class('NSImage') or { panic('failed to load class NSImage') }

const ns_menu_cls = class('NSMenu') or { panic('failed to load class NSMenu') }

const ns_menu_item_cls = class('NSMenuItem') or { panic('failed to load class NSMenuItem') }

const ns_ascii_string_encoding = u64(1)

const ns_square_status_item_length = f64(-2.0)

[heap]
struct TrayApp {
	app objc.Id [required] // NSApplication object
}

fn TrayApp.new() TrayApp {
	app := ns_application_cls.message(sel('sharedApplication')).request[objc.Id]()
	return TrayApp{app}
}

fn (app &TrayApp) init() {
	status_bar := ns_status_bar_cls.message(sel('systemStatusBar')).request[objc.Id]()
	status_item := status_bar.message(sel('statusItemWithLength:')).args1(ns_square_status_item_length)
		.request[objc.Id]()
	status_item.message(sel('setVisible:')).args1(objc.yes).notify()
	btn := status_item.message(sel('button')).request[objc.Id]()

	img := ns_image_cls.message(sel('imageNamed:')).args1(new_ns_string('icon.png')).request[objc.Id]()
	btn.message(sel('setImage:')).args1(img).notify()

	menu := app.build_menu()
	status_item.message(sel('setMenu:')).args1(menu).notify()
}

fn (app &TrayApp) run() {
	app.app.message(sel('run')).notify()
}

fn (app &TrayApp) build_menu() objc.Id {
	menu := ns_menu_cls.message(sel('new')).request[objc.Id]()
	menu.message(sel('setAutoenablesItems:')).args1(objc.no).notify()

	items := [
		MenuItem{
			id: 'hello'
			text: 'Hello'
		},
		MenuItem{
			id: 'quit'
			text: 'Quit'
		},
	]

	for item in items {
		title := new_ns_string(item.text)
		menu_item := ns_menu_item_cls.message(sel('new')).request[objc.Id]()
		menu_item.message(sel('setTitle:')).args1(title).notify()
		menu_item.message(sel('setEnabled:')).args1(objc.yes).notify()
		if item.id == 'quit' {
			menu_item.message(sel('setTarget:')).args1(app.app).notify()
			menu_item.message(sel('setAction:')).args1(sel('terminate:')).notify()
		}

		menu.message(sel('addItem:')).args1(menu_item).notify()
	}

	return menu
}

struct MenuItem {
	id   string [required]
	text string [required]
}

fn new_ns_string(str string) objc.Id {
	data := ns_data_cls.message(sel('dataWithBytes:length:')).args2(str.str, str.len).request[objc.Id]()
	return ns_string_cls.message(sel('alloc')).request[objc.Id]()
		.message(sel('initWithData:encoding:'))
		.args2(data, ns_ascii_string_encoding)
		.request[objc.Id]()
}
