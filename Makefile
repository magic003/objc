all: fmt build test

fmt:
	v fmt -w .

build:
	v -shared .

test:
	v -stats test .

vdoc:
	v doc -readme -f html -m . -o /tmp/
