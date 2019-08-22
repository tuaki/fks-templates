# Simple recursive makefile
include Makefile.conf

SUBDIRS=batch1 \
		todo

.PHONY: $(SUBDIRS) newstats stats pdf

all: stats $(SUBDIRS) pdf
astrid_all: all astrid

$(SUBDIRS):
	$(MAKE) -C $@

SOAP_REQUEST = $(SOAPCLIENT) $(WS_URL) $(1) $(2) $(shell echo $(WS_USERNAME) | base64) $(shell echo $(WS_PASSWORD) | base64)
GLOB_DATA := data
$(GLOB_DATA)/results_new.xml: $(GLOB_DATA)/resultsRequest.soap
	$(call SOAP_REQUEST,$(GLOB_DATA)/resultsRequest.soap,$(GLOB_DATA)/results_new.xml)
$(GLOB_DATA)/stats_new.xml: $(GLOB_DATA)/statsRequest.soap
	$(call SOAP_REQUEST,$(GLOB_DATA)/statsRequest.soap,$(GLOB_DATA)/stats_new.xml)

newstats: $(GLOB_DATA)/results_new.xml $(GLOB_DATA)/stats_new.xml

stats:
#	check if password is filled. If it is, delete stats and download them
	@if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then \
		if [ "$(WS_USERNAME)" = "johndoe" ]; then \
		  echo "Username is default, unable to update results"; \
		else \
		  echo "Username is not default"; \
		  make newstats; \
		  if [ -f data/results.xml ]; then \
		    if cmp -s "data/results.xml" "data/results_new.xml" ; then \
		      echo "Results have not changed"; \
		    else \
		      echo "Results have changed"; \
		      rm data/results_old.xml; \
		      mv data/results.xml data/results_old.xml; \
		      echo "Deleting old results"; \
		    fi; \
		  else \
		    echo "Results do not exist"; \
		  fi; \
		  if [ -f data/stats.xml ]; then \
		    if cmp -s "data/stats.xml" "data/stats_new.xml" ; then \
		      echo "Stats have not changed"; \
		    else \
		      echo "Stats have changed"; \
		      rm data/stats_old.xml; \
		      mv data/stats.xml data/stats_old.xml; \
		      echo "Deleting old stats"; \
		    fi; \
		  else \
		    echo "Stats do not exist"; \
		  fi; \
		  rm data/results_new.xml data/stats_new.xml; \
		fi; \
	else \
	  echo "IPv4 is down, unable to update results"; \
	fi


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

