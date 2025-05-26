#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22

python3.7 /home/$USER/mixer/precimed/mixer.py test2 \
    --trait1-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Anoreksi/PGC_AN_2019_qc_noMHC.csv.gz  \
    --trait2-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/ADHD/PGC_ADHD_2022_qc_noMHC.csv.gz \
    --load-params-file PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.fit.rep${SLURM_ARRAY_TASK_ID}.json \
    --out PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.test.rep${SLURM_ARRAY_TASK_ID} \
    --bim-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.bim \
    --ld-file /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Reference/chr@.run4.ld \
    --lib  /home/$USER/mixer/src/build/lib/libbgmg.so \