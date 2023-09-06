module objc

// A pointer to an instance of a class. It represents the `id` type in Objective-C.
type Id = voidptr

// message creates a message with the `id` as the receiver and `op` as the method selector.
pub fn (id Id) message(op Sel) MsgBuilder {
	unsafe {
		return MsgBuilder{&C.objc_object(id), op.ptr}
	}
}
