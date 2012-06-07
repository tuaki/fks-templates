# Simple recursive makefile

SUBDIRS=batch1 

.PHONY: $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	make -C $@
