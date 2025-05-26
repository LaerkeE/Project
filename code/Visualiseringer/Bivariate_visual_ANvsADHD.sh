#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22

python3.7 /home/$USER/mixer/precimed/mixer_figures.py combine --json /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Bivariate/PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.fit.rep@.json --out PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.fit
python3.7 /home/$USER/mixer/precimed/mixer_figures.py combine --json /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Bivariate/PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.test.rep@.json --out PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.test
python3.7 /home/$USER/mixer/precimed/mixer_figures.py two --json-fit PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.fit.json --json-test PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5.test.json --out PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_it5_Visualization --trait1 AN --trait2 ADHD --statistic mean std