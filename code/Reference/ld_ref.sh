#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22
/home/$USER/miniconda3/envs/mixer/bin/python3.7 /home/$USER/mixer/precimed/mixer.py ld \
   --lib /home/$USER/mixer/src/build/lib/libbgmg.so \
   --bfile data_raw/Reference/chr${SLURM_ARRAY_TASK_ID}\
   --out data_raw/Reference/chr${SLURM_ARRAY_TASK_ID}.run4.ld \
   --r2min 0.05 --ldscore-r2min 0.05 --ld-window-kb 30000




