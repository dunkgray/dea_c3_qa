#!/bin/bash

module purge
module load pbs

module use /g/data/v10/public/modules/modulefiles
module use /g/data/v10/private/modules/modulefiles

TESTDIR=$1
# The test dir 
echo $1

#The reference dir
REFDIR=$2
echo $2
module load ard-pipeline/alpha

# --env $PWD/c3.env - I wonder what it needs?

ard-intercomparison pbs --outdir $TESTDIR --env $PWD/gost.env --time 2001-1-1 2020-1-1 --db-env-reference "*/*/*/*.odc-metadata.yaml" --db-env-test "*/*/*/*.odc-metadata.yaml" --product-name-reference $REFDIR --product-name-test $TESTDIR --query-filesystem --project u46
