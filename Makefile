DESTDIR=
DST=$(DESTDIR)/usr/local/share/fks/templates

build:
	true

clean:
	true

install:
	mkdir -p $(DST)
	cp -r templates/* -t $(DST)/
