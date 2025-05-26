#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22

python3.7 /home/$USER/mixer/precimed/mixer.py fit1 \
      --trait1-file PGC_AN_2019_qc_noMHC.csv.gz \
      --out PGC_AN_2019_qc_noMHC_it5.fit.rep${SLURM_ARRAY_TASK_ID} \
      --extract /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr.prune_maf0p05_rand2M_r2p8.chr${SLURM_ARRAY_TASK_ID}.rep5.snps \
      --bim-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.bim \
      --ld-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.run4.ld \
      --lib  /home/$USER/mixer/src/build/lib/libbgmg.so \

# This code extracts a carefully filtered set of SNPs from GWAS data by removing rare and highly correlated variants
# It ensures the analysis focuses on common, informative genetic variants for reliable results.

# line 1: Fit1 estimates genetic parameters related to polygenicity and effect size distribution.

# line 2: specify the GWAS summary statics file. Which contail SNP effect, allele mm.

# Line 3 gives the output a name. Each SLURM job runs an independent replicate. to improve estimation.

# line 4 extracts a subset of SNP from the reference data. it sets up some filters for the subset

# Line 5 specify the plink bim file which have the SNP genomic position and allele info

# line 6 Specify the LD file

# line 7 This is a shared library (.so file) that contains precompiled C++/C code for fast computations in MIXER.