#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 64g
#SBATCH --time 12:00:00
#SBATCH --array=1-22

for REP in {1..5} 
do
   /home/$USER/miniconda3/envs/mixer/bin/python3.7 /home/$USER/mixer/precimed/mixer.py snps \
      --lib /home/$USER/mixer/src/build/lib/libbgmg.so \
      --bim-file chr@.bim \
      --ld-file chr@.run4.ld \
      --out chr.prune_maf0p05_rand2M_r2p8.chr${SLURM_ARRAY_TASK_ID}.rep${REP}.snps \
      --maf 0.05 --subset 2000000 --r2 0.8 --seed $((SLURM_ARRAY_TASK_ID + 100 * REP))
done