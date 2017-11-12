# Simple recursive makefile  + Makefile for contest

SUBDIRS=leaflet 
 
OUT=out
PROBLEMS=./problems
GRAPHICS=graphics# graphics for the batch (series)
PGRAPHICS=$(PROBLEMS)/graphics# graphics for problems
ROOMS_SRC=./rooms

# constants for given year
YEAR := Y
DATE := 2017-02-17

.SUFFIXES:
.PHONY: all clean cleanall tasks solutions results anketa dep proof diplom vysledkovky fksdb-imports


# == Main targets ==
all: rules tasks solutions results anketa prezence rooms proof fksdb-imports
#all: rules tasks solutions results anketa prezence rooms proof diplom fksdb-imports
include ../Makefile.inc
include Makefile-old-graphics.inc

dep: $(PROBLEMS)/Makefile-fyz.inc
tasks: $(OUT)/zadani-obalka.pdf $(OUT)/zadani-balicek.pdf
solutions: $(OUT)/reseni.pdf $(OUT)/reseni-print.pdf
proof: $(OUT)/korektury.pdf
results: $(OUT)/vysledky.pdf
authors: $(OUT)/autori.csv
rules: $(OUT)/pravidla.pdf
anketa: $(OUT)/anketa.pdf
prezence: $(OUT)/prezence.pdf
rooms: $(OUT)/seating.pdf $(OUT)/desktops.pdf $(OUT)/routing.pdf
diplom: $(OUT)/diplom.pdf $(OUT)/diplom-jmena.pdf
vysledkovky: $(OUT)/vysledkovky.pdf
fksdb-imports: $(OUT)/tasklist.csv $(OUT)/teams.sql

$(eval PROBS=$(addsuffix }, $(addprefix $${problem_, 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68))) # :-(
PROBDEP= $(addprefix $(PROBLEMS)/, $(PROBS))
GRAPHDEP=logo-ondrasovka.pdf logo-casopis.pdf opr.eps ozn.eps neozn.eps
SERIEDEP=$(PROBDEP) $(addprefix $(GRAPHICS)/, $(GRAPHDEP)) common.tex naboj_team.tex $(PROBLEMS)/sort.tex

TEAMSCOUNT=$(shell cat naboj_team.tex | wc -l)
TEAMSEXTRA=0
TEAMSCOUNT=1 # DELETE ONLY FOR PRINTING!

XELATEX_WEB=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{web}\input{$<}' || (rm -f $@ && false)
XELATEX_PRINT=xelatex -output-directory $(@D) -jobname $(basename $(@F)) '\def\UseOption{print}\def\teamscount{$(TEAMSCOUNT)}\input{$<}' || (rm -f $@ && false)

# TODO { and }
TEX_ESCAPE=sed 's/{\(.\+\)\\/{\1\\textbackslash/' | sed 's/\([\#%&$$_]\)/\\\1/' | sed 's/~/\\textasciitilde/' | sed 's/\^/\\textasciicircum/'
# TODO ugly thing, gets rid of problematic unicode characters
UNICODE_ESCAPE=sed 's/α/$$\\alpha$$/' | sed 's/π/$$\\pi$$/' | sed 's/∨/$$\\vee$$/'

$(PROBLEMS)/Makefile-fyz.inc: $(OUT)/Makefile-fyz.inc
	cp $< $@

$(OUT)/Makefile-fyz.inc: $(PROBLEMS)/problem-sort.tex poradi_uloh.tex
	xelatex -output-directory $(OUT) poradi_uloh.tex

$(OUT)/sort.tex:
	echo "Run \"make dep\" first for make dependencies!"
	pause

$(PROBLEMS)/sort.tex: $(OUT)/sort.tex
	cp $< $@

XELATEXZO=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\UseOption{print,obalka}\def\teamscount{$(TEAMSCOUNT)}\input{$<}' || (rm -f $@ && false)
$(OUT)/zadani-obalka.pdf: zadani.tex $(SERIEDEP)
	$(XELATEXZO)
	$(XELATEXZO)

XELATEXZB=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\UseOption{print,balicek}\def\teamscount{$(TEAMSCOUNT)}\input{$<}' || (rm -f $@ && false)
$(OUT)/zadani-balicek.pdf: zadani.tex $(SERIEDEP)
	$(XELATEXZB)
	$(XELATEXZB)

$(OUT)/reseni.pdf: reseni.tex $(SERIEDEP)
	$(XELATEX_WEB)
	$(XELATEX_WEB)

$(OUT)/korektury.pdf: korektury.tex $(SERIEDEP)
	$(XELATEX_WEB)
	$(XELATEX_WEB)
	
$(OUT)/anketa.pdf: anketa.tex $(SERIEDEP) naboj_team.tex
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

$(OUT)/prezence.pdf: prezence.tex teams.tex
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

