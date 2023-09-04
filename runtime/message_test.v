module runtime

fn test_send_message() {
	cls := Class.get('NSView') or { panic('failed to load class') }
	cls_obj := Id{cls.ptr}
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
	// obj := cls.class.send_message[&Id](Sel.get('alloc'), Args0[&Id]{}).send_message_rect[CGRect, &Id](Sel.get('initWithFrame:'),
	// rect)
	/*
	mut obj := cls_obj.message(Sel.get('alloc')).return_type[Id]().send()
	obj.message(Sel.get('initWithFrame:')).args1(rect).return_type[Id]().send()*/
	mut obj := cls_obj.message(Sel.get('alloc')).return_type[ID]().send()
	obj = obj.message(Sel.get('initWithFrame:')).args1(rect).send[ID]()
	//.send_message_rect[CGRect, &ObjStruct](Sel.get('initWithFrame:'), rect)}
	// obj := cls.class.send_message[&Id](Sel.get('new'))

	/*
	obj.send_message[&Id](Sel.get('setFrameRotation:'), Args1[&Id, f64]{
		arg1: f64(20)
	})*/
	obj.message(Sel.get('setFrameRotation:')).args1(f64(20)).send[ID]()
	// rotation := obj.send_message[f64](Sel.get('frameRotation'), Args0[f64]{})
	rotation := obj.message(Sel.get('frameRotation')).return_type[f64]().send()
	assert rotation == 20

	frame := obj.message(Sel.get('frame')).return_type[CGRect]().send()
	assert frame.origin.x == 10.0
	assert frame.origin.y == 20.0
	assert frame.size.height == 300.0
	assert frame.size.width == 400.0
}
