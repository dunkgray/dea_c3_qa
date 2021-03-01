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
product_name="ga_ls8c_ard_3"
# ///g/data/xu18/ga/ga_ls8c_ard_3/106/068/2019/12/16/ga_ls8c_ard_3-2-0_106068_2019-12-16_final.odc-metadata.yaml
#  dst.name='ga_ls8c_ard_3'

psql --variable=ON_ERROR_STOP=1 --csv --quiet --tuples-only --no-psqlrc \
   -h dea-db.nci.org.au datacube <<EOF >> s3_paths_list.txt
SELECT  dsl.uri_body
FROM agdc.dataset ds
                INNER JOIN agdc.dataset_type dst ON ds.dataset_type_ref = dst.id
                INNER JOIN agdc.dataset_location dsl ON ds.id = dsl.dataset_ref
WHERE  dst.name='$product_name'
ORDER BY ds.added DESC 
LIMIT 1;
EOF

echo  First results 
more s3_paths_list.txt

# If the ARD location is needed...
#                INNER JOIN agdc.dataset_location dsl ON ds.id = dsl.dataset_ref
# LC08_L1TP_106068_20191216_20201023_01_T1
psql --variable=ON_ERROR_STOP=1 --csv --quiet --tuples-only --no-psqlrc \
   -h dea-db.nci.org.au datacube <<EOF > landsat_L1_C1_tar.txt
SELECT  concat('/g/data/da82/AODH/USGS/L1/Landsat/C1/', 
substring(ds.metadata->'properties'->>'odc:region_code' from 1 for 3)::TEXT,  
'_', 
substring(ds.metadata->'properties'->>'odc:region_code' from 4 for 3)::TEXT,  
'/',
substring(ds.metadata->'properties'->>'landsat:landsat_scene_id' for 16), 
'/',
ds.metadata->'properties'->>'landsat:landsat_product_id'::TEXT, 
'.tar')
FROM agdc.dataset ds
                INNER JOIN agdc.dataset_type dst ON ds.dataset_type_ref = dst.id
WHERE  dst.name='$product_name'
ORDER BY ds.added DESC 
LIMIT 1;
EOF

echo  2nd results 
more landsat_product_id.txt

