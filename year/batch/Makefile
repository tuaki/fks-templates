# Makefile for single batch

BATCHNO=B
OUT=out
PROBLEMS=../problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems
RESULTS=results

.SUFFIXES:
.PHONY: all clean fullclean web book solutions problems

include ../Makefile.inc

# == Main targets ==
web: $(OUT)/serie$(BATCHNO).pdf
book: $(OUT)/serie$(BATCHNO)-book.pdf
solutions: $(addsuffix .pdf, $(addprefix $(OUT)/reseni$(BATCHNO)-, 1 2 3 4 5 6 7 8))
problems: $(addprefix problem$(BATCHNO)-, 1 2 3 4 5 6 7 8)

SERIEDEP=problems uvod$(BATCHNO).tex serial$(BATCHNO).tex $(RESULTS)/vysledky1.tex

$(OUT)/serie$(BATCHNO).pdf: batch$(BATCHNO).tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}\input{$<}'
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}\input{$<}' 2>/dev/null
$(OUT)/serie$(BATCHNO)-print.pdf: batch$(BATCHNO).tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}\input{$<}'
	xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}\input{$<}' 2>/dev/null
$(OUT)/serie$(BATCHNO)-book.pdf: $(OUT)/serie$(BATCHNO)-print.pdf
	pdfbook --outfile '$@' $<

$(OUT)/reseni$(BATCHNO)-%.pdf: problem$(BATCHNO)-%
	xelatex -output-directory $(@D) -jobname $(@F) '\def\UseOption{print}\input{$<}'#TODO
	xelatex -output-directory $(@D) -jobname $(@F) '\def\UseOption{print}\input{$<}' 2>/dev/null#TODO

all: web book solutions

clean:
	ls $(OUT) | grep -v '\.pdf$$' | xargs rm

fullclean:
	rm $(OUT)/*
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm


