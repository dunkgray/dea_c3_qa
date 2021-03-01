#!/bin/bash

module purge
module load pbs

module use /g/data/v10/public/modules/modulefiles
module use /g/data/v10/private/modules/modulefiles

TESTDIR=/g/data/u46/users/dsg547/c3_ard_qa/ard_test/2020-09-16-16-52-00-bad_band1_3
# The test dir 
echo $1

#The reference dir
REFDIR=/g/data/xu18/ga
echo $2
module load ard-pipeline/alpha

# --env $PWD/c3.env - I wonder what it needs?

ard-intercomparison pbs --outdir $TESTDIR --env $PWD/gost.env --time 2001-1-1 2020-1-1 --db-env-reference "ga_ls5t_ard_3/104/075/2011/01/26/*.odc-metadata.yaml" --db-env-test "ga_ls5t_ard_3/104/075/2011/01/26/*.odc-metadata.yaml" --product-name-reference $REFDIR --product-name-test $TESTDIR --query-filesystem --project u46
