#!/bin/bash

# What is needed
# The location of the ard
# The location of the level 1

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

#ard-intercomparison --help

rm -f s3_paths_list.txt  # In case we've been run before
#for product_name in s2a_ard_granule s2b_ard_granule; do
#   echo Searching for $product_name datasets.
#product_name="ga_ls8c_ard_3"
psql --variable=ON_ERROR_STOP=1 --csv --quiet --tuples-only --no-psqlrc \
   -h dea-db.nci.org.au datacube <<EOF >> s3_paths_list.txt
SELECT  ds.added, dsl.uri_body, ds.metadata
FROM agdc.dataset ds
                INNER JOIN agdc.dataset_type dst ON ds.dataset_type_ref = dst.id
                INNER JOIN agdc.dataset_location dsl ON ds.id = dsl.dataset_ref
WHERE  dst.name='ga_ls8c_ard_3'
ORDER BY ds.added DESC 
LIMIT 1;
EOF
            
echo -n Num Datasets to upload: 
wc -l s3_paths_list.txt

