#!/bin/bash
# Arguement is list of human readable names to be removed
# Script will remove exploded files names by Human Readable label from directory

#rm -f trimmed.fst

LABELS=$(awk '{print $0}' ${1});

#echo ${LABELS}

for LABEL in ${LABELS}
do
    rm -f ${LABEL}.fst;
done

cat *.fst > trimmed.fst;


