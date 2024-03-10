#!/bin/bash

#Searches FASTA title to construct a human readable label
function readable()
{
    local FSTFILE=${1};
    local ANNOTATION;
    local ACC;
    local NAME;
    local ORGAN;
    local LABEL;
    local COUNT;
    local TEMP;

    #Pull out the FASTA annotation line
    ANNOTATION=$(egrep '^>' ${FSTFILE});

#Pull out & save the Accesion # from the annotation line
    ACC=$(echo ${ANNOTATION} |perl -pe 's/[^\S\n]+/\|/' | perl -pe 's/^>(.*)\|.*\n/$1\n/');

#Creates a variable (NAME) that is made of the first 2 letters of the first words within
    #brackets on the FASTA title line, if no brackets NAME is assigned as UNKN
    if echo ${ANNOTATION} | egrep -q '\['
    then
        NAME=$(echo ${ANNOTATION} | perl -pe 's/^>.*\[([[:alnum:]][[:alnum:]])[^ ]* ([[:alnum:]][[:alnum:]])[^]]*\]/\U$1$2/');
    else
        NAME="UNKN";
    fi
#Test if NAME is 4 characters long and if not assign as UNKN
    if [ ${#NAME} -ne 4 ]
    then
        NAME="UNKN";
    fi
 #The following if loop is used to assign the variable ORGAN by checking each FASTA
    #title for specific organellular information.
    if echo ${ANNOTATION} | egrep -qi 'cytosolic'
    then
       ORGAN="c";
    elif echo ${ANNOTATION} | egrep -qi 'chloroplast'
    then
       ORGAN="o";
    elif echo ${ANNOTATION} | egrep -qi 'glyoxysomal'
    then
       ORGAN="g";
    elif echo ${ANNOTATION} | egrep -qi 'mitochondrial'
    then
       ORGAN="m";
    else
       ORGAN="_";
    fi
 #The following if loops are used to assign the variable LABEL. The first if checks to
    #see if the FASTA has a sp ID and uses that as the name. If no sp ID exists, then the
    #if loops go about generating a sp-styled ID for the gi #.
    if echo ${ANNOTATION} | egrep -q '\|sp\|'
    then
        LABEL=$(echo $ANNOTATION | perl -pe 's/^>.*\|sp\|[^|]*\|([^ ]*) .*\n/$1/');
    elif echo ${ANNOTATION} | egrep -qi 'hydrolase'
    then
        LABEL="HYD${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'acetohydrolase'
    then
        LABEL="AHD${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -q 'depolymerase'
    then
        LABEL="DPL${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'lipase'
    then
        LABEL="LIP${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'esterase'
    then
        LABEL="EST${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'hypothetical protein'
    then
        LABEL="HYP${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'chlorophyllase'
    then
        LABEL="CHL${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'lactate dehydrogenase'
    then
        LABEL="LDH${ORGAN}${NAME}";
    elif echo ${ANNOTATION} | egrep -qi 'malate dehydrogenase'
    then
        LABEL="MDH${ORGAN}${NAME}";
    else
        LABEL="UNK${ORGAN}${NAME}";
    fi
 #Creates variable COUNT which is used to ensure that each LABEL is unique by appending
    #COUNT to the LABEL if there is another LABEL with that id
    COUNT=$(awk '{print $2}' acckey.txt | egrep ${LABEL} | wc -l)

    if [ ${COUNT} -ge 1 ] && [ ${COUNT} -lt 100 ]
    then
        TEMP=$(echo ${LABEL} | perl -pe 's/(.{8}).*/$1/');
        printf "%15s %15s %s%d\n" ${ACC} ${LABEL} ${TEMP} ${COUNT} >> acckey.txt;
    elif [ ${COUNT} -ge 100 ]
    then
        TEMP=$(echo ${LABEL} | perl -pe 's/(.{7}).*/$1/');
        printf "%15s %15s %s%d\n" ${ACC} ${LABEL} ${TEMP} ${COUNT} >> acckey.txt;
    else
        TEMP=$(echo ${LABEL} | perl -pe 's/(.{10}).*/$1/');
        printf "%15s %15s %s\n" ${ACC} ${LABEL} ${TEMP} >> acckey.txt;
    fi
}

#This for loop runs through all .fst files in the current directory. Make sure that the
#only .fst files in the directory are those exploded using seqcon

rm -f acckey.txt;

for FSTFILE in *.fst
do
    readable ${FSTFILE};
done
