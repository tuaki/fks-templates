# Makefile for contest

OUT=out
PROBLEMS=./problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems

.SUFFIXES:
.PHONY: all clean cleanall tasks solutions results


# == Main targets ==
#all: web book solutions series
all: tasks solutions results
include ../Makefile.inc
tasks: $(OUT)/zadani.pdf
solutions: $(OUT)/reseni.pdf $(OUT)/reseni-book.pdf
results: $(OUT)/vysledky.pdf
$(eval PROBS=$(addsuffix }, $(addprefix $${problem_, 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))) # :-(
PROBDEP= $(addprefix $(PROBLEMS)/, $(PROBS))
GRAPHDEP=
SERIEDEP=$(PROBDEP) $(addprefix $(GRAPHICS)/, $(GRAPHDEP)) common.tex

XELATEX_WEB=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}\input{$<}'
XELATEX_PRINT=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{print}\input{$<}'

$(OUT)/zadani.pdf: zadani.tex $(SERIEDEP)
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

$(OUT)/reseni.pdf: reseni.tex $(SERIEDEP)
	$(XELATEX_WEB)
	$(XELATEX_WEB)

XELATEX2=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}\input{$<}'
$(OUT)/reseni-print.pdf: reseni.tex $(SERIEDEP)
	$(XELATEX2)
	$(XELATEX2)

$(OUT)/reseni-book.pdf: $(OUT)/reseni-print.pdf
	pdfbook --booklet true --delta "3mm 0mm" --outfile '$@' $<

$(OUT)/vysledky.pdf: vysledky.tex $(SERIEDEP)
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

clean:
	find $(OUT) -type f -not \( -name "*.pdf" -o -name ".*" \) | xargs rm

cleanall:
	rm $(OUT)/*
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm

