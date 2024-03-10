#!/bin/bash

# First argument to script is the gikey file
# Second argument is the file you want to search-replace
# Script outputs a new file with replacements; it does not touch the input files

ACCKEY=${1};
ACCFILE=${2};

EXT=${ACCFILE##*.}
NEWACCFILE="${ACCFILE%.*}_girep.${EXT}"

cat ${ACCFILE} | perl -pe 's/^>(.*\..).*/$1/'> ${NEWACCFILE}; #use this when you need to replace a fasta file of amino acid records
#cat ${ACCFILE} | perl -pe 's/^>.*\_cds_(.*\..)\_.*/$1/' > ${NEWACCFILE};
#cat ${ACCFILE} | awk '{print $0}' > ${NEWACCFILE};

ACCS=$(awk '{print $1}' ${ACCKEY});

for ACC in ${ACCS}
do
    HUMANID=$(egrep "^ *${ACC} " ${ACCKEY} | awk '{ print $3 }');
    echo "${ACC}  ${HUMANID}";
    #perl -pi -e "s/([^\d])${ACC}([^\d])/\1${HUMANID}\2/" ${NEWACCFILE};
    #perl -pi -e "s/([^\d])${ACC}$/\1${HUMANID}/" ${NEWACCFILE};
    #perl -pi -e "s/^${ACC}([^\d])/${HUMANID}\1/" ${NEWACCFILE};
    perl -pi -e "s/^${ACC}/\>${HUMANID}/" ${NEWACCFILE};
done
