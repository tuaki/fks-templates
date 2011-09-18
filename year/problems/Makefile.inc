# Makefile part for problems dependent images
# Need to define variables:	PD	problems dir
#				GD	graphics dir (for problems)

.PHONY: \
problem1-1 problem1-2 problem1-3 problem1-4 problem1-5 problem1-6 problem1-7 problem1-8 \
problem2-1 problem2-2 problem2-3 problem2-4 problem2-5 problem2-6 problem2-7 problem2-8 \
problem3-1 problem3-2 problem3-3 problem3-4 problem3-5 problem3-6 problem3-7 problem3-8 \
problem4-1 problem4-2 problem4-3 problem4-4 problem4-5 problem4-6 problem4-7 problem4-8 \
problem5-1 problem5-2 problem5-3 problem5-4 problem5-5 problem5-6 problem5-7 problem5-8 \
problem6-1 problem6-2 problem6-3 problem6-4 problem6-5 problem6-6 problem6-7 problem6-8

problem1-1: $(PD)/problem1-1.tex $(addprefix $(GD)/, problem1-1-troj.eps)
problem1-2: $(PD)/problem1-2.tex
problem1-3: $(PD)/problem1-3.tex
problem1-4: $(PD)/problem1-4.tex
problem1-5: $(PD)/problem1-5.tex
problem1-6: $(PD)/problem1-6.tex
problem1-7: $(PD)/problem1-7.tex
problem1-8: $(PD)/problem1-8.tex

problem2-1: $(PD)/problem2-1.tex
problem2-2: $(PD)/problem2-2.tex
problem2-3: $(PD)/problem2-3.tex
problem2-4: $(PD)/problem2-4.tex
problem2-5: $(PD)/problem2-5.tex
problem2-6: $(PD)/problem2-6.tex
problem2-7: $(PD)/problem2-7.tex
problem2-8: $(PD)/problem2-8.tex

problem3-1: $(PD)/problem3-1.tex
problem3-2: $(PD)/problem3-2.tex
problem3-3: $(PD)/problem3-3.tex
problem3-4: $(PD)/problem3-4.tex
problem3-5: $(PD)/problem3-5.tex
problem3-6: $(PD)/problem3-6.tex
problem3-7: $(PD)/problem3-7.tex
problem3-8: $(PD)/problem3-8.tex

problem4-1: $(PD)/problem4-1.tex
problem4-2: $(PD)/problem4-2.tex
problem4-3: $(PD)/problem4-3.tex
problem4-4: $(PD)/problem4-4.tex
problem4-5: $(PD)/problem4-5.tex
problem4-6: $(PD)/problem4-6.tex
problem4-7: $(PD)/problem4-7.tex
problem4-8: $(PD)/problem4-8.tex

problem5-1: $(PD)/problem5-1.tex
problem5-2: $(PD)/problem5-2.tex
problem5-3: $(PD)/problem5-3.tex
problem5-4: $(PD)/problem5-4.tex
problem5-5: $(PD)/problem5-5.tex
problem5-6: $(PD)/problem5-6.tex
problem5-7: $(PD)/problem5-7.tex
problem5-8: $(PD)/problem5-8.tex

problem6-1: $(PD)/problem6-1.tex
problem6-2: $(PD)/problem6-2.tex
problem6-3: $(PD)/problem6-3.tex
problem6-4: $(PD)/problem6-4.tex
problem6-5: $(PD)/problem6-5.tex
problem6-6: $(PD)/problem6-6.tex
problem6-7: $(PD)/problem6-7.tex
problem6-8: $(PD)/problem6-8.tex

