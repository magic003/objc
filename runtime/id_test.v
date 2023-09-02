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
	obj := cls.class.send_message[&Id, Args0](Sel.get('alloc'), Args0{}).send_message_rect[CGRect, &Id](Sel.get('initWithFrame:'),
		rect)
	// obj := cls.class.send_message[&Id](Sel.get('new'))

	obj.send_message_f64[&Id](Sel.get('setFrameRotation:'), f64(20))
	rotation := obj.send_message[f64, Args0](Sel.get('frameRotation'), Args0{})
	assert rotation == 20

	frame := obj.send_message_stret[CGRect](Sel.get('frame'))
	assert frame.origin.x == 10.0
	assert frame.origin.y == 20.0
	assert frame.size.height == 300.0
	assert frame.size.width == 400.0
}
