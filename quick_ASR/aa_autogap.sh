#!/bin/bash

TREE=${1};
ALN=${2};
#NODE=${3};
ALNROOT=${ALN%.*};
MODEL='LG+FO+G12';
BINMODEL='GTR2+FO+G8';


#AAALN=${ALN}_aa.a2m

# get rid of branch supports, iqtree puts them in the node name when it reads its own tree format!
perl -p -e 's/\/\/[^:]*//g' ${TREE} > ${ALN}_nobs.treefile

# convert the alignment to binary (0 for gaps, 1 for an amino acid)
seqcon -w ${ALN}
mv ${ALN}.a2m ${ALN}_binary.a2m


# get rid of branch supports, iqtree puts them in the node name when it reads its own tree format!
#perl -p -e 's/\/\/[^:]*//g' ${ALN}.treefile > ${ALN}_nobs.treefile

# now run iqtree with the protein phylogeny and the binary alignment, and reconstruct
# binary gap states for the ancestral nodes
nice iqtree2 -s ${ALN}_binary.a2m -nt 6 -st BIN -m ${BINMODEL} -asr -te ${ALN}_nobs.treefile

# run ancprobs to recontruct ancestor at the desired node (part of the command)
#ancprobs -n ${NODE} -p iqtree -f ${AAALN}.state -b ${BINALN}.state

