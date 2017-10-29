OUT=out
TODO_SH=./todo.sh
PROBLEMS=../problems
BATCH=../batch*
LEAFLET=../leaflet*
CHECK=$(PROBLEMS)/problem*.tex $(BATCH)/serial?.tex $(BATCH)/uvod?.tex $(LEAFLET)/aktuality?.tex
SRC=$(wildcard $(CHECK))
STATS=$(OUT)/stats.csv

all: 
	$(TODO_SH) "$(CHECK)" $(OUT)/todo.tex $(STATS)
	xelatex --output-directory $(OUT) $(OUT)/todo.tex || (rm -f $@ && false)
