all: fmt build test

fmt:
	v fmt -w .

build:
	v -shared .

test:
	v -stats test .
