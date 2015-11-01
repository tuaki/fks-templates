# Simple recursive makefile

SUBDIRS=batch1 \
		todo

.PHONY: $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@
