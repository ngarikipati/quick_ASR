#!/bin/bash

#runs a simple amino acid phylogeny using LG as the model

( nice iqtree2 -s ${1} -st AA -nt AUTO -abayes -allnni -m LG+FO+G12 -asr ) &
