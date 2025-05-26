# Genetisk Overlap i Mentale Sygdomme 

Dette repository indeholder kode, visualiseringer og baggrundsmateriale til dataprojektet om genetisk overlap mellem mentale sygdomme, hvor MiXer-metoden er anvendt.

## Indholdsfortegnelse

- [Introduktion](#introduktion)
- [Projektstruktur](#projektstruktur)
- [Outputfiler](#Outputfiler)
- [Data](#Data)
  - [Oprindelse af data](#Oprindelse-af-data)
  - [Hvad er GWAS-summary statistics](Hvad-er-GWAS-summary-statistics)
- [Kode](#kode)
  - [Univariat analyse](#univariat-analyse)
  - [Bivariat analyse](#bivariat-analyse)
  - [Visualiseringskode](#visualiseringskode)
- [Visualiseringer](#visualiseringer)
- [Ekstra læsning](#ekstra-læsning)

## Introduktion

Kort beskrivelse af projektets formål, problemstilling og hvorfor MiXer-metoden er valgt.

## Projektstruktur
Projektet er organiseret i tre hovedmapper, så du nemt kan finde data, kode og resultater:
- CSV filer:
Indeholder alle CSV-filer, der er blevet produceret fra analyserne. Her ligger både rå og behandlede data samt output fra de forskellige analyser.

- code:
Indeholder al kode, opdelt i undermapper efter analysetype:

  - Bivariate: Kode til bivariate analyser (genetisk overlap mellem to træk).
  - Univariate: Kode til univariate analyser (genetisk arkitektur for ét træk).
  - Robusthed: Kode til robusthedsanalyser (gentagne analyser med forskellige referenceudsnit).
  - Reference: Kode og scripts af referencepaneler.
  - Visualiseringer: Kode til at generere plots og figurer.

- figures:
Indeholder alle genererede figurer og plots.
Denne mappe har to undermapper:

  - Bivariateplots: Indeholder alle bivariate plots fra analyserne.
  - Robusthedsplots: Indeholder alle plots fra robusthedsanalyserne.

### Sådan bruger du README-filen
README-filen fungerer som en guide til projektet.
Når du læser README’en, vil du løbende finde links til de relevante mapper og scripts. Følg teksten og linksene for at få en logisk gennemgang af projektets arbejdsgang – fra data og analyser til visualiseringer og resultater.

#### Tip:
Hvis under tidsbegrænsning, for at få et overblik over projektets workflow og vigtigste resultater, anbefaler vi at læse afsnittene om:
Univariat analyse
Bivariat analyse
Visualiseringer
Her finder du både forklaringer, eksempler og direkte links til kode og figurer.

## Outputfiler
Alle resultater fra analyserne bliver gemt som CSV-filer i mappen CSV filer. Disse outputfiler indeholder de estimerede parametre, statistikker og resultater fra både de univariate og bivariate analyser.
[Se mappen her](CSV filer) 

## Data
### Oprindelse af data

Alle anvendte data er hentet fra [GWAS Catalog](https://www.ebi.ac.uk/gwas/). Da datasættene indeholder mange tusinde rækker og fylder meget, er det ikke muligt at inkludere dem direkte i GitHub-repositoriet. Hvis du ønsker at genskabe analyserne, kan du selv downloade dataene fra ovenstående kilde.

### Hvad er GWAS-summary statistics
I dette projekt anvendes GWAS-summary statistics som grunddata for vores univariate analyser.
GWAS (Genome-Wide Association Studies) er store genetiske undersøgelser, hvor man undersøger sammenhængen mellem genetiske varianter (typisk SNPs) og en bestemt sygdom eller egenskab.
Summary statistics er resultaterne fra disse undersøgelser, typisk i form af tabeller, hvor hver række svarer til én genetisk variant og indeholder information om fx:

SNP-ID (navn på varianten)
Hvilke alleler der er undersøgt (A1/A2)
Effektstørrelse (hvor meget varianten påvirker sygdommen)
Standardfejl og p-værdi (statistisk usikkerhed og signifikans)
Antal cases og kontroller

Summary statistics bruges som input til MiXeR-analyserne, hvor de danner grundlag for at estimere, hvor mange genetiske varianter der bidrager til en sygdom, og hvor meget genetisk overlap der er mellem forskellige sygdomme eller træk.

## Kode
Her findes en beskrivelse af al kode, der er blevet brugt i projektet.
Før analyserne kan køres, skal summary statistics forbehandles og konverteres til det rigtige format. Dette indebærer at indlæse rådata, omdøbe kolonner og gemme data i et format, der kan bruges i MiXeR-analysen.
Alle resultater fra analyserne bliver gemt som CSV-filer i mappen CSV filer
[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Univariate/summary_stats_an.sh)

Bemærk: Koden, som er vist her i projektet, kan ikke køres direkte, da filstierne og miljøet er tilpasset et High Performance Computing (HPC) cluster. 
### Univariat analyse
Den univariate analyse bruges til at estimere, hvor mange SNP's der samlet set har indflydelse på risikoen for en mental lidelse, samt styrken af de genetiske bidrag. Dette gøres for én enkelt mental lidelse (eller et andet træk) ad gangen og er baseret på GWAS-summary statistics.

Koden er delt op i en fit-kode og en test-kode.

#### Fit kode
Denne kode kører MiXeR’s univariate fit-analyse på et sæt GWAS-summary statistics. Koden læser først GWAS-dataene fra den angivne fil og udvælger de SNPs, der skal indgå i analysen, baseret på en separat liste. I koden bruges der referencefiler, der indeholder information om SNP-positioner og deres indbyrdes genetiske sammenhæng (linkage disequilibrium).
[Se mappen her](code/Reference)
Ud fra dette estimerer MiXeR en statistisk model, der beskriver, hvor mange SNP's der har betydning for den mentale lidelse, og hvordan deres effekter er fordelt. Resultaterne gemmes i en outputfil, som kan bruges til videre analyser. 

[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Univariate/univariate_an_fit.sh)


#### Test kode
Denne kode anvender MiXeR’s test-funktion til at evaluere den statistiske model, der blev estimeret med fit-analysen. Koden indlæser de samme GWAS-summary statistics samt de parametre, der blev beregnet i fit-trinnet (fra en JSON-fil). Med de samme referencefiler for SNP's og deres indbyrdes sammenhæng tester MiXeR, hvor godt den estimerede model passer til de observerede data. Resultatet gemmes i en outputfil 

[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Univariate/univariate_an_test.sh)

### Bivariat analyse
Den bivariate analyse med MiXeR bruges til at undersøge, hvor meget anoreksi og en anden mental lidelse eller et andet træk deler af deres genetiske baggrund, baseret på GWAS-summary statistics. I alle bivariate analyser i dette projekt indgår anoreksi altid som det ene træk. Analysen estimerer både, hvor mange SNPs der er unikke for anoreksi, hvor mange der er unikke for det andet træk, og hvor mange der er fælles mellem dem. På den måde giver analysen et detaljeret billede af, hvordan genetiske faktorer er delt eller adskilt mellem anoreksi og andre komplekse sygdomme eller træk.

Som ved de univariate analyser er koden opdelt i en fit-kode og en test-kode.

#### Fit kode
Denne kode udfører en bivariatanalyse med MiXeR, hvor der sammenlignes genetiske data fra anoreksi og en anden mental lidelse eller et andet træk. Koden starter med at indlæse GWAS-summary statistics for både anoreksi og det andet træk samt de parametre, der tidligere er estimeret fra de tilsvarende univariate analyser (fit- og test-outputfiler for hvert træk). Herefter udvælges de SNPs, der skal indgå i analysen, baseret på en foruddefineret liste, og der anvendes referencefiler, som beskriver SNP-positioner og linkage disequilibrium mellem SNPs. Med disse input kører MiXeR’s bivariate fit-model, hvor det estimeres, hvor mange SNPs der er unikke for anoreksi, hvor mange der er unikke for det andet træk, hvor mange der er fælles, og hvordan effekterne af de fælles SNPs fordeler sig mellem de to træk. Resultaterne fra analysen gemmes i en outputfil, som efterfølgende bruges i visualiseringskoden.
[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Bivariate/Bivariate.sh)

#### Test kode 
Denne kode udfører en bivariatanalyse med MiXeR, hvor formålet er at teste og validere den model, der blev estimeret i bivariate fit-trinnet for anoreksi og det andet træk. Koden indlæser GWAS-summary statistics for både anoreksi og det andet træk samt de parametre for genetisk overlap og forskelle, der blev beregnet i den forudgående bivariate fit-analyse. Ved hjælp af de samme referencefiler for SNP-positioner og linkage disequilibrium anvender MiXeR den estimerede model på de observerede data og vurderer, hvor godt modellen passer til dataene for begge træk. Resultaterne fra denne test gemmes i en outputfil, som bruges i visualiseringerne.
[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Bivariate/Apply_Bivariate.sh)

### Visualiseringskode
Til visualisering af vores resultater har vi tre forskellige typer plots:
- Powerplot: Baseret på de univariate analyser for de forskellige mentale lidelser og træk.
- Bivariate plots: Udarbejdet på baggrund af de bivariate analyser, hvor anoreksi altid indgår som det ene træk over for forskellige mentale lidelser eller træk.
- Robusthedsplot: Her undersøges, hvordan resultaterne påvirkes af, hvilke udsnit af referencepanelet der anvendes i analyserne, for at sikre at resultaterne ikke skyldes valg af referencedata.


#### Powerplot
Powerplottet visualiserer, hvor stor en andel af den genetiske variation der kan opdages givet GWAS-størrelse og polygenicitet for de enkelte mentale lidelser og træk.

[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Visualiseringer/Powerplot_samlet.R)

#### Bivariateplot
De bivariate plots fra MiXeR illustrerer det genetiske overlap og forskelle mellem anoreksi og andre mentale lidelser eller træk, baseret på GWAS-summary statistics. For hver bivariatanalyse genereres fire plots:
- Et Venn-diagram, som viser antallet af SNPs, der er unikke for anoreksi, unikke for det andet træk, og som er fælles mellem dem.
- To QQ-plots, der sammenligner de observerede og forventede GWAS test-statistikker for henholdsvis anoreksi og det andet træk.
- Et log-likelihood plot, som viser modellens tilpasning og robusthed.

Venn-diagrammet og log-likelihood plottet laves ud fra outputfilen fra bivariate fit-analysen, mens QQ-plots laves ud fra outputfilen fra bivariate test-analysen.

[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Visualiseringer/Bivariate_visual_ANvsADHD.sh)

#### Robusthedskode
For at undersøge, hvor robuste vores resultater er over for valg af referencepanel, har vi udført en robusthedsanalyse. Her gentog vi den bivariate analyse mellem anoreksi og ADHD fem gange, hvor vi hver gang brugte forskellige udsnit af vores referencepanel. Formålet er at sikre, at vores resultater ikke er drevet af tilfældige variationer i udvalget af reference-SNPs, men faktisk er konsistente på tværs af forskellige datasæt.

I hver iteration blev der genereret en log-likelihood-kurve, som viser modellens tilpasning for det pågældende referenceudsnit. Disse kurver blev herefter sammenlignet og visualiseret samlet, så man kan vurdere variationen mellem de fem analyser.
[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Robusthed/Iterations.py)


## Visualiseringer

- **Powerplot**:
![Powerplot for alt data](https://github.com/LaerkeE/Project/blob/main/figures/Powerplot.png)
Powerplottet bruges som en grafisk fremstilling, til at vise, hvor stor en andel af den genetiske arvelighed, vi forventer at kunne detektere i en GWAS, afhængigt af sample size. Powerplottet illustrerer altså, hvor stor en stikprøvestørrelse der skal til for at forklare en bestemt andel af arvbarheden for den givne lidelse eller træk.
I vores powerplot kan vi se, at data for kontinuerte træk (fx Hight) har en højere power end data for binære mentale lidelser (fx anoreksi).
Ud fra powerplottet kan vi se at ud fra vores data er det mulighed at forklarer 76 % af arvligheden for Height, 21 % af arveligheden for BMI og 13 % af arveligheden for educational attainment. 
Derimod kan vi kun forklarer 1 % af arveligheden af ADHD og 0 % af arveligheden for henholdsvis persistent thinness, Autisme og anoreksi. 
Det giver os også en idé om, hvor meget mere vi kunne opdage ved at øge stikprøvestørrelsen.
- **Bivariateplot**:
 ![Bivariateplot for AN vs ADHD](https://github.com/LaerkeE/Project/blob/main/figures/Bivariate_plots/PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_Visualization.png)
På vores bivariate plot har vi 4 forskellige figure. Et venn diagram, to QQ plots og et log-likelighood plot
   [Se resten af plotene her](figures/Bivariate_plots) 
- **Robusthedplot**:
![Robushed log-likelihood plot](https://github.com/LaerkeE/Project/blob/main/figures/Robustheds_plots/loglikelihood_models.png)
  [Se resten af plotene her](figures/Robustheds_plots) 
## Ekstra læsning

Hvis ektra tid kan denne artikel læses angående MiXeR metoden
[Se artiklen her](https://psychiatryonline.org/doi/10.1176/appi.ajp.21101051)

