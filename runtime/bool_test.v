module runtime

fn test_bool() {
	assert typeof(yes).name == 'runtime.Bool'
	assert typeof(no).name == 'runtime.Bool'
	assert yes == true
	assert no == false
}
