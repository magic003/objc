module objc

fn test_class() {
	cls := class('NSObject')
	assert cls != none

	cls_none := class('NonExistsClass')
	assert cls_none == none
}

fn test_sel() {
	s := sel('init')
	unsafe {
		assert s.ptr != nil
	}
}
