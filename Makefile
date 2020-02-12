PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dnstimes.sh ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dnstimes.sh
	ln -rs ${DESTDIR}${PREFIX}/bin/{dnstimes.sh,dnstimes}

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/{dnstimes.sh,dnstimes}

.PHONY: install uninstall
