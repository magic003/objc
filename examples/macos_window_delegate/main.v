module main

import magic003.objc { class, sel }

const ns_application_cls = class('NSApplication') or { panic('failed to load class NSApplication') }

const activation_policy_regular = i64(0)

fn main() {
	app := ns_application_cls.message(sel('sharedApplication')).request[objc.Id]()
	app.message(sel('setActivationPolicy:')).args1(activation_policy_regular).notify()

	delegate := AppDelegate.new(app)
	app.message(sel('setDelegate:')).args1(delegate.delegate).notify()

	app.message(sel('run')).notify()
}
