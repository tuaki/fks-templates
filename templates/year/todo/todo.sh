#!/bin/bash

########################################################
# Functions ############################################
########################################################

function wcheck()
{

    for dep in $3; do
        eval tmp=\$$dep
        if [ "$tmp" == "" ]; then
            if [ "x$5" != "x" ]; then
                if [ "x$4" != "x" ]; then
                    eval $5=\$$5"\;$1\ --\ $6\ \($dep\)"
                fi
            fi
            return 0
        fi
    done
    if [ "x$4" == "x" ]; then
        eval $2=\$$2"\;$1"
    fi
}

function pprint ()
{
    eval tmp=\$$3
    if [ "$tmp" != "" ]; then
        cat << EOF >> $1
\\subsubsection*{$2}
\\begin{compactenum}
`sed "s/;/\\\\\\\\item /g;s/_/\\\\\\\\_/g"<<<$tmp`
\\end{compactenum}
EOF
    fi
}

function pprint-html ()
{
    eval tmp=\$$3
    if [ "$tmp" != "" ]; then
        cat << EOF >> $1
<h3>$2</h3>
<ol>
`sed "s/;/<li>/g"<<<$tmp`
</ol>
EOF
    fi
}

########################################################
# Global setup #########################################
########################################################
year=Y #change here!!!

fileid=0
files=$1
texfile=$2
htmlfile=`sed "s/tex/html/" <<< $2`
csvfile=$3
lastyear_batch=''

# head of statistics
echo -n "file;pauthor;sauthor;odb_korek1;odb_korek2;" > $csvfile
echo "jaz_zadani;jaz_reseni;typo_zadanics;typo_zadanien;typo_reseni;" >> $csvfile

########################################################
# Loop over input files ################################
########################################################
for file in $files; do
# load data form file
    file=`sed "s/\/\//\//g" <<< $file`
# ingle row data
    points=` grep 'probpoints'     $file | sed 's/%*\\\\probpoints{\(.*\)}/\1/'`
    pauthor=`grep 'probauthors'    $file | sed 's/%*\\\\probauthors{\(.*\)}/\1/'`
    sauthor=`grep 'probsolauthors' $file | sed 's/%*\\\\probsolauthors{\(.*\)}/\1/'`
    statnum=`grep 'probsolvers'    $file | sed 's/%*\\\\probsolvers{\(.*\)}/\1/'`
    statavg=`grep 'probavg'        $file | sed 's/%*\\\\probavg{\(.*\)}/\1/'`
    batch=`  grep 'probbatch'      $file | sed 's/%*\\\\probbatch{\(.*\)}/\1/'`
    no=`     grep 'probno'         $file | sed 's/%*\\\\probno{\(.*\)}/\1/'`
    sourceE=`grep 'probsource'     $file | sed 's/%*\\\\probsource{\(.*\)}/\1/'`
    topics=` grep 'probtopics'     $file | sed 's/%*\\\\probtopics{\(.*\)}/\1/'`

    points=` sed "s/0//"      <<< $points`
    statnum=`sed "s/N\/A//"   <<< $statnum`
    statavg=`sed "s/N\/A//"   <<< $statavg`
    batch=`  sed "s/[^0-9]//" <<< $batch`
    no=`     sed "s/[^0-9]//" <<< $no`
