module objc

fn test_sel_get() {
	sel := Sel.get('init')
	unsafe {
		assert sel.ptr != nil
	}
}
