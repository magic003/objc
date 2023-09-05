module runtime

fn test_send_message_0_argument() {
	cls := Class.get('NSMutableArray') or { panic('failed to load class NSMutableArray') }
	arr := cls.message(Sel.get('alloc')).request[Id]()
		.message(Sel.get('init')).request[Id]()
	obj_cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := obj_cls.message(Sel.get('new')).request[Id]()
	arr.message(Sel.get('addObject:')).args1(obj).notify()
	mut size := arr.message(Sel.get('count')).request[u64]()
	assert size == 1

	arr.message(Sel.get('removeAllObjects')).notify()
	size = arr.message(Sel.get('count')).request[u64]()
	assert size == 0
}

fn test_send_message_1_argument() {
	obj_cls := Class.get('NSObject') or { panic('failed to load class NSObject') }
	obj := obj_cls.message(Sel.get('new')).request[Id]()

	cls := Class.get('NSSet') or { panic('failed to load class NSSet') }
	s := cls.message(Sel.get('setWithObject:')).args1[voidptr](obj).request[Id]()
	size := s.message(Sel.get('count')).request[u64]()
	assert size == 1

	contains := s.message(Sel.get('containsObject:')).args1(obj).request[Bool]()
	assert contains == yes
}

fn test_send_message_ns_view() {
	cls := Class.get('NSView') or { panic('failed to load class NSView') }
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
