module objc

fn test_class() {
	cls := class('NSObject')
	assert cls != none

	cls_none := class('NonExistsClass')
	assert cls_none == none
}

fn test_sel() {
	s := sel('init')
	assert typeof(s.ptr).name == '&C.objc_selector'
}
