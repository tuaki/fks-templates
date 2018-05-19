# Common makefile parts
# vim: syn=make


# additional graphical dependence must be before 'include $(PROBLEMS)/Makefile.inc'
define addgraphdep
$(foreach col,/ /color/,$(foreach ext,eps png pdf svg,$(call addgraphdepextcol,$(1),$(2),$(ext),$(col))))
endef

define addgraphdepextcol
$(eval $(PGRAPHICS)$(4)$(1).$(3): $(PGRAPHICS)/$(2))
endef

include ../Makefile.conf
include $(PROBLEMS)/Makefile.inc
include ../Deadline.inc
include ../Deadline_xml.inc

# == Graphics part ==

# -- Metapost figures --
define Smp2eps
	cd $(@D); mpost -jobname=$(subst .src.mp,,$(<F)) -s 'outputtemplate="%j.%o"' $(<F)
endef
define Smp2svg
	cd $(@D); mpost -jobname=$(subst .src.mp,,$(<F)) -s 'outputtemplate="%j.%o"' -s 'outputformat="svg"' $(<F)
endef

# -- IPE figures --
define Sipe2eps
	iperender -eps $< $@
endef
define Sipe2svg
	iperender -svg $< $@
endef
define Sipe2pdf
	iperender -pdf $< $@
endef

# -- Gnuplot figures --
gnuplot=gnuplot -e "set format '$$\"%g\"$$' ; set terminal epslatex monochrome size 12.7cm,7.7cm; set output '$(@F)' " $(<F)
define plot
$(gnuplot)
endef
define plot-color
$(subst output ', output 'color/, $(subst monochrome,color,$(gnuplot)))
endef

define Splt2epstex
	cd $(<D); $(plot)
endef
define Splt2epstexC
	cd $(<D); $(plot-color)
endef

# -- EPS figures --
define eps2pdf
	epstopdf $<
endef
define Seps2pdf
	epstopdf $< --outfile=$(subst .src.eps,.pdf,$(<))
endef
define Seps2svg
	inkscape $< -l $@
endef

# -- PDF figures --
define pdf2svg
	inkscape -l $@ $<
endef

# -- SVG figures --
define Ssvg2eps
	$(svg2eps)
endef
define svg2eps
	inkscape $< -E $@ --export-ignore-filters
endef
define Ssvg2pdf
	inkscape $< --export-pdf=$@
endef

# -- direct output --
define Sx2x
	cp $< $@
endef

# -- PNG output from EPS --
$(PGRAPHICS)/%.png: $(PGRAPHICS)/%.eps
	convert $< -density 600 $@
$(GRAPHICS)/%.png: $(GRAPHICS)/%.eps
	convert $< -density 600 $@

# -- color from nocolor --
$(PGRAPHICS)/color/%.eps: $(PGRAPHICS)/%.eps
	cp $< $@
$(GRAPHICS)/color/%.eps: $(GRAPHICS)/%.eps
	cp $< $@
$(PGRAPHICS)/color/%.svg: $(PGRAPHICS)/%.svg
	cp $< $@
$(GRAPHICS)/color/%.svg: $(GRAPHICS)/%.svg
	cp $< $@
$(PGRAPHICS)/color/%.png: $(PGRAPHICS)/%.png
	cp $< $@
$(GRAPHICS)/color/%.png: $(GRAPHICS)/%.png
	cp $< $@
$(PGRAPHICS)/color/%.pdf: $(PGRAPHICS)/%.pdf
	cp $< $@
$(GRAPHICS)/color/%.pdf: $(GRAPHICS)/%.pdf
	cp $< $@
$(PGRAPHICS)/color/%.jpg: $(PGRAPHICS)/%.jpg
	cp $< $@
$(GRAPHICS)/color/%.jpg: $(GRAPHICS)/%.jpg
	cp $< $@
$(PGRAPHICS)/color/%.jpeg: $(PGRAPHICS)/%.jpeg
	cp $< $@
$(GRAPHICS)/color/%.jpeg: $(GRAPHICS)/%.jpeg
	cp $< $@


# -- batch graphics old version
$(GRAPHICS)/%.eps $(GRAPHICS)/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot)
$(GRAPHICS)/color/%.eps $(GRAPHICS)/color/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot-color)
$(GRAPHICS)/%.eps : $(GRAPHICS)/%.mp
	cd $(@D); mpost -s 'outputtemplate="%j.%o"' $(<F)
$(GRAPHICS)/%.eps : $(GRAPHICS)/%.ipe
	iperender -eps $< $@


