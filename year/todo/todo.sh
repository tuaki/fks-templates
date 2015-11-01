#!/bin/bash

function wcheck()
{
    for dep in $3; do
        eval tmp=\$$dep
        if [ "$tmp" == "" ]; then
            return 0
        fi
    done
    if [ "$4" != "" ]; then
        return 0
    fi
    eval $2=\$$2"\;"$1
}

function pprint ()
{
    eval tmp=\$$3
    if [ "$tmp" != "" ]; then
        cat << EOF >> $1
\\subsubsection*{$2}
\\begin{compactenum}
`sed "s/;/\\\\\\\\item /g;s/_/\\\\\\\\_/g;s/problems\///g"<<<$tmp`
\\end{compactenum}
EOF
    fi
}

incl=$3

for file in $1; do
    file=`sed "s/\/\//\//g" <<< $file`
#single row
    points=` grep 'probpoints'     $file | sed 's/%*\\\\probpoints{\(.*\)}/\1/'`
    pauthor=`grep 'probauthors'    $file | sed 's/%*\\\\probauthors{\(.*\)}/\1/'`
    sauthor=`grep 'probsolauthors' $file | sed 's/%*\\\\probsolauthors{\(.*\)}/\1/'`
    statnum=`grep 'probsolvers'    $file | sed 's/%*\\\\probsolvers{\(.*\)}/\1/'`
    statavg=`grep 'probavg'        $file | sed 's/%*\\\\probavg{\(.*\)}/\1/'`

    statnum=`sed "s/N\/A//" <<< $statnum`
    statavg=`sed "s/N\/A//" <<< $statavg`
# multi row
    pname=` cat $file | tr '\n' " " | sed 's/.*\\\\probname{\([^}]*\)}.*/\1/' | tr -d ' %'`
    porig=` cat $file | tr '\n' " " | sed 's/.*\\\\proborigin{\([^}]*\)}.*/\1/' | tr -d ' %'`
    reseni=`cat $file | tr '\n' " " | sed 's/.*\\\\probsolution{\([^}]*\)}.*/\1/' | tr -d ' %'`
    zadani=`cat $file | tr '\n' " " | sed 's/.*\\\\probtask{\([^}]*\)}.*/\1/' | tr -d ' %'`
# flags
    odb_beta=`   grep '%%flag:' $file | grep 'odb-beta'    | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    odb_korek1=` grep '%%flag:' $file | grep 'odb-korek1'  | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    odb_korek2=` grep '%%flag:' $file | grep 'odb-korek2'  | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    jaz_zadani=` grep '%%flag:' $file | grep 'jaz-zadani'  | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    jaz_reseni=` grep '%%flag:' $file | grep 'jaz-reseni'  | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    typo_zadani=`grep '%%flag:' $file | grep 'typo-zadani' | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
    typo_reseni=`grep '%%flag:' $file | grep 'typo-reseni' | sed 's/.*->\s*\([a-z|A-Z]*\)/\1/'`
# má obsah
    text=`grep -v "%%" $file | wc -l`
    if [ "$text" -le "2" ]; then
        text=""
    fi

# rewrite $file
    file=`basename $file`
    echo -n $file" "
# wcheck
# @1 jaka uloha
# @2 co
# @3 na co ceka
# @4 cim se to udela

# workflow type: problems
    if [[ $file =~ problem.* ]]; then
# beta warnings problems
        wcheck $file chybi_beta    "" $odb_beta
        wcheck $file points        "" $points
        wcheck $file chybi_pauthor "" $pauthor
        wcheck $file chybi_sauthor "" $sauthor
        wcheck $file chybi_stat    "" $statavg
        wcheck $file chybi_stat    "" $statnum
        wcheck $file chybi_pname   "" $pname
        wcheck $file chybi_orig    "" $porig
        wcheck $file chybi_reseni  "" $reseni
        wcheck $file chybi_zadani  "" $zadani
# workflow problems
        wcheck $file ceka_preklad "odb_beta zadani"
        wcheck $file ceka_zZ_en   "odb_beta zadani"
        wcheck $file ceka_1kor    "odb_beta reseni zadani" $odb_korek1
        wcheck $file ceka_2kor    "odb_korek1"             $odb_korek2
        wcheck $file ceka_jR      "odb_korek2"             $jaz_reseni
        wcheck $file ceka_jZ      "odb_beta zadani"        $jaz_zadani
        wcheck $file ceka_tZ      "jaz_zadani"             $typo_zadani
        wcheck $file ceka_tR      "typo_zadani jaz_reseni" $typo_reseni
        wcheck $file ceka_zZ      "typo_zadani"
        wcheck $file ceka_zR      "typo_reseni"
# workflow type: serial
    elif [[ $file =~ serial.* ]]; then
        wcheck $file chybi_text   ""             $text
        wcheck $file ceka_1kor    "text"         $odb_korek1
        wcheck $file ceka_2kor    "odb_korek1"   $odb_korek2
        wcheck $file ceka_jR      "odb_korek2"   $jaz_reseni
        wcheck $file ceka_tR      "jaz_reseni"   $typo_reseni
        wcheck $file ceka_zR      "typo_reseni"
