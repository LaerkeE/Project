#!/bin/bash
#SBATCH --account NCRR-PRS
#SBATCH -c 16
#SBATCH --mem 32g
#SBATCH --time 12:00:00

python3.7 - <<EOF
import pandas as pd

df = pd.read_csv("pgcAN2.2019-07.vcf.tsv.gz", sep="\t", skiprows=70, compression="gzip")

df.rename(columns={"ID": "SNP", "REF": "A1", "ALT": "A2", "IMPINFO": "INFO", "DIRE": "Direction"}, inplace=True)

df.to_csv("cleaned_pgc_AN_2019.csv.gz", sep="\t", index=False, compression="gzip")

EOF

python3.7 /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/convert/python_convert-master/sumstats.py csv --sumstats cleaned_pgc_AN_2019.csv.gz  --out PGC_AN_2019.csv --force --auto --head 5 --ncase-val 16992 --ncontrol-val 55525 
python3.7 /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/convert/python_convert-master/sumstats.py zscore --sumstats PGC_AN_2019.csv | \
python3.7 /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/convert/python_convert-master/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 | \
python3.7 /home/$USER/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/convert/python_convert-master/sumstats.py neff --drop --factor 4 --out PGC_AN_2019_qc_noMHC.csv --force
gzip PGC_AN_2019_qc_noMHC.csv

# The first line of code convert the summary statics into a standerized CSV
#-- force: overrised existing files if needed. auto:automatically detects file formate
# head: dertimes collum names. 

# line 2 computes z-scores for effect sizes
# Line 3 removes some sNP from cromosone 6 due to strong LD + sets a max value for the odd ratio

# Line 4: Neff is efective sample size. this acount for difference in sample sizes. And then drops
# the SNP that do not meet the min effective sample size.
