BATCHNO=1
OUT=out/
PROBLEMS=../problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems
RESULTS=results

.SUFFIXES:
.PHONY: pokus

PD=$(PROBLEMS)
GD=$(PGRAPHICS)
include ../problems/Makefile.inc

# == Graphics part ==
# -- Plots --
# epslatex output + size for two plots vertically on page
gnuplot=gnuplot -e "set format '$$\"%g\"$$' ; set terminal epslatex monochrome size 12.7cm,7.7cm; set output '$@' " $<
define plot
$(gnuplot)
endef
define plot-color
$(subst monochrome,color,$(gnuplot))
endef

$(PGRAPHICS)/%.tex: $(PGRAPHICS)/%.plt
	$(plot)
$(PGRAPHICS)/color/%.tex: $(PGRAPHICS)/color/%.plt
	$(plot-color)

$(GRAPHICS)/%.tex: $(GRAPHICS)/%.plt
	$(plot)
$(GRAPHICS)/color/%.tex: $(GRAPHICS)/color/%.plt
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
$(RESULTS)/%.tex: $(RESULTS)/%.csv
	iconv -f latin2 -t utf8 $< | \
	cut -d\; -f1,2,3,4,5,6,7,8,9,10,12,13,14 | \
	sed '/^$$/d;/^%/d;s/;;/;--;/g;s/;;/;--;/g;s/;/ \& /g;s/$$/\\\\/' | sed -e '2i\\\\midrule'  > $@

%.pdf: %.tex
	xelatex $<


all: test.pdf

pokus: problem1-1

define abc =
multiline content...
a dašlí řádka
endef

abc=hovno
alles:
	echo "--$(plot)--"
	echo "--$(abc)--"
