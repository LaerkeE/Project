library(qqman)

library(data.table)

# ADHD
adhd <- read.table(gzfile("/home/user/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/ADHD/ADHD2022_iPSYCH_deCODE_PGC.meta.gz"), header = TRUE)

manhattan_adhd <- adhd[, c("CHR", "BP", "SNP", "P")]

#snpsOfInterest_adhd <- manhattan_adhd[manhattan_adhd$P < 5e-8, ]

## Plots
manhattan(manhattan_adhd,  chr="CHR", bp="BP", snp="SNP", p="P", ylim=c(0, 15), annotatePval = 5e-8, main = "Manhattan plot ADHD")

hist(manhattan_adhd$P, breaks = 50, main = "Distribution of p-values ADHD", xlab = "p-value")

# Anoreksi
an <- read.table(gzfile("/home/laerkeelbaek/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Anoreksi/cleaned_pgc_AN_2019.csv.gz"), header = TRUE)

manhattan_an <- an[, c("CHROM", "POS", "SNP", "PVAL")]

#snpsOfInterest_an <- manhattan_an[manhattan_an$PVAL < 5e-8, ]

## Plots
manhattan(manhattan_an,  chr="CHROM", bp="POS", snp="SNP", p="PVAL", ylim=c(0, 15), annotatePval = 5e-8, main = "Manhattan plot AN")

hist(manhattan_an$PVAL, breaks = 50, main = "Distribution of p-values AN", xlab = "p-value")

# Autisme
asd <- read.table(gzfile("/home/laerkeelbaek/NCRR-PRS/faststorage/kimhoc/data_science_project_2025/data_raw/Autisme/iPSYCH-PGC_ASD_Nov2017.gz"), header = TRUE)

manhattan_asd <- asd[, c("CHR", "BP", "SNP", "P")]

#snpsOfInterest_asd <- manhattan_asd[manhattan_asd$P < 5e-8, ]

## Plots
manhattan(manhattan_asd,  chr="CHR", bp="BP", snp="SNP", p="P", ylim=c(0, 15), annotatePval = 5e-8, main = "Manhattan plot ASD")

hist(manhattan_asd$P, breaks = 50, main = "Distribution of p-values ASD", xlab = "p-value")
