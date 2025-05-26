#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22
python3.7 /home/$USER/mixer/precimed/mixer.py test1 \
      --trait1-file PGC_AN_2019_qc_noMHC.csv.gz \
      --load-params-file PGC_AN_2019_qc_noMHC_it5.fit.rep${SLURM_ARRAY_TASK_ID}.json \
      --out PGC_AN_2019_qc_noMHC_it5.test.rep${SLURM_ARRAY_TASK_ID} \
      --bim-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.bim \
      --ld-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.run4.ld \
      --lib  /home/$USER/mixer/src/build/lib/libbgmg.so \
# This command evaluates the fitted genetic model by testing it on GWAS summary statistics
 # and linkage disequilibrium data. It checks how well the model captures the genetic architecture of the trait

# line 1: Calls mizer script and run the test mode of mixer to evaluate the fitted model 
# Line 2: Specify the file for the trait being analyzed. The data we test the model on
# line 3: Loads the file containing the model paramenters. fit1 step. This provides the trained model
# line 4: Specify where the output should be stored
# line 5: provides a plink bim file that has the SNP positions and the allele info
# line 6: provided LD information
# Line 7: loads a shared C++ library required by MIXER for efficient computation.
