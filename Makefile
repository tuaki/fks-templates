DESTDIR=
DST=$(DESTDIR)/usr/share/fks/templates

build:
	true

clean:
	true

install:
	mkdir -p $(DST)
	cp -r templates/* -t $(DST)/
