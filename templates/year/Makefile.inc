# Common makefile parts
# vim: syn=make

include ../Makefile.conf
include $(PROBLEMS)/Makefile.inc
include ../Deadline.inc
include ../Deadline_xml.inc

# == Graphics part ==
# -- Plots --
# epslatex output + size for two plots vertically on page
gnuplot=gnuplot -e "set format '$$\"%g\"$$' ; set terminal epslatex monochrome size 12.7cm,7.7cm; set output '$(@F)' " $(<F)
define plot
$(gnuplot)
endef
define plot-color
$(subst output ', output 'color/, $(subst monochrome,color,$(gnuplot)))
endef

$(PGRAPHICS)/%.eps $(PGRAPHICS)/%.tex: $(PGRAPHICS)/%.plt
	cd $(<D); $(plot)
$(PGRAPHICS)/color/%.eps $(PGRAPHICS)/color/%.tex: $(PGRAPHICS)/%.plt
	cd $(<D); $(plot-color)

$(GRAPHICS)/%.eps $(GRAPHICS)/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot)
$(GRAPHICS)/color/%.eps $(GRAPHICS)/color/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot-color)

# -- Metapost figures --
define mpost-a 
cd $(@D); mpost $(<F)
endef
define mpost-b
mv $< $@
endef
$(PGRAPHICS)/%.eps : $(PGRAPHICS)/%.1
	$(mpost-b)
$(PGRAPHICS)/%.1 : $(PGRAPHICS)/%.mp
	$(mpost-a)
$(GRAPHICS)/%.eps : $(GRAPHICS)/%.1
	$(mpost-b)
$(GRAPHICS)/%.1 : $(GRAPHICS)/%.mp
	$(mpost-a)

# -- IPE figures --
$(PGRAPHICS)/%.eps : $(PGRAPHICS)/%.ipe
	- ipetoipe -eps $< $@
	ipetoipe -eps $< $@

$(GRAPHICS)/%.eps : $(GRAPHICS)/%.ipe
	- ipetoipe -eps $< $@
	ipetoipe -eps $< $@


# == Data retrieval ==
GLOB_DATA := ../data
# credentials are at least obfuscated so they aren't easily grep'able from logs
SOAP_REQUEST = $(SOAPCLIENT) $(WS_URL) $(1) $(2) $(shell echo $(WS_USERNAME) | base64) $(shell echo $(WS_PASSWORD) | base64)

# vysledky?-% is implicit rule, results can't be also imlicit, so mention it explicitly
# see: https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
$(GLOB_DATA)/results.xml: $(GLOB_DATA)/resultsRequest.soap
$(GLOB_DATA)/stats.xml: $(GLOB_DATA)/statsRequest.soap

$(GLOB_DATA)/%.xml: $(GLOB_DATA)/%Request.soap
	$(call SOAP_REQUEST,$<,$@)

.PRECIOUS: $(GLOB_DATA)/*.xml $(GLOB_DATA)/results.xml

# == Data processing ==
SIGNATURES := ../signatures.tex
$(SIGNATURES): $(GLOB_DATA)/signatures.xml $(SIGNATURES_STYLE)
	xsltproc $(XSL_SIGNATURES) $< >$@

$(RESULTS)/vysledky%.tex: $(GLOB_DATA)/results.xml $(XSL_RESULTS)
	xsltproc --stringparam type brojure \
		--stringparam category $(word 2,$(subst -, ,$(subst .tex,,$(subst $(RESULTS)/vysledky,,$@)))) \
		--stringparam series   $(word 1,$(subst -, ,$(subst .tex,,$(subst $(RESULTS)/vysledky,,$@)))) \
		$(XSL_RESULTS) $< >$@

$(RESULTS)/statistiky%.csv: $(GLOB_DATA)/stats.xml $(XSL_STATS)
	xsltproc --stringparam series $* \
		$(XSL_STATS) $< >$@
	# apply created results to statistics
	$(STATS_SH) $(PROBLEMS) $@


$(RESULTS)/%.tex: $(RESULTS)/%.csv
	iconv -f latin2 -t utf8 $< | \
	cut -d\; -f1,2,3,4,5,6,7,8,9,10,12,13,14 | \
	sed '/^$$/d;/^%/d;s/;;/;--;/g;s/;;/;--;/g;s/;/ \& /g;s/$$/\\\\/' | sed -e '2i\\\\midrule'  > $@

# == Deadlines ==
../Deadline.inc: ../Deadline_xml.inc
	echo "#" > $@
	echo "# Automaticky generovaný" >> $@
    # not working for times between 0:00:00 and 0:59:59
	sed -e 's/DEADLINE_XML\[\([0-9]*\)\]=\([0-9]*\)-[0]*\([1-9][0-9]*\)-[0]*\([1-9][0-9]*\)T[0]*\([1-9][0-9]*\):\([0-9]*\):\([0-9]*\)/DEADLINE\[\1\]=\4.~\3.~\2 \5.\6/;s/DEADLINES_XML\[\([0-9]*\)\]=\([0-9]*\)-[0]*\([1-9][0-9]*\)-[0]*\([1-9][0-9]*\)/DEADLINES\[\1\]=\4.~\3.~\2/' $< >> $@

    

# == Author solutions ==
XELATEX_P=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\documentclass[SEM]{fkssolution}\setcounter{year}{Y}\input{$<}\begin{document}\problemsolutionsingle\makefooter\end{document}'

# Ugly but working
$(OUT)/reseni$(BATCHNO)-1.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_1)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-2.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_2)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-3.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_3)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-4.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_4)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-5.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_5)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-6.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_6)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-7.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_7)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-8.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_8)) $(SIGNATURES)
	$(XELATEX_P)
	$(XELATEX_P)

