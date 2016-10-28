# convert a solution written in the old template to the new template

NAME=$1

sed -i \
	-e '/odb-beta/d' \
	-e 's/->/   ->/g' \
	-e '/%%flag:typo-reseni/ i %%flag:typo-zadani-en->' \
	-e '/%%flag:typo-reseni/ a % kompletní specifikace na fiki' \
	-e '/\\probno/ a \\\probcontest{}' \
	-e 's/\\probname/\\\probname[cs]/' \
	-e '/\\probname/ a \\\probname[en]{}' \
	-e 's/\\proborigin/\\\proborigin[cs]/' \
	-e '/\\proborigin/ a \\\proborigin[en]{}\n\\\proborigintruth{}\n% mechHmBodu,mechTuhTel,hydroMech,mechPlynu,gravPole,kmitani,vlneni,\n% molFyzika,termoDyn,statFyz,optikaGeom,optikaVln,elProud,elPole,magPole,\n% relat,kvantFyz,jadFyz,astroFyz,matematika,chemie,biofyzika,other\n% ... multiple choice oddelene carkami bez mezer\n\\\probtopics{}' \
	-e '/%\\probavg{}/ a %\\\probfig[cs]{}\n%\\\probfig[en]{}\n%\\\probwebfig[cs]{}{}\n%\\\probwebfig[en]{}{}' \
	-e 's/\\probtask/\\\probtask[cs]/' \
	-e '/\\probsolution/ i \\\probtask[en]{%\n}' \
	-e 's/\\probsolution/\\\probsolution[cs]/' \
	-e '/% --- CUT HERE ---/ i \\\probsolution[en]{%\n}' \
	$NAME

sed -i '3d' $NAME
sed -i '3d' $NAME
