#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00
#SBATCH --array=1-22
python3.7 /home/$USER/mixer/precimed/mixer_figures.py combine --json /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Anoreksi/PGC_AN_2019_qc_noMHC.fit.rep@.json --out PGC_AN_2019.fit
python3.7 /home/$USER/mixer/precimed/mixer_figures.py combine --json /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Anoreksi/PGC_AN_2019_qc_noMHC.test.rep@.json  --out PGC_AN_2019.test

python3.7 /home/$USER/mixer/precimed/mixer_figures.py one --json PGC_AN_2019.fit.json --out AN.fit --statistic mean std 
python3.7 /home/$USER/mixer/precimed/mixer_figures.py one --json PGC_AN_2019.test.json --out AN.test --statistic mean std 