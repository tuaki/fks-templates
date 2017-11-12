input fks
verbatimtex
%&latex
\documentclass[9pt]{extarticle}
\usepackage[utf8]{inputenc}
\usepackage{fkssugar}
\begin{document}
etex
 
prologues:=3;
u:=1cm;
 
beginfig(1);

fill (-3pt,-3pt)--(-3pt,3pt)--(3pt,3pt)--(3pt,-3pt)--cycle withcolor .1white;
draw (-3pt,-3pt)--(-3pt,3pt)--(3pt,3pt)--(3pt,-3pt)--cycle;

draw (-6pt,-6pt)..(  0pt,1pt)..(6pt, 6pt);
draw (-6pt, 6pt)..(1.5pt,0pt)..(6pt,-6pt);

endfig;
verbatimtex
\end{document}
etex
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prikazy pro vyhledavani ctrl-N vimem
%withcolor black white red green blue

%% cary.mp
%drawdots drawhlines drawvlines drawctverce drawtrojuhelniky drawkosoctverce

%% fks-3d.mp
%tDx tDy tDz tD VRP_tD AXON_tD PzP_tD proj norm_tD xpart_tD ypart_tD zpart_tD 
%dotprod_tD getTr shifted_dD shifted_tD SpRotateX_tD SpRotateY_tD SpRotateZ_tD 
%rotate_tD

%% fkscirc.mp
%svorky

%% fks-label.mp
%olabel oflabel flabel

%% newfks-logos.tex
%trubka erasetrubka

%% fks.mp
%cerch cark wp chpen uhel uhelR axis srafuj drawearrow drawdblearrow
%varrowhead drawvarrow drawdblvarrow pruzina odot kulicka

%% makecirc-fks.mp
%line misc miscahead bjtahead txtahead wire wireU centreof centerto scalecirc 
%puttext ctext putlabel inductor capacitor motor generator transformer source 
%resistor diode transistor meains ground junction impedance lamp switch battery 
%current imesh rheostat

%% mth-function.mp
%pi radian sqr log ln exp inv pow tand cotd sin cos tan cot sinh cosh tanh coth
%arcsind arccosd arcsin arccos argcosh argsinh

%% prevzato z diplomka.pdf: (prikazy matapostu)
%ahangle ahlength arclength arctime background bbox bboxmargin beginfig 
%begingroup beveled boolean btex buildcycle butt color currentpicture cutafter 
%cutbefore controls curl cycle dashed dashpattern def defaultfont defaultpen 
%defaultscale defaultscaled direction directionpoint directiontime dotlabel 
%downto draw dir drawarrow drawarrow reverse drawdblarrow drawdot else elseif 
%end enddef endfig endfor endgroup etex evenly exitif exitunless expr fi fill 
%filldraw fontsize for forever forsuffixes fullcircle halfcircle if image 
%infinity intersectionpoint intersectiontimes inverse label labeloffset length 
%linecap linejoin makepath makepen mitered mpxbreak numeric pair path pen 
%pencircle pensquare pickup picture point prologues quatercircle reflectedabout 
%rotated rotatedaround rounded save scaled shifted show slanted spark squared 
%step str string subpath suffix text tension thelabel transform transformed 
%undraw undrawdot unfill unfilldraw until upto vardef verbatimtex whatever 
%withdots xscaled

