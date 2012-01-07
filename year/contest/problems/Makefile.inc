# Makefile part for problems dependent images
# Problem TeX file must be first dependecy in order building process work
# correctly

problem_1= problem1.tex
problem_2= problem2.tex
problem_3= problem3.tex
problem_4= problem4.tex
problem_5= problem5.tex
problem_6= problem6.tex
problem_7= problem7.tex
problem_8= problem8.tex
problem_9= problem9.tex
problem_10= problem10.tex
problem_11= problem11.tex
problem_12= problem12.tex
problem_13= problem13.tex
problem_14= problem14.tex
problem_15= problem15.tex graphics/track.eps
problem_16= problem16.tex
problem_17= problem17.tex
problem_18= problem18.tex
problem_19= problem19.tex
problem_20= problem20.tex
problem_21= problem21.tex
problem_22= problem22.tex
problem_23= problem23.tex
problem_24= problem24.tex
problem_25= problem25.tex
problem_26= problem26.tex
problem_27= problem27.tex
problem_28= problem28.tex
problem_29= problem29.tex
problem_30= problem30.tex
problem_31= problem31.tex
problem_32= problem32.tex
problem_33= problem33.tex
problem_34= problem34.tex
problem_35= problem35.tex
problem_36= problem36.tex
problem_37= problem37.tex
problem_38= problem38.tex
problem_39= problem39.tex
problem_40= problem40.tex
problem_41= problem41.tex
problem_42= problem42.tex
problem_43= problem43.tex
problem_44= problem44.tex
problem_45= problem45.tex
problem_46= problem46.tex
problem_47= problem47.tex
problem_48= problem48.tex
problem_49= problem49.tex
problem_50= problem50.tex

#
# Rules for problem support files
#
$(PROBLEMS)/graphics/problem1-5-data-tab.tex: $(PROBLEMS)/graphics/problem1-5-data.dat
	sed -e 's:\([0-9]\+\.\?[0-9]*\):$$"\1"$$:g' -e 's/\t/ \&\t/g' -e 's/$$/\\\\/g' $< | grep -v '^#'> $@
#	touch $(PROBLEMS)/graphics/problem1-5-data.plt # data se nemění často, řešení pomocí manuálního touch

