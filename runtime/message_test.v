module runtime

fn test_send_message() {
	cls := Class.get('NSView') or { panic('failed to load class') }
	rect := CGRect{
		origin: C.CGPoint{
			x: 10.0
			y: 20.0
		}
		size: C.CGSize{
			height: 300.0
			width: 400.0
		}
	}
	mut obj := cls.message(Sel.get('alloc')).request[Id]()
	obj = obj.message(Sel.get('initWithFrame:')).args1(rect).request[Id]()

	obj.message(Sel.get('setFrameRotation:')).args1(f64(20)).notify()
	rotation := obj.message(Sel.get('frameRotation')).request[f64]()
	assert rotation == 20

	frame := obj.message(Sel.get('frame')).request[CGRect]()
	assert frame.origin.x == 10.0
	assert frame.origin.y == 20.0
	assert frame.size.height == 300.0
	assert frame.size.width == 400.0
}
