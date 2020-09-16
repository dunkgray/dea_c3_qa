#!/bin/bash
module purge
module load pbs

OUTPUTDIR=$(date +"%Y-%m-%d-%H-%M-%S")
TESTDIR=$PWD/../ard_test/$OUTPUTDIR

source prod-wagl.env

ard_pbs --level1-list scenes_to_ARD_process.txt --workdir $TESTDIR --pkgdir $TESTDIR --env $PWD/prod-wagl.env --project u46 --walltime 02:30:00  --nodes 1 --logdir  $TESTDIR