XELATEX2=xelatex -output-directory $(@D) -jobname '$(basename $(@F))' '\def\classoptions{twoside}\def\UseOption{print}\input{$<}' || (rm -f $@ && false)
$(OUT)/reseni-print.pdf: reseni.tex $(SERIEDEP)
	$(XELATEX2)
	$(XELATEX2)

$(OUT)/vysledky.pdf: vysledky.tex $(SERIEDEP)
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

$(OUT)/autori.csv: autori.tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<

$(OUT)/pravidla.pdf: pravidla.tex $(SERIEDEP)
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

naboj_team.tex: naboj_team.csv Makefile
	sed 's/\r$$//' $< | sort -t";" -k 1n | awk -F";" '($$4=="approved") {maxId=$$1; print "\\newteam{"$$1"}{"$$3"}"} END {for(j=1;j<=$(TEAMSEXTRA);j++) print "\\newteam{"maxId + j"}{NÁHRADNÍCI "j"}"} ' | $(TEX_ESCAPE) | $(UNICODE_ESCAPE) >$@

naboj_team.csv: teams.xml Makefile
	xsltproc naboj_team.xsl $< >$@
	
clean:
	find $(OUT) -type f -not \( -name "*.pdf" -o -name ".*" \) | xargs rm

cleanall:
	rm -f $(OUT)/*
	rm -f teams.xml teams.tex naboj_team.csv naboj_team.tex
	rm -f $(PROBLEMS)/Makefile-fyz.inc $(PROBLEMS)/sort.tex
#	ls $(GRAPHICS) $(PGRAPHICS) | grep -v '\(mp\|plt\|eps\|jpg\|png\)$$' | xargs rm

# == Rooms ==
$(OUT)/%.pdf: $(ROOMS_SRC)/%.tex $(ROOMS_SRC)/*.tex teams.tex
	$(XELATEX_PRINT)
	$(XELATEX_PRINT)

# byproduct
$(OUT)/teams.csv: $(OUT)/routing.pdf

# == FKSDB cooperation == 
$(OUT)/teams.sql: $(OUT)/teams.csv
	sed -e 's/^\([0-9]\+\);\(.\+\)$$/UPDATE `e_fyziklani_team` SET `room`="\2" WHERE `e_fyziklani_team_id`=\1;/' $< >$@

$(OUT)/tasklist.csv: tasklist.tex $(SERIEDEP)
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<

teams.tex: teams.xml teams.xsl
	xsltproc teams.xsl $< | $(TEX_ESCAPE) | $(UNICODE_ESCAPE) >$@

teams-%.tex: teams.xml teams.xsl
	xsltproc --stringparam location "$*" teams.xsl $< | $(TEX_ESCAPE) | $(UNICODE_ESCAPE) >$@

teams.xml:
	$(SOAPCLIENT) $(WS_URL) teamsRequest.soap $@ $(shell echo $(WS_USERNAME) | base64) $(shell echo $(WS_PASSWORD) | base64)

# == diplomy ==
diplomy/diplomy.xml: diplomy/diplomyRequest.soap
	$(call SOAP_REQUEST,$<,$@)

diplomy/list.csv: diplomy/diplomy.xml diplomy/makeCSV.py
	python3 diplomy/makeCSV.py -y $(YEAR) -d $(DATE) -I $< -O $@ diplom

$(OUT)/diplom.pdf: diplomy/diplom.tex diplomy/fs.pdf diplomy/list.csv diplomy/logotyp_fakulty3.eps diplomy/logotyp_fakulty4.eps
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<

$(OUT)/diplom-jmena.pdf: diplomy/diplom-jmena.tex diplomy/fs.pdf diplomy/list.csv diplomy/logotyp_fakulty3.eps diplomy/logotyp_fakulty4.eps
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<

vysledkovky/cat%.xml: vysledkovky/cat%Request.soap
	$(call SOAP_REQUEST,$<,$@)

# explicit mention of dependencies
vysledkovky/catA.xml: vysledkovky/catARequest.soap
vysledkovky/catB.xml: vysledkovky/catBRequest.soap
vysledkovky/catC.xml: vysledkovky/catCRequest.soap

vysledkovky/list-%.csv: vysledkovky/cat%.xml $(XSL_CSV)
	xsltproc $(XSL_CSV) $< >$@

$(OUT)/vysledkovky.pdf: vysledkovky/vysledkovky.tex vysledkovky/logotyp_fakulty3.eps vysledkovky/data.csv vysledkovky/list-A.csv vysledkovky/list-B.csv vysledkovky/list-C.csv
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<
	xelatex -output-directory $(@D) -jobname $(basename $(@F)) $<

# == recursive ==
subdirs:
	for dir in $(SUBDIRS); do \
	make -C $$dir ; done
