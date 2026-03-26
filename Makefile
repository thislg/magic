PREFIX=/usr
DESTDIR=

all: magic

install: all
	install -D -m644 magic $(DESTDIR)$(PREFIX)/lib/magic/magic
	install -D -m644 magic.fish $(DESTDIR)$(PREFIX)/lib/magic/magic.fish

uninstall:
	rm -r ${PREFIX}/lib/magic/

