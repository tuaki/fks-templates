# Makefile for single batch

BATCHNO=B
SOLVEDBATCHNO=BB
OUT=out
PROBLEMS=../problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems
RESULTS=results

.SUFFIXES:
.PHONY: all clean cleanall web book solutions problems


# == Main targets ==
all: web book solutions
include ../Makefile.inc
web: $(OUT)/serie$(BATCHNO).pdf
book: $(OUT)/serie$(BATCHNO)-book.pdf
solutions: $(addsuffix .pdf, $(addprefix $(OUT)/reseni$(BATCHNO)-, 1 2 3 4 5 6 7 8))
$(eval PROBS=$(addsuffix }, $(addprefix $${problem$(BATCHNO)_, 1 2 3 4 5 6 7 8) $(addprefix $${problem$(SOLVEDBATCHNO)_, 1 2 3 4 5 6 7 8)))
PROBDEP= $(addprefix $(PROBLEMS)/, $(PROBS))
GRAPHDEP=
SERIEDEP=$(PROBDEP) uvod$(BATCHNO).tex serial$(BATCHNO).tex $(addprefix $(GRAPHICS)/, $(GRAPHDEP)) $(RESULTS)/vysledky1.tex

XELATEX=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}\input{$<}'
$(OUT)/serie$(BATCHNO).pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX)
	$(XELATEX)

XELATEX2=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}\input{$<}'
$(OUT)/serie$(BATCHNO)-print.pdf: batch$(BATCHNO).tex $(SERIEDEP)
	$(XELATEX2)
	$(XELATEX2)

$(OUT)/serie$(BATCHNO)-book.pdf: $(OUT)/serie$(BATCHNO)-print.pdf
	pdfbook --booklet true --outfile '$@' $<

clean:
	find $(OUT) -type f -not \( -name "*.pdf" -o -name ".*" \) | xargs rm

cleanall:
	rm $(OUT)/*
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm

