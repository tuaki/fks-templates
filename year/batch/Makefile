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

ARG=\def\mdeadline{${DEADLINE[B]}}\def\mdeadlineS{${DEADLINES[B]}}

.SUFFIXES:
.PHONY: all clean cleanall web book solutions problems series

# == Main targets ==
all: web book solutions series
include ../Makefile.inc
web: $(OUT)/serie$(BATCHNO).pdf $(OUT)/zadaniWeb$(BATCHNO).xml $(OUT)/zadani$(BATCHNO).pdf
book: $(OUT)/serie$(BATCHNO)-book.pdf
solutions: $(addsuffix .pdf, $(addprefix $(OUT)/reseni$(BATCHNO)-, $PROBLEMSLIST))
series: $(OUT)/serial$(BATCHNO).pdf 
$(eval PROBS=$(addprefix $${problem,$(addsuffix },$(foreach foo,$(SOLVEDBATCHNO) $(BATCHNO),$(addprefix $(foo)_,$(PROBLEMSLIST))))))
PROBDEP= $(addprefix $(PROBLEMS)/, $(PROBS))
GRAPHDEP=
#SERIEDEP=$(PROBDEP) uvod$(BATCHNO).tex serial$(BATCHNO).tex $(addprefix $(GRAPHICS)/, $(GRAPHDEP))
# Use variant below when Astrid supports xsltproc.
SERIEDEP=$(PROBDEP) uvod$(BATCHNO).tex serial$(BATCHNO).tex problems$(BATCHNO).tex \
	$(addprefix $(GRAPHICS)/, $(GRAPHDEP)) \
	$(addprefix $(RESULTS)/vysledky, $(addsuffix .tex,$(foreach foo,$(SOLVEDBATCHNO),$(addprefix $(foo)-,$(RESULTSLIST)))))\
	$(foreach foo,$(SOLVEDBATCHNO),$(addprefix $(addprefix $(RESULTS)/statistiky,$(foo)),.csv))


XELATEX_Z=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}$(ARG)\input{$<}'
$(OUT)/zadani$(BATCHNO).pdf: problems$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX_Z)
	$(XELATEX_Z)

XELATEX=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}$(ARG)\input{$<}'
$(OUT)/serie$(BATCHNO).pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX)
	$(XELATEX)

XELATEX2=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}$(ARG)\input{$<}'
$(OUT)/serie$(BATCHNO)-print.pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX2)
	$(XELATEX2)

$(OUT)/serie$(BATCHNO)-book.pdf: $(OUT)/serie$(BATCHNO)-print.pdf
	pdfbook --booklet true --outfile '$@' $<

XELATEX_S=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\documentclass[SEM]{fksseries}\setcounter{year}{Y}\setcounter{batch}{$(BATCHNO)}\begin{document}\input{$<}\par\makefooter\end{document}'
$(OUT)/serial$(BATCHNO).pdf: serial$(BATCHNO).tex $(addprefix $(GRAPHICS)/, $(GRAPHDEP))
	$(XELATEX_S)
	$(XELATEX_S)

clean:
	find $(OUT) -type f -not \( -name "*.pdf" -o -name ".*" \) | xargs rm

cleanall:
	rm $(OUT)/*
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm


# == XML for web transport ==

define XML_DEFS
\def\batchno{$(BATCHNO)}\
\def\problemcount{PB}\
$(ARG)
endef

$(OUT)/zadaniWeb$(BATCHNO).xml: $(PROBLEMS)/web.tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '$(XML_DEFS)\input{$<}'