# multi row data
    pnamecs=` cat $file | tr '\n' " " | sed 's/.*\\\\probname\[cs\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    namefull=`cat $file | tr '\n' " " | sed 's/.*\\\\probname\[cs\]{\([^}]*\)}.*/\1/' | tr -d '%'`
    porigcs=` cat $file | tr '\n' " " | sed 's/.*\\\\proborigin\[cs\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    resenics=`cat $file | tr '\n' " " | sed 's/.*\\\\probsolution\[cs\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    zadanics=`cat $file | tr '\n' " " | sed 's/.*\\\\probtask\[cs\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    pnameen=` cat $file | tr '\n' " " | sed 's/.*\\\\probname\[en\]{\([^}]*\)}.*/\1/' | tr -d ' %'`

    porigen=` cat $file | tr '\n' " " | sed 's/.*\\\\proborigin\[en\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    resenien=`cat $file | tr '\n' " " | sed 's/.*\\\\probsolution\[en\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
    zadanien=`cat $file | tr '\n' " " | sed 's/.*\\\\probtask\[en\]{\([^}]*\)}.*/\1/' | tr -d ' %'`
# flags
    odb_korek1=`   grep '%%flag:' $file | grep 'odb-korek1'     | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    odb_korek2=`   grep '%%flag:' $file | grep 'odb-korek2'     | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    jaz_zadani=`   grep '%%flag:' $file | grep 'jaz-zadani'     | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    jaz_reseni=`   grep '%%flag:' $file | grep 'jaz-reseni'     | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    typo_zadanics=`grep '%%flag:' $file | grep 'typo-zadani'    | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    typo_zadanien=`grep '%%flag:' $file | grep 'typo-zadani-en' | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
    typo_reseni=`  grep '%%flag:' $file | grep 'typo-reseni'    | sed 's/.*->\s*\([^?#]*\)[#?]*.*/\1/'`
# text
    text=`grep -v "%%" $file | wc -l`
    if [ "$text" -le "2" ]; then
        text=""
    fi
# check web publishing
    web=""
    webtask=""
    webtasken=""
    if [[ $file =~ problem.* ]]; then
        prob_name_cs=("" 1. 2. 3. 4. 5. problémová experimentální seriálová)
        prob_name_en=("" "problem 1" "problem 2" "problem 3" "problem 4" "problem 5" "problematical problem" "experimental problem" "problem to study topic")
        prob_swap=(0 1 2 3 4 8 5 6 7)

        fbatch=`sed "s/.*\\([0-9]\\)-\\([0-9]\\).*/\\1/g" <<< \`basename $file\``
        fno=`   sed "s/.*\\([0-9]\\)-\\([0-9]\\).*/\\2/g" <<< \`basename $file\``


        webfile='http://fykos.cz/rocnik'$year'/reseni/reseni'$fbatch'-'${prob_swap[$fno]}'.pdf'
        wget --spider $webfile -O /dev/null 2> /dev/null
        web=$?

        #avoid unnecessary reloads
        year_batch=$year"_"$fbatch
        if [ "$year_batch" != "$lastyear_batch" ]; then
            webtask='http://fykos.cz/zadani?serie='$fbatch'&volume='$year
            wget $webtask -O /tmp/fykos-todo-cs > /dev/null 2>&1
            webtasken='http://fykos.org/problems?serie='$fbatch'&volume='$year
            wget $webtasken -O /tmp/fykos-todo-en > /dev/null 2>&1
            lastyear_batch=$year_batch
        fi

        grep 'Zadání úloh '$fbatch'. série '$year'. ročníku' /tmp/fykos-todo-cs > /dev/null &&
        grep "${prob_name_cs[$fno]} úloha" /tmp/fykos-todo-cs > /dev/null
        webtask=$?

        grep -G 'Problems in '$fbatch'.. round (Volume '$year')' /tmp/fykos-todo-en > /dev/null &&
        grep "${prob_name_en[$fno]}" /tmp/fykos-todo-en > /dev/null
        webtasken=$?

    elif [[ $file =~ serial.* ]]; then
        webfile=`sed "s/tex/pdf/g" <<< \`basename $file\``
        webfile='http://fykos.cz/rocnik'$year'/serial/'$webfile
        wget --spider $webfile -O /dev/null 2> /dev/null
        web=$?
    elif [[ $file =~ uvod.* ]]; then
        webfile=`sed "s/uvod/serie/g;s/tex/pdf/g" <<< \`basename $file\``
        webfile='http://fykos.cz/rocnik'$year'/'$webfile
        wget --spider $webfile -O /dev/null 2> /dev/null
        web=$?
    elif [[ $file =~ aktuality.* ]]; then
        webfile=`sed "s/aktuality/leaflet/g;s/tex/pdf/g" <<< \`basename $file\``
        webfile='http://fykos.cz/rocnik'$year'/leaflet/'$webfile
        wget --spider $webfile -O /dev/null 2> /dev/null
        web=$?
    fi
    web=`       sed "s/[^0]//" <<< $web`
    webtask=`   sed "s/[^0]//" <<< $webtask`
    webtasken=` sed "s/[^0]//" <<< $webtasken`


# rewrite $file
    file=`basename $file`

    # print statistics
    echo -n "$file;$pauthor;$sauthor;" >> $csvfile
    echo -n "$odb_korek1;$odb_korek2;$jaz_zadani;$jaz_reseni;" >> $csvfile
    echo -n "$typo_zadanics;$typo_zadanien;$typo_reseni;" >> $csvfile
    echo "" >> $csvfile

# show progress
    echo -ne $file
    fileid=$(($fileid+1))
    if [ "$fileid" -eq "4" ]; then
        fileid=0
        echo -ne '\n'
    else
        echo -ne '\t'
    fi

# wcheck
# @1 jaka uloha
# @2 co
# @3 na co ceka
# @4 cim se to udela

##################################################################
# workflow type: problems
##################################################################
    if [[ $file =~ problem.* ]]; then
# beta warnings problems
        file=`sed -e 's/problem//;s/\.tex//' <<< $file`' -- '$namefull
        # bash escape
        file=`sed -e 's/(/\\\\(/g;s/)/\\\\)/g;s/ /\\\\ /g' <<< $file`
        wcheck "$file" chybi_batch   "sourceE" "$batch"
        wcheck "$file" chybi_no      "sourceE" "$no"
        wcheck "$file" chybi_source  ""        "$sourceE"
        wcheck "$file" chybi_body    "sourceE" "$points"
        wcheck "$file" chybi_topics  "sourceE" "$topics"
        wcheck "$file" chybi_pauthor "sourceE" "$pauthor"
        wcheck "$file" chybi_sauthor "sourceE" "$sauthor"
        wcheck "$file" chybi_stat    "web"     "$statavg"
        wcheck "$file" chybi_stat    "web"     "$statnum"
        wcheck "$file" chybi_pname   "sourceE" "$pnamecs"
        wcheck "$file" chybi_orig    "sourceE" "$porigcs"
        wcheck "$sauthor:\ $file" chybi_reseni  "sourceE" "$resenics"
        wcheck "$file" chybi_zadani  "sourceE" "$zadanics"
        wcheck "$file:\ Sautor:\ $sauthor" chybi_1kor    "sourceE resenics" "$odb_korek1"
# warning problems
        wcheck "$file" chybi_pnameen zadanien "$pnameen"
        wcheck "$file" chybi_porigen zadanien "$porigen"
# workflow problems
        file="$file\ --\ Sautor:\ $sauthor,\ K1:\ $odb_korek1"
        wcheck "$file" ceka_preklad "odb_korek1 zadanics"      "$zadanien"
        # resenien
        wcheck "$file" ceka_2kor    "odb_korek1"               "$odb_korek2"
        wcheck "$file" ceka_jR      "odb_korek2"               "$jaz_reseni"
        wcheck "$file" ceka_jZ      "odb_korek1 zadanics"      "$jaz_zadani"
        wcheck "$file" ceka_tZ_cs   "jaz_zadani zadanics"      "$typo_zadanics"
        wcheck "$file" ceka_tZ_en   "jaz_zadani zadanien"      "$typo_zadanien"
        wcheck "$file" ceka_tR      "typo_zadanics jaz_reseni" "$typo_reseni"
        wcheck "$file" ceka_zZ      "batch no sourceE pnamecs porigcs topics points pauthor sauthor zadanics jaz_zadani typo_zadanics odb_korek1" "$webtask"    publwwarnings "zadání\\ cs"
        wcheck "$file" ceka_zZ_en   "batch no sourceE pnameen porigen topics points pauthor sauthor zadanien jaz_zadani typo_zadanien odb_korek1" "$webtasken"  publwwarnings "zadání\\ en"
        wcheck "$file" ceka_zZ_m    "batch no sourceE pnamecs porigcs topics points pauthor sauthor zadanics jaz_zadani typo_zadanics           " "$odb_korek1$webtask"
        wcheck "$file" ceka_zZ_en_m "batch no sourceE pnameen porigen topics points pauthor sauthor zadanien jaz_zadani typo_zadanien           " "$odb_korek1$webtasken"
        wcheck "$file" tmp          "batch no sourceE pnamecs porigcs topics points pauthor sauthor zadanics jaz_zadani typo_zadanics           " "X"  publerrors_cs ""
        wcheck "$file" tmp          "batch no sourceE pnameen porigen topics points pauthor sauthor zadanien jaz_zadani typo_zadanien           " "X"  publerrors_en ""
        wcheck "$file" ceka_zR      "batch no sourceE pnamecs porigcs topics points pauthor sauthor zadanics resenics odb_korek1 odb_korek2 jaz_zadani jaz_reseni typo_zadanics typo_reseni " "$web" publwwarnings "řešení\\ cs"
        wcheck "$file" tmp          "points pauthor sauthor statnum statavg batch no sourceE topics pnamecs namefull porigcs resenics zadanics pnameen porigen zadanien odb_korek1 odb_korek2 jaz_zadani jaz_reseni typo_zadanics typo_zadanien typo_reseni web webtask webtasken" "X" notcompleted "uloha"
        # zatim vynechano: resenien

##################################################################
# workflow type: serial
##################################################################
    elif [[ $file =~ serial.* ]]; then
        file=`sed -e 's/\.tex//' <<< $file`
        wcheck "$file" chybi_text   ""             "$text"
        wcheck "$file" ceka_1kor    "text"         "$odb_korek1"
        wcheck "$file" ceka_2kor    "odb_korek1"   "$odb_korek2"
        wcheck "$file" ceka_j       "odb_korek2"   "$jaz_reseni"
        wcheck "$file" ceka_t       "jaz_reseni"   "$typo_reseni"
        wcheck "$file" ceka_z       "text odb_korek1 odb_korek2 jaz_reseni typo_reseni" "$web" publwwarnings "text"
        wcheck "$file" tmp          "text odb_korek1 odb_korek2 jaz_reseni typo_reseni web" "X" notcompleted "serial"
##################################################################
#workflow type: úvod
##################################################################
    elif [[ $file =~ [uvod|aktuality].* ]]; then
        file=`sed -e 's/uvod/batch/;s/aktuality/leaflet/;s/\.tex//' <<< $file`
        wcheck "$file" chybi_text   ""            "$text"
        wcheck "$file" ceka_j       "text"        "$jaz_reseni"
        wcheck "$file" ceka_t       "jaz_reseni"  "$typo_reseni"
        wcheck "$file" ceka_z       "text jaz_reseni typo_reseni" "$web" publwwarnings "text"
        wcheck "$file" tmp          "text jaz_reseni typo_reseni web" "X" notcompleted "batch-leaflet"
    else
        wcheck "$file" unknown_depend ""
    fi
##################################################################
##################################################################
done

# new line at the end
echo ""

##################################################################
# Output type latex ##############################################
##################################################################

cat << EOF > $texfile
\\documentclass{article}
\\usepackage{xltxtra}
\\usepackage{polyglossia}
\\usepackage{fontspec}
\\usepackage{paralist}
\\usepackage{a4wide}
\\usepackage{multicol}
\\usepackage[
    a4paper,
    margin=2cm,
    headsep=0.8cm,
    headheight=13pt]{geometry}
\\setmainlanguage{czech}
\\begin{document}
\\begin{center}\\Huge\\bf TODO list\\\\\\large`date --rfc-3339=s`\\end{center}
\\bigskip
\\begin{multicols}{2}
EOF

cat << EOF >> $texfile
\\subsection*{Problémy v hlavičce:}
EOF

pprint $texfile "Chybí text:"              chybi_text
pprint $texfile "Chybí zadání:"            chybi_zadani
pprint $texfile "Chybí autor řešení:"      chybi_sauthor
pprint $texfile "Chybí řešení:"            chybi_reseni
pprint $texfile "Chybí 1. korektura:"      chybi_1kor
pprint $texfile "Chybí název úlohy:"       chybi_pname
pprint $texfile "Chybí název úlohy en:"    chybi_pnameen
pprint $texfile "Chybí body:"              chybi_body
pprint $texfile "Chybí námět:"             chybi_orig
pprint $texfile "Chybí námět en:"          chybi_porigen
pprint $texfile "Chybí autor námětu:"      chybi_pauthor
pprint $texfile "Chybí topics:"            chybi_topics
pprint $texfile "Chybí statistiky:"        chybi_stat
pprint $texfile "Chybí batch:"             chybi_batch
pprint $texfile "Chybí číslo:"             chybi_no
pprint $texfile "Chybí zdroj (import):"    chybi_source
pprint $texfile "Nedefinované závislosti:" unknown_depend

cat << EOF >> $texfile
\\subsection*{Workflow:}
EOF

pprint $texfile "Čeká na překlad zadání:"              ceka_preklad
pprint $texfile "Čeká na první odbornou korekturu:"    ceka_1kor
pprint $texfile "Čeká na druhou odbornou korekturu:"   ceka_2kor
pprint $texfile "Čeká na jazykovou korekturu zadání:"  ceka_jZ
pprint $texfile "Čeká na jazykovou korekturu řešení:"  ceka_jR
pprint $texfile "Čeká na jazykovou korekturu:"         ceka_j
pprint $texfile "Čeká na typo korekturu cs-zadání:"    ceka_tZ_cs
pprint $texfile "Čeká na typo korekturu en-zadání:"    ceka_tZ_en
pprint $texfile "Čeká na typo korekturu řešení:"       ceka_tR
pprint $texfile "Čeká na typo korekturu:"              ceka_t
pprint $texfile "Čeká na zveřejnění zadání:"           ceka_zZ
pprint $texfile "Čeká na zveřejnění en zadání:"        ceka_zZ_en
pprint $texfile "Čeká na zveřejnění řešení:"           ceka_zR
pprint $texfile "Čeká na zveřejnění:"                  ceka_z
pprint $texfile "Zveřejněno s problémy:"               publwwarnings

cat << EOF >> $texfile
\\subsection*{Fallback:}
EOF

pprint $texfile "V nejhorším lze zveřejnit cs zadání:" ceka_zZ_m
pprint $texfile "V nejhorším lze zveřejnit en zadání:" ceka_zZ_en_m
pprint $texfile "Nelze zveřejnit cs zadání:"           publerrors_cs
pprint $texfile "Nelze zveřejnit en zadání:"           publerrors_en
pprint $texfile "Checklist pro ročenku:"               notcompleted

cat << EOF >> $texfile
\\end{multicols}
\\end{document}
EOF

##################################################################
# Output type html ###############################################
##################################################################

cat << EOF > $htmlfile
<html>
<head>
<meta charset="UTF-8">
<style>
body {
    color: #000;
    background-color: #fff
}
</style>
</head>
<body>
<h1>TODO list: fykos$year</h1>
`date --rfc-3339=s`
<h2>Věci, co už měly být:</h2>
EOF

pprint-html $htmlfile "Chybí text:"                 chybi_text
pprint-html $htmlfile "Chybí zadání:"               chybi_zadani
pprint-html $htmlfile "Chybí autor řešení:"         chybi_sauthor
pprint-html $htmlfile "Chybí řešení:"               chybi_reseni
pprint-html $htmlfile "Chybí 1. korektura:"         chybi_1kor
pprint-html $htmlfile "Chybí název úlohy:"          chybi_pname
pprint-html $htmlfile "Chybí název úlohy en:"       chybi_pnameen

cat << EOF >> $htmlfile
<h2>Workflow:</h2>
EOF

pprint-html $htmlfile "Čeká na překlad zadání:"              ceka_preklad
pprint-html $htmlfile "Čeká na první odbornou korekturu:"    ceka_1kor
pprint-html $htmlfile "Čeká na druhou odbornou korekturu:"   ceka_2kor
pprint-html $htmlfile "Čeká na jazykovou korekturu zadání:"  ceka_jZ
pprint-html $htmlfile "Čeká na jazykovou korekturu řešení:"  ceka_jR
pprint-html $htmlfile "Čeká na jazykovou korekturu:"         ceka_j
pprint-html $htmlfile "Čeká na typo korekturu cs-zadání:"    ceka_tZ_cs
pprint-html $htmlfile "Čeká na typo korekturu en-zadání:"    ceka_tZ_en
pprint-html $htmlfile "Čeká na typo korekturu řešení:"       ceka_tR
pprint-html $htmlfile "Čeká na typo korekturu:"              ceka_t
pprint-html $htmlfile "Čeká na zveřejnění zadání:"           ceka_zZ
pprint-html $htmlfile "Čeká na zveřejnění en zadání:"        ceka_zZ_en
pprint-html $htmlfile "Čeká na zveřejnění řešení:"           ceka_zR
pprint-html $htmlfile "Čeká na zveřejnění:"                  ceka_z
pprint-html $htmlfile "Zveřejněno s problémy:"               publwwarnings

cat << EOF >> $htmlfile
<h2>Fallback:</h2>
EOF

pprint-html $htmlfile "V nejhorším lze zveřejnit cs zadání:" ceka_zZ_m
pprint-html $htmlfile "V nejhorším lze zveřejnit en zadání:" ceka_zZ_en_m
pprint-html $htmlfile "Nelze zveřejnit cs zadání:"           publerrors_cs
pprint-html $htmlfile "Nelze zveřejnit en zadání:"           publerrors_en
pprint-html $htmlfile "Checklist pro ročenku:"               notcompleted

cat << EOF >> $htmlfile
<h2>Obecné chyby:</h2>
EOF

pprint-html $htmlfile "Chybí body:"                 chybi_body
pprint-html $htmlfile "Chybí námět:"                chybi_orig
pprint-html $htmlfile "Chybí námět en:"             chybi_porigen
pprint-html $htmlfile "Chybí autor námětu:"         chybi_pauthor
pprint-html $htmlfile "Chybí topics:"               chybi_topics
pprint-html $htmlfile "Chybí statistiky:"           chybi_stat
pprint-html $htmlfile "Chybí batch:"                chybi_batch
pprint-html $htmlfile "Chybí číslo:"                chybi_no
pprint-html $htmlfile "Chybí zdroj (import):"       chybi_source
pprint-html $htmlfile "Nedefinované závislosti:"    unknown_depend

cat << EOF >> $htmlfile
</body>
</html>
EOF



