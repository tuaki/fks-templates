input fks
verbatimtex
%&plain
\input fks-mp.sty
%\input utf8.tex
etex

prologues:=3;
u:=1cm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reseni 1.uloha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beginfig(1);
tlst := .05u;
r    := .5u;

z0=(0,0);
z1=(2*sqrt(3)*u,-2u);
z2=z0-(tlst/2,tlst/2*sqrt3);
z3=z1-(tlst/2,tlst/2*sqrt3);

draw z0--z1;
draw z2--z3;
draw z1{dir-30}..z3{dir150};
draw z0{dir150}..z2{dir-30};

z4= .3[z0,z1].shifted(r/2,r/2*sqrt3);
kulicka(2r, z4);

z5=z4.shifted(0,-1.5u);
z6=z4.shifted(1.5u/4*sqrt3,-1.5u/4);
z7=z4.shifted(-1.5u/4*sqrt3,-1.5u/4*3);


drawvarrow z4--z5 wp3;
drawvarrow z4--z6 wp3;
drawvarrow z4--z7 wp3;


draw z5--z6 dashed evenly;
draw z0--(x0,y1)--z1 dashed evenly;

label.lft(btex $\vect{F_G}$ etex, .7[z4,z5]);
label.top(btex $\vect{F}$ etex,   .5[z4,z6]);
label.lft(btex $\vect{F\_N}$ etex, .5[z4,z7]);
label.lft(btex $h$ výška etex  , .5[z0,(x0,y1)]);
label.bot(btex $L/2$ etex, .5[z1,(x0,y1)]);


endfig;
end




