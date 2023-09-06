module objc

fn test_sel_get() {
	sel := Sel.get('init')
	assert typeof(sel.ptr).name == '&C.objc_selector'
}
