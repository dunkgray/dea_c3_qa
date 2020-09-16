#!/bin/bash
module purge
module load pbs


source prod-wagl.env

ard_pbs --level1-list scenes_to_ARD_process.txt --workdir ../scratch --pkgdir ../ard_ref /g/data/xu18/ga --env prod-wagl.env --project u46 --walltime 02:30:00  --nodes 1 --logdir ../logdir
