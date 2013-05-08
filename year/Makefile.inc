# Common makefile parts

include ../Makefile.conf
include $(PROBLEMS)/Makefile.inc

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
$(plot)
$(GRAPHICS)/color/%.eps $(GRAPHICS)/color/%.tex: $(GRAPHICS)/%.plt
$(plot-color)

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

# == Results preprocessing ==
GLOB_RESULTS := ../results
$(RESULTS)/vysledky$(SOLVEDBATCHNO)-%.tex: $(GLOB_RESULTS)/vysledky.xml
xsltproc --stringparam type brojure \
--stringparam category $* \
--stringparam series $(SOLVEDBATCHNO) \
$(GLOB_RESULTS)/texresults.xsl $< >$@

$(RESULTS)/statistiky$(SOLVEDBATCHNO).csv: $(GLOB_RESULTS)/statistiky.xml
xsltproc --stringparam series $(SOLVEDBATCHNO) \
$(GLOB_RESULTS)/texstats.xsl $< >$@
# apply created results to statistics
$(STATS_SH) $(PROBLEMS) $@

$(GLOB_RESULTS)/vysledky.xml:
$(SOAPCLIENT) $(WS_URL) $(GLOB_RESULTS)/resultsRequest.soap $@

$(GLOB_RESULTS)/statistiky.xml:
$(SOAPCLIENT) $(WS_URL) $(GLOB_RESULTS)/statsRequest.soap $@

$(RESULTS)/%.tex: $(RESULTS)/%.csv
iconv -f latin2 -t utf8 $< | \
cut -d\; -f1,2,3,4,5,6,7,8,9,10,12,13,14 | \
sed '/^$$/d;/^%/d;s/;;/;--;/g;s/;;/;--;/g;s/;/ \& /g;s/$$/\\\\/' | sed -e '2i\\\\midrule'  > $@

# == Author solutions ==
XELATEX_P=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\documentclass[fykos]{fkssolution}\setcounter{year}{26}\input{$<}\begin{document}\problemsolutionsingle\makefooter\end{document}'

# Ugly but working
$(OUT)/reseni$(BATCHNO)-1.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_1))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-2.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_2))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-3.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_3))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-4.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_4))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-5.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_5))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-6.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_6))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-7.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_7))
$(XELATEX_P)
$(XELATEX_P)
$(OUT)/reseni$(BATCHNO)-8.pdf: $(addprefix $(PROBLEMS)/, $(problem$(BATCHNO)_8))
$(XELATEX_P)
$(XELATEX_P)

