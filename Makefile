all: fmt build test

fmt:
	v fmt -w .

build:
	v -shared runtime

test:
	v -stats test .
