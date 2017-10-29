set encoding utf8
#set key right top

set xlabel "\\popi{x}{1}"
set ylabel "\\popi{y}{1}"


plot [-5:5] [-1.5:1.5] sin(x+pi) title "$\\sin(x+\\pi)$", cos(x) title "$\\cos x$"

set out



