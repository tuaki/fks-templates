

OUT=out
TODO_SH=./todo.sh
WEB_UPLOAD=web-upload.inc
PROBLEMS=../problems
BATCH=../batch*
LEAFLET=../leaflet*
CHECK=$(PROBLEMS)/problem*.tex $(BATCH)/serial?.tex $(BATCH)/uvod?.tex $(LEAFLET)/aktuality?.tex
SRC=$(wildcard $(CHECK))


all: $(OUT)/todo.pdf

$(OUT)/todo.pdf: $(OUT)/todo.tex
	xelatex --output-directory $(OUT) $(OUT)/todo.tex || (rm -f $@ && false)

$(OUT)/todo.tex: $(SRC) $(WEB_UPLOAD)
	$(TODO_SH) "$(CHECK)" $(OUT)/todo.tex $(WEB_UPLOAD)
