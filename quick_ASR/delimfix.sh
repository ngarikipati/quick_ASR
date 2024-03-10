#!/bin/bash

FILE=${1};

for FILE in *.fstdump.txt
do
	cat ${FILE} | perl -pe 's/(.*\..\s)(.*\])(.*\s)/$1\|$2\|$3/' > ${FILE%.*}_fixed.txt
done
