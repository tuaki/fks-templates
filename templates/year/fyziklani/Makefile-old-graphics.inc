# Common makefile parts
# vim: syn=make

# == Graphics part ==
# -- Plots --
# epslatex output + size for two plots vertically on page
gnuplot=gnuplot -e "set format '$$\"%g\"$$' ; set terminal epslatex monochrome size 12.7cm,7.7cm; set output '$(@F)' " $(<F)
define plot
$(gnuplot)
endef
define plot-color
$(subst output ', output 'color/, $(subst monochrome,color,$(gnuplot)))
endef

$(PGRAPHICS)/%.eps $(PGRAPHICS)/%.tex: $(PGRAPHICS)/%.plt
	cd $(<D); $(plot)
$(PGRAPHICS)/color/%.eps $(PGRAPHICS)/color/%.tex: $(PGRAPHICS)/%.plt
	cd $(<D); $(plot-color)

$(GRAPHICS)/%.eps $(GRAPHICS)/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot)
$(GRAPHICS)/color/%.eps $(GRAPHICS)/color/%.tex: $(GRAPHICS)/%.plt
	cd $(<D); $(plot-color)

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

# -- IPE figures --
$(PGRAPHICS)/%.eps : $(PGRAPHICS)/%.ipe
	iperender -eps $< $@

$(GRAPHICS)/%.eps : $(GRAPHICS)/%.ipe
	iperender -eps $< $@

