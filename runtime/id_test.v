module runtime

fn test_send_message() {
	cls := Class.get('NSView') or { panic('failed to load class') }
	rect := C.CGRect{
		origin: C.CGPoint{
			x: 10.0
			y: 20.0
		}
		size: C.CGSize{
			height: 300.0
			width: 400.0
		}
	}
	// obj := cls.class.send_message[&Id](Sel.get('alloc'), Args0[&Id]{}).send_message_rect[CGRect, &Id](Sel.get('initWithFrame:'),
	// rect)
	obj := cls.class.message(Sel.get('alloc')).send().send_message_rect[CGRect, &Id](Sel.get('initWithFrame:'),
		rect)
	// obj := cls.class.send_message[&Id](Sel.get('new'))

	/*
	obj.send_message[&Id](Sel.get('setFrameRotation:'), Args1[&Id, f64]{
		arg1: f64(20)
	})*/
	obj.message(Sel.get('setFrameRotation:')).add_1_arg(f64(20)).send[&Id]()
	// rotation := obj.send_message[f64](Sel.get('frameRotation'), Args0[f64]{})
	rotation := obj.message(Sel.get('frameRotation')).return_type[f64]().send()
	assert rotation == 20

	frame := obj.send_message_stret[CGRect](Sel.get('frame'))
	assert frame.origin.x == 10.0
	assert frame.origin.y == 20.0
	assert frame.size.height == 300.0
	assert frame.size.width == 400.0
}
