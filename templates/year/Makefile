# Simple recursive makefile

SUBDIRS=batch1 \
		todo

.PHONY: $(SUBDIRS)

all: $(SUBDIRS) pdf
astrid_all: all astrid

$(SUBDIRS):
	$(MAKE) -C $@

pdf: $(SUBDIRS)
	find pdf -name "*.pdf" | xargs rm -f
	cp batch?/out/*.pdf leaflet?/out/*.pdf todo/out/*.pdf pdf/
	mv pdf/leaflet?.pdf       pdf/leaflet
	mv pdf/leaflet?-print.pdf pdf/leaflet
	mv pdf/leaflet?-book.pdf  pdf/leaflet
	mv pdf/reseni?-?.pdf      pdf/reseni
	mv pdf/serial?.pdf        pdf/serial
	mv pdf/serie?.pdf         pdf/batch
	mv pdf/serie?-print.pdf	  pdf/batch
	mv pdf/zadani?.pdf        pdf/batch

astrid: all
	@if [ "`git status | egrep -e 'modified|Untracked' | wc -l`" -eq "0" ]; then \
		/bin/true; \
	else \
		echo "Error: New file generated during build.\n"; \
		git status; \
		git reset --hard origin/master; \
		git clean -f; \
		/bin/false; \
	fi

