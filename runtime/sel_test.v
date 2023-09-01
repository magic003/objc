module runtime

fn test_sel_get() {
	sel := Sel.get('init')
	assert typeof(sel.sel).name == '&C.objc_selector'
}