#workflow type: úvod
    elif [[ $file =~ [uvod|aktuality].* ]]; then
        wcheck $file chybi_text   ""            $text
        wcheck $file ceka_jR      "text"        $jaz_reseni
        wcheck $file ceka_tR      "jaz_reseni"  $typo_reseni
        wcheck $file ceka_zR      "typo_reseni"
    else
        wcheck $file unknown_depend ""
    fi
done

# load done
lzadani_cs=` grep "zadani-cs"   $incl | sed "s/zadani-cs://"`
lreseni_cs=` grep "reseni-cs"   $incl | sed "s/reseni-cs://"`
ltranla_en=` grep "preklad-en"  $incl | sed "s/preklad-en://"`
lzadani_en=` grep "zadani-en"   $incl | sed "s/zadani-en://"`
lserial_cs=` grep "serial-cs"   $incl | sed "s/serial-cs://"`
lbatch_cs=`  grep "batch-cs"    $incl | sed "s/batch-cs://"`
lleaflet_cs=`grep "leaflet-cs"  $incl | sed "s/leaflet-cs://"`

# TODO rewrite... !
for hotovo in $lzadani_cs; do
    files=`ls ../problems/problem$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zZ=`sed "s/;$dfile//" <<< $ceka_zZ`
    done
done
for hotovo in $lreseni_cs; do
    files=`ls ../problems/problem$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zR=`sed "s/;$dfile//" <<< $ceka_zR`
    done
done
for hotovo in $lserial_cs; do
    files=`ls ../batch?/serial$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zR=`sed "s/;$dfile//" <<< $ceka_zR`
    done
done
for hotovo in $lbatch_cs; do
    files=`ls ../batch?/uvod$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zR=`sed "s/;$dfile//" <<< $ceka_zR`
    done
done
for hotovo in $lleaflet_cs; do
    files=`ls ../leaflet?/aktuality$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zR=`sed "s/;$dfile//" <<< $ceka_zR`
    done
done
for hotovo in $ltranla_en; do
    files=`ls ../problems/problem$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_preklad=`sed "s/;$dfile//" <<< $ceka_preklad`
    done
done

ceka_prekladX=`sed "s/;/ /g" <<< $ceka_preklad`
for hotovo in $ceka_prekladX; do
    ceka_zZ_en=`sed "s/;$hotovo//" <<< $ceka_zZ_en`
done

for hotovo in $lzadani_en; do
    files=`ls ../problems/problem$hotovo.tex`
    for dfile in $files; do
        dfile=`basename $dfile`
        ceka_zZ_en=`sed "s/;$dfile//" <<< $ceka_zZ_en`
    done
done

cat << EOF > $2
\\documentclass{article}
\\usepackage{fontspec}
\\usepackage{paralist}
\\usepackage{a4wide}
\\usepackage{multicol}
\\usepackage[
    a4paper,
    margin=2cm,
    headsep=0.8cm,
    headheight=13pt]{geometry}
\\begin{document}
\\begin{center}\\Huge\\bf TODO list\\\\\\large`date --rfc-3339=s`\\end{center}
\\bigskip
\\begin{multicols}{2}
EOF

cat << EOF >> $2
\\subsection*{Problémy v hlavičce:}
EOF

pprint $2 "Chybí zadání:"               chybi_zadani
pprint $2 "Chybí řešení:"               chybi_reseni
pprint $2 "Chybí text:"                 chybi_text
pprint $2 "Chybí \$\\beta\$-korektura:" chybi_beta
pprint $2 "Chybí body:"                 chybi_body
pprint $2 "Chybí autor námětu:"         chybi_pauthor
pprint $2 "Chybí námět:"                chybi_orig
pprint $2 "Chybí autor řešení:"         chybi_sauthor
pprint $2 "Chybí statistiky:"           chybi_stat
pprint $2 "Chybí název úlohy:"          chybi_pname

cat << EOF >> $2
\\subsection*{Workflow:}
EOF

pprint $2 "Čeká na překlad zadání:"             ceka_preklad
pprint $2 "Čeká na jazykovou korekturu zadání:" ceka_jZ
pprint $2 "Čeká na typo korekturu zadání:"      ceka_tZ
pprint $2 "Čeká na první odbornou korekturu:"   ceka_1kor
pprint $2 "Čeká na druhou odbornou korekturu:"  ceka_2kor
pprint $2 "Čeká na jazykovou korekturu řešení:" ceka_jR
pprint $2 "Čeká na typo korekturu řešení:"      ceka_tR
pprint $2 "Čeká na zveřejnění zadání:"          ceka_zZ
pprint $2 "Čeká na zveřejnění řešení:"          ceka_zR
pprint $2 "Čeká na zveřejnění en zadání:"       ceka_zZ_en

cat << EOF >> $2
\\subsection*{Obecné chyby:}
EOF

pprint $2 "Nedefinované závislosti:" unknown_depend

cat << EOF >> $2
\\end{multicols}
\\end{document}
EOF

