# Makefile for single batch

BATCHNO=B
SOLVEDBATCHNO=AB
RESULTSLIST=resultslist
PROBLEMSLIST=problemslist
OUT=out
PROBLEMS=../problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems
RESULTS=results

ARG=\def\mdeadline{${DEADLINE[${BATCHNO}]}}\def\mdeadlineS{${DEADLINES[${BATCHNO}]}}
ARG_XML=\def\mdeadline{${DEADLINE_XML[${BATCHNO}]}}\def\mdeadlineS{${DEADLINES_XML[${BATCHNO}]}}

.SUFFIXES:
.PHONY: all clean cleanall web book print solutions problems series

# == Main targets ==
all: web print solutions series
include ../Makefile.inc
web: $(OUT)/serie$(BATCHNO).pdf $(OUT)/zadaniWeb$(BATCHNO)-cs.xml $(OUT)/zadaniWeb$(BATCHNO)-en.xml $(OUT)/zadaniWeb$(BATCHNO)-new.xml $(OUT)/zadani$(BATCHNO).pdf
book: $(OUT)/serie$(BATCHNO)-book.pdf
print: $(OUT)/serie$(BATCHNO)-print.pdf
solutions: $(addsuffix .pdf, $(addprefix $(OUT)/reseni$(BATCHNO)-, $(PROBLEMSLIST)))
series: $(OUT)/serial$(BATCHNO).pdf 
$(eval PROBS=$(addprefix $${problem,$(addsuffix },$(foreach foo,$(SOLVEDBATCHNO) $(BATCHNO),$(addprefix $(foo)_,$(PROBLEMSLIST))))))
PROBDEP= $(addprefix $(PROBLEMS)/, $(PROBS))

# == graphics dependence ==
GRAPHDEP_MANUAL=
include Makefile-graphics.inc #has to be after GRAPHDEP_MANUAL, defines GRAPHDEP

#SERIEDEP=$(PROBDEP) uvod$(BATCHNO).tex serial$(BATCHNO).tex $(addprefix $(GRAPHICS)/, $(GRAPHDEP)) ../Deadline.inc
# Use variant below when Astrid supports xsltproc.
SERIEDEP=$(PROBDEP) uvod$(BATCHNO).tex serial$(BATCHNO).tex problems$(BATCHNO).tex $(SIGNATURES) \
	$(addprefix $(GRAPHICS)/, $(GRAPHDEP)) \
	$(addprefix $(RESULTS)/vysledky, $(addsuffix .tex,$(foreach foo,$(SOLVEDBATCHNO),$(addprefix $(foo)-,$(RESULTSLIST)))))\
	$(foreach foo,$(SOLVEDBATCHNO),$(addprefix $(addprefix $(RESULTS)/statistiky,$(foo)),.csv))\
	../Deadline.inc


XELATEX_Z=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}$(ARG)\input{$<}' || (rm -f $@ && false)
$(OUT)/zadani$(BATCHNO).pdf: problems$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX_Z)
	$(XELATEX_Z)

XELATEX=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}$(ARG)\input{$<}' || (rm -f $@ && false)
$(OUT)/serie$(BATCHNO).pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX)
	$(XELATEX)

XELATEX2=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}$(ARG)\input{$<}' || (rm -f $@ && false)
$(OUT)/serie$(BATCHNO)-print.pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX2)
	$(XELATEX2)

$(OUT)/serie$(BATCHNO)-book.pdf: $(OUT)/serie$(BATCHNO)-print.pdf
	pdfbook --booklet true --outfile '$@' $<

XELATEX_S=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\documentclass[SEM]{fksseries}\setcounter{year}{Y}\setcounter{batch}{$(BATCHNO)}\begin{document}\input{$<}\par\makefooter\end{document}' || (rm -f $@ && false)
$(OUT)/serial$(BATCHNO).pdf: serial$(BATCHNO).tex $(addprefix $(GRAPHICS)/, $(GRAPHDEP)) $(SIGNATURES)
	$(XELATEX_S)
	$(XELATEX_S)

clean:
	find $(OUT) -type f -not \( -name "*.pdf" -o -name ".*" \) | xargs rm

cleanall:
	rm $(OUT)/*
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm


# == XML for web transport ==

define XML_DEFS_LEGACY
\def\batchno{$(BATCHNO)}\
\def\problemcount{PB}\
$(ARG)
endef

define XML_DEFS
\def\batchno{$(BATCHNO)}\
\def\problemcount{PB}\
$(ARG_XML)
endef

$(OUT)/zadaniWeb$(BATCHNO)-cs.xml: $(PROBLEMS)/web.tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '$(XML_DEFS_LEGACY)\def\lang{cs}\input{$<}'

$(OUT)/zadaniWeb$(BATCHNO)-en.xml: $(PROBLEMS)/web.tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '$(XML_DEFS_LEGACY)\def\lang{en}\input{$<}'
$(OUT)/zadaniWeb$(BATCHNO)-new.xml: $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '$(XML_DEFS)\documentclass[fykos]{fksbase}\setcounter{year}{Y}\input{fks-web-xml}'
	fks-web-xml.sh $@ > $@.tmp
	cat $@.tmp | tr -d '\n' | sed 's/<\(.*\)>\s*<\/\1>//g' > $@
	rm -f $@.tmp
