.SUFFIXES: .plt .tex .pdf .ctex

# epslatex output + size for two plots vertically on page
%.tex: %.plt
	gnuplot -e " \
	set format '$$\"%g\"$$' ; \
	set terminal epslatex color size 12.7cm,7.7cm; \
	set output '$@' \
	" $<

%.ctex: %.csv
	iconv -f latin2 -t utf8 $< | \
	cut -d\; -f1,2,3,4,5,6,7,8,9,10,12,13,14 | \
	sed '/^$$/d;/^%/d;s/;;/;--;/g;s/;;/;--;/g;s/;/ \& /g;s/$$/\\\\/' | sed -e '2i\\\\midrule'  > $@

%.pdf: %.tex
	xelatex $<


all: test.pdf
