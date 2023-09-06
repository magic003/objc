module objc

fn test_bool() {
	assert typeof(yes).name == 'objc.Bool'
	assert typeof(no).name == 'objc.Bool'
	assert yes == true
	assert no == false
}