# == Graphics dependence ==
    
    
$(PROBLEMS)/Makefile.inc: $(PROBLEMS)/Makefile-manual.inc  $(PROBLEMS)/Makefile-problems.inc $(PROBLEMS)/Makefile-graphics.inc
	@echo 'include $(PROBLEMS)/Makefile-manual.inc\n' >  $@
	@echo 'include $(PROBLEMS)/Makefile-problems.inc\n' >> $@
	@echo 'include $(PROBLEMS)/Makefile-graphics.inc\n' >> $@

pgraphdep=\
    $(wildcard $(PGRAPHICS)/*.src.mp)   \
    $(wildcard $(PGRAPHICS)/*.src.plt)  \
    $(wildcard $(PGRAPHICS)/*.src.dat)  \
    $(wildcard $(PGRAPHICS)/*.src.ipe)  \
    $(wildcard $(PGRAPHICS)/*.src.pdf)  \
    $(wildcard $(PGRAPHICS)/*.src.jpg)  \
    $(wildcard $(PGRAPHICS)/*.src.jpeg) \
    $(wildcard $(PGRAPHICS)/*.src.svg)  \
    $(wildcard $(PGRAPHICS)/*.src.eps)

$(PROBLEMS)/Makefile-problems.inc: $(pgraphdep)
	@echo -n '# problems dependence\n\n' > $@
	for b in `seq 1 10`; do \
        for t in `seq 1 100`; do \
            ls $(PGRAPHICS)/*"$$b"-"$$t"*.src.* > /dev/null 2>&1 || \
            ls $(PROBLEMS)/problem$$b"-"$$t.tex > /dev/null 2>&1 || continue; \
            echo -n "problem"$$b"_"$$t'= $$(man_problem'$$b"_"$$t") problem"$$b"-"$$t".tex " >> $@; \
            for type in problem ilu; do \
                for exti in mp plt ipe pdf jpg jpeg svg eps; do \
                    ls $(PGRAPHICS)/$$type"$$b"-"$$t"_*.src.$$exti > /dev/null 2>&1 && \
                    for file in $(PGRAPHICS)/$$type"$$b"-"$$t"_*.src.$$exti; do \
                        file=` echo $$file | sed 's|\.src||'`; \
                        file=` echo $$file | sed 's|$(PROBLEMS)/||'`; \
                        filec=`dirname $$file`"/color/"`basename $$file`;  \
                        for exto in eps svg png tex pdf jpg jpeg; do \
                            if [ "$$exti"  = "jpg"    ] && [ "$$exto" != "jpg"  ] ; then continue; fi; \
                            if [ "$$exti"  = "jpeg"   ] && [ "$$exto" != "jpeg" ] ; then continue; fi; \
                            if [ "$$exti" != "jpg"    ] && [ "$$exto"  = "jpg"  ] ; then continue; fi; \
                            if [ "$$exti" != "jpeg"   ] && [ "$$exto"  = "jpeg" ] ; then continue; fi; \
                            if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "mp"   ] ; then continue; fi; \
                            if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "ipe"  ] ; then continue; fi; \
                            if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "plt"  ] ; then continue; fi; \
                            if [ "$$exti" != "plt"    ] && [ "$$exto"  = "tex"  ] ; then continue; fi; \
                            if [ "$$exti"  = "plt"    ] && [ "$$exto" != "tex"  ] && [ "$$exto" != "eps" ] ; then continue; fi; \
                            echo -n $$file  | sed 's|\.'"$$exti"'$$|'".$$exto |" >> $@; \
                            echo -n $$filec | sed 's|\.'"$$exti"'$$|'".$$exto |" >> $@; \
                        done; \
                    done; \
                done; \
            done; \
            echo "" >> $@; \
        done; \
        echo "" >> $@; \
    done || /bin/true

$(PROBLEMS)/Makefile-graphics.inc: $(pgraphdep)
	@echo -n '# graphics dependence\n\n' > $@
	for b in `seq 1 10`; do \
        ls $(PGRAPHICS)/*"$$b"-*.src.* > /dev/null 2>&1 && \
        echo "\n####################################################" >> $@ && \
        echo "#################### problem$$b-* ####################" >> $@ && \
        echo "####################################################" >> $@; \
        for t in `seq 1 100`; do \
            ls $(PGRAPHICS)/*"$$b"-"$$t"_*.src.* > /dev/null 2>&1 && \
            echo "#################### problem$$b-$$t ####################" >> $@; \
            for type in problem ilu; do \
                ls $(PGRAPHICS)/$$type"$$b"-"$$t"_*.src.* > /dev/null 2>&1 && \
                for file in $(PGRAPHICS)/$$type"$$b"-"$$t"_*.src.*; do \
                    ext=`echo $$file | sed 's/.*\.//'`; \
                    fileb=`basename $$file`; \
                    case $$ext in \
                      (mp) \
                        out=`echo $$fileb | sed 's/\.src\.mp/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Smp2eps)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.mp/.svg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Smp2svg)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.mp/.pdf/'`; \
                        in=` echo $$fileb | sed 's/\.src\.mp/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$in >> $@; \
                        echo '\t$$(eps2pdf)' >> $@; \
                      ;; \
                      (ipe) \
                        out=`echo $$fileb | sed 's/\.src\.ipe/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sipe2eps)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.ipe/.svg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sipe2svg)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.ipe/.pdf/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sipe2pdf)' >> $@; \
                      ;; \
                      (plt) \
                        outA=`echo $$fileb | sed 's/\.src\.plt/.tex/'`; \
                        outB=`echo $$fileb | sed 's/\.src\.plt/.eps/'`; \
                        dep=`ls $(PGRAPHICS)/$$type"$$b"-"$$t"_*.src.dat 2> /dev/null` || dep=''; \
                        echo '$$(PGRAPHICS)/'$$outA '$$(PGRAPHICS)/'$$outB": "'$$(PGRAPHICS)/'$$fileb $$dep >> $@; \
                        echo '\t$$(Splt2epstex)' >> $@; \
                        echo '$$(PGRAPHICS)/color/'$$outA '$$(PGRAPHICS)/color/'$$outB": "'$$(PGRAPHICS)/'$$fileb $$dep >> $@; \
                        echo '\t$$(Splt2epstexC)' >> $@; \
                      ;;\
                     (pdf) \
                        out=`echo $$fileb | sed 's/\.src\.pdf/.pdf/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sx2x)' >> $@; \
                        \
                        in=` echo $$fileb | sed 's/\.src\.pdf/.pdf/'`; \
                        out=`echo $$fileb | sed 's/\.src\.pdf/.svg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$in >> $@; \
                        echo '\t$$(pdf2svg)' >> $@; \
                        \
                        in=` echo $$fileb | sed 's/\.src\.pdf/.svg/'`; \
                        out=`echo $$fileb | sed 's/\.src\.pdf/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$in >> $@; \
                        echo '\t$$(svg2eps)' >> $@; \
                      ;;\
                      (svg) \
                        out=`echo $$fileb | sed 's/\.src\.svg/.svg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sx2x)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.svg/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Ssvg2eps)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.svg/.pdf/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Ssvg2pdf)' >> $@; \
                      ;;\
                      (eps) \
                        out=`echo $$fileb | sed 's/\.src\.eps/.eps/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sx2x)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.eps/.pdf/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Seps2pdf)' >> $@; \
                        \
                        out=`echo $$fileb | sed 's/\.src\.eps/.svg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Seps2svg)' >> $@; \
                      ;; \
                      (jpg) \
                        out=`echo $$fileb | sed 's/\.src\.jpg/.jpg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sx2x)' >> $@; \
                      ;;\
                      (jpeg) \
                        out=`echo $$fileb | sed 's/\.src\.jpeg/.jpeg/'`; \
                        echo '$$(PGRAPHICS)/'$$out": "'$$(PGRAPHICS)/'$$fileb >> $@; \
                        echo '\t$$(Sx2x)' >> $@; \
                      ;;\
                    esac \
                done; \
            done; \
        done; \
    done || /bin/true

graphdep=\
    $(wildcard $(GRAPHICS)/*.src.mp)   \
    $(wildcard $(GRAPHICS)/*.src.plt)  \
    $(wildcard $(GRAPHICS)/*.src.dat)  \
    $(wildcard $(GRAPHICS)/*.src.ipe)  \
    $(wildcard $(GRAPHICS)/*.src.pdf)  \
    $(wildcard $(GRAPHICS)/*.src.jpg)  \
    $(wildcard $(GRAPHICS)/*.src.jpeg) \
    $(wildcard $(GRAPHICS)/*.src.svg)  \
    $(wildcard $(GRAPHICS)/*.src.eps)

# batch graphics dependencies
Makefile-graphics.inc: $(graphdep)
	@echo -n '# graphics dependence\n\n' > $@
	echo -n 'GRAPHDEP= $$(GRAPHDEP_MANUAL) ' >> $@; \
        for exti in mp plt ipe pdf jpg jpeg svg eps; do \
            ls $(GRAPHICS)/*.src.$$exti > /dev/null 2>&1 && \
            for file in $(GRAPHICS)/*.src.$$exti; do \
                file=` basename $$file | sed 's|\.src||'`; \
                filec="color/"$$file;  \
                for exto in eps svg png tex pdf jpg jpeg; do \
                    if [ "$$exti"  = "jpg"    ] && [ "$$exto" != "jpg"  ] ; then continue; fi; \
                    if [ "$$exti"  = "jpeg"   ] && [ "$$exto" != "jpeg" ] ; then continue; fi; \
                    if [ "$$exti" != "jpg"    ] && [ "$$exto"  = "jpg"  ] ; then continue; fi; \
                    if [ "$$exti" != "jpeg"   ] && [ "$$exto"  = "jpeg" ] ; then continue; fi; \
                    if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "mp"   ] ; then continue; fi; \
                    if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "ipe"  ] ; then continue; fi; \
                    if [ "$$exti"  = "$$exto" ] && [ "$$exti"  = "plt"  ] ; then continue; fi; \
                    if [ "$$exti" != "plt"    ] && [ "$$exto"  = "tex"  ] ; then continue; fi; \
                    if [ "$$exti"  = "plt"    ] && [ "$$exto" != "tex"  ] && [ "$$exto" != "eps" ] ; then continue; fi; \
                    echo -n $$file  | sed 's|\.'"$$exti"'$$|'".$$exto |" >> $@; \
                    echo -n $$filec | sed 's|\.'"$$exti"'$$|'".$$exto |" >> $@; \
                done; \
            done; \
        done || /bin/true
	@echo -n '\n\n# graphics source files dependence\n\n' >> $@
	ls $(GRAPHICS)/*.src.* > /dev/null 2>&1 && \
        for file in $(GRAPHICS)/*.src.*; do \
            ext=`echo $$file | sed 's/.*\.//'`; \
            fileb=`basename $$file`; \
            case $$ext in \
              (mp) \
                out=`echo $$fileb | sed 's/\.src\.mp/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Smp2eps)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.mp/.svg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Smp2svg)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.mp/.pdf/'`; \
                in=` echo $$fileb | sed 's/\.src\.mp/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$in >> $@; \
                echo '\t$$(eps2pdf)' >> $@; \
              ;; \
              (ipe) \
                out=`echo $$fileb | sed 's/\.src\.ipe/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sipe2eps)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.ipe/.svg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sipe2svg)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.ipe/.pdf/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sipe2pdf)' >> $@; \
              ;; \
              (plt) \
                outA=`echo $$fileb | sed 's/\.src\.plt/.tex/'`; \
                outB=`echo $$fileb | sed 's/\.src\.plt/.eps/'`; \
                dep=`ls $(GRAPHICS)/*.src.dat 2> /dev/null` || dep=''; \
                echo '$$(GRAPHICS)/'$$outA '$$(GRAPHICS)/'$$outB": "'$$(GRAPHICS)/'$$fileb $$dep >> $@; \
                echo '\t$$(Splt2epstex)' >> $@; \
                echo '$$(GRAPHICS)/color/'$$outA '$$(GRAPHICS)/color/'$$outB": "'$$(GRAPHICS)/'$$fileb $$dep >> $@; \
                echo '\t$$(Splt2epstexC)' >> $@; \
              ;;\
              (pdf) \
                out=`echo $$fileb | sed 's/\.src\.pdf/.pdf/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sx2x)' >> $@; \
                \
                in=` echo $$fileb | sed 's/\.src\.pdf/.pdf/'`; \
                out=`echo $$fileb | sed 's/\.src\.pdf/.svg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$in >> $@; \
                echo '\t$$(pdf2svg)' >> $@; \
                \
                in=` echo $$fileb | sed 's/\.src\.pdf/.svg/'`; \
                out=`echo $$fileb | sed 's/\.src\.pdf/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$in >> $@; \
                echo '\t$$(svg2eps)' >> $@; \
              ;;\
              (svg) \
                out=`echo $$fileb | sed 's/\.src\.svg/.svg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sx2x)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.svg/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Ssvg2eps)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.svg/.pdf/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Ssvg2pdf)' >> $@; \
              ;;\
              (eps) \
                out=`echo $$fileb | sed 's/\.src\.eps/.eps/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sx2x)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.eps/.pdf/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Seps2pdf)' >> $@; \
                \
                out=`echo $$fileb | sed 's/\.src\.eps/.svg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Seps2svg)' >> $@; \
              ;; \
              (jpg) \
                out=`echo $$fileb | sed 's/\.src\.jpg/.jpg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sx2x)' >> $@; \
              ;;\
              (jpeg) \
                out=`echo $$fileb | sed 's/\.src\.jpeg/.jpeg/'`; \
                echo '$$(GRAPHICS)/'$$out": "'$$(GRAPHICS)/'$$fileb >> $@; \
                echo '\t$$(Sx2x)' >> $@; \
              ;;\
            esac \
        done || /bin/true
    
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

