module runtime

fn test_class_get() {
	cls := Class.get('NSObject')
	assert cls != none

	cls_none := Class.get('NonExistsClass')
	assert cls_none == none
}
