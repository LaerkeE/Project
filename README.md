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

Projektet går ud på at undersøge sammenhængen mellem genetiske varianter (forskelle i DNA-sekvensen mellem individer) og mentale lidelser. Specifikt undersøges sammenhængen mellem anoreksi og udvalgte neuropsykiatriske udviklingsforstyrelser. Målet er at estimere genetisk korrelation, andelen af delte varianter mellem disse træk og hvorvidt de overlappende genetiske varianter har en ensartet eller modsatvirkende effekt.

Analysen udføres ved hjælp af MiXeR-softwaren på et High Performance Cluster (HPC). MiXeR er en statistisk metode, der estimerer polygenicitet og genetisk overlap mellem træk ud fra GWAS summary statistics.

Modellen antager, at effekterne af genetiske varianter kan opdeles i to grupper:

- Kausale varianter, som har en reel effekt, hvor effektstørrelserne følger en normalfordeling.
- Ikke-kausale varianter, som antages at have præcis nul effekt.

Det kan udtrykkes matematisk som:

$$\beta\sim\pi_1\cdot N(0,\sigma_\beta^2)+(1-\pi_1)\cdot N(0,0)$$

hvor:

- $\pi_1$ er sandsynligheden for, at en variant er kausal.
- $\sigma_\beta^2$ er variansen af effektstørrelserne for de kausale varianter.
- N(0,0) repræsenterer i praksis Dirac delta-funktionen.

Ved at anvende en bivariat mixture-model estimerer MiXeR:

- Antal varianter med fælles kausal effekt på begge træk.
- Antal varianter, der er specifikke for hvert træk.
- Antal varianter uden effekt på nogen af trækkene.

Modelparametre estimeres ved at matche den observerede fordeling af z-scorer til modellens forventede fordeling.
Dette gøres ved at maksimere en multinomial likelihood vha. numerisk optimering (Nelder-Mead).


Analysen er udført via GenomeDK, et linux baseret HPC miljø. GenomeDK er anvendt for at kunne håndtere og analysere de store datamængder, som arbejdet med genetiske data fra GWAS kræver.

Som en del af projektet har vi derfor skullet lære at navigere i systemet, herunder arbejde i terminalmiljø, håndtere filer og afvikle kode på et HPC. Analyserne kan desuden være tidskrævende - både på grund af lange beregningstider og fordi man ofte skal vente i kø, før ens job bliver kørt.

## Projektstruktur
Projektet er organiseret i tre hovedmapper, så du nemt kan finde data, kode og resultater:
- CSV filer:
Indeholder alle CSV-filer, der er blevet produceret fra analyserne. Her ligger behandlede data samt output fra de forskellige analyser.

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
Hvis under tidpress, for at få et overblik over projektets workflow og vigtigste resultater, anbefaler vi at læse afsnittene om:

- Univariat analyse
- Bivariat analyse
- Visualiseringer

Her finder du både forklaringer, eksempler og direkte links til kode og figurer.

## Outputfiler
Alle resultater fra analyserne bliver gemt som CSV-filer i mappen CSV filer. Disse outputfiler indeholder de estimerede parametre, statistikker og resultater fra både de univariate og bivariate analyser.
[Se mappen her](https://github.com/LaerkeE/Project/tree/main/CSV%20filer) 

## Data
### Oprindelse af data

Alle anvendte data er hentet fra [GWAS Catalog](https://www.ebi.ac.uk/gwas/). Da datasættene indeholder mange tusinde rækker og fylder meget, er det ikke muligt at inkludere dem direkte i GitHub-repositoriet. Hvis man ønsker at se dataen, kan man downloade dataene fra ovenstående kilde.

### Hvad er GWAS-summary statistics
I dette projekt anvendes GWAS-summary statistics som grunddata for vores analyser.
GWAS (Genome-Wide Association Studies) er store genetiske undersøgelser, hvor man undersøger sammenhængen mellem genetiske varianter (typisk SNPs) og en bestemt sygdom eller egenskab.
Summary statistics er resultaterne fra disse undersøgelser, typisk i form af tabeller, hvor hver række svarer til én genetisk variant og indeholder information om fx:

SNP-ID (navn på varianten)
Hvilke alleler der er undersøgt (A1/A2)
Effektstørrelse (hvor meget varianten påvirker sygdommen)
Standardfejl og p-værdi (statistisk usikkerhed og signifikans)
Antal cases og kontroller

Summary statistics bruges som input til MiXeR-analyserne, hvor de danner grundlag for at estimere, hvor mange genetiske varianter der bidrager til en sygdom, og hvor meget genetisk overlap der er mellem forskellige sygdomme eller træk.

![Manhatten plot](https://github.com/LaerkeE/Project/blob/main/figures/Sk%C3%A6rmbillede%202025-02-17%20172026.png)

Et Manhattan-plot er en grafisk præsentation af resultaterne fra GWAS, hvor man visualiserer styrken af associationen mellem SNPs og et givent træk på tværs af hele genomet.

På plottet:

- X-aksen viser de genetiske positioner, sorteret efter kromosomer.
- Y-aksen viser $-log_{10}$(p)-værdien for hver SNP - jo højere punktet er, desto stærkere er den statistiske evidens for association.

Tærsklen for genome-wide signifikans vises ved den røde horisontale linje ($p=5\times10^{-8}$).

Manhattan-plottet bruges til at give et hurtigt overblik over, hvilke områder af genomet der indeholder signifikante signaler.

## Kode
Her findes en beskrivelse af al kode, der er blevet brugt i projektet.
Før analyserne kan køres, skal summary statistics forbehandles og konverteres til det rigtige format. Dette indebærer at indlæse rådata, omdøbe kolonner og gemme data i et format, der kan bruges i MiXeR-analysen.
Alle resultater fra analyserne bliver gemt som CSV-filer i mappen CSV filer
[Se scriptet her](https://github.com/LaerkeE/Project/blob/main/code/Univariate/summary_stats_an.sh)

Bemærk: Koden, som er vist her i projektet, kan ikke køres direkte, da filstierne og miljøet er tilpasset et High Performance Computing (HPC) cluster. 
### Univariat analyse
Den univariate analyse bruges til at estimere, hvor mange SNP's der samlet set har indflydelse på risikoen for en mental lidelse. Dette gøres for én enkelt mental lidelse (eller et andet træk) ad gangen og er baseret på GWAS-summary statistics.

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
I vores powerplot kan vi se, at data for kontinuerte træk (fx Height) har en højere power end data for binære mentale lidelser (fx anoreksi).
Ud fra powerplottet ses det, at med vores data er det muligt at forklare 76 % af SNP arveligheden for height, 21 % af arveligheden for BMI og 13 % af arveligheden for educational attainment. 
Derimod kan vi kun forklare 1 % af arveligheden for ADHD og 0 % af arveligheden for henholdsvis persistent thinness, autisme og anoreksi. 
Det giver os også en idé om, hvor meget mere vi kunne opdage ved at øge stikprøvestørrelsen.
- **Bivariateplot**:
 ![Bivariateplot for AN vs ADHD](https://github.com/LaerkeE/Project/blob/main/figures/Bivariate_plots/PGC_AN_2019_qc_noMHC_vs_ADHD_2022_noMHC_Visualization.png)
På vores bivariate plot har vi 4 forskellige figurer. Et venn diagram, to QQ plots og et log-likelighood plot.

#### Venn diagrammet
Venn-diagrammet viser det gennemsnitlige antal kausale varianter (i tusinder), der er nødvendige for at forklare 90% af SNP-baseret arvelighed (h2SNP) for de to træk.
Diagrammet er delt i tre områder:
Kun anoreksi: Antal kausale varianter, der kun er forbundet med anoreksi.

- **Kun det andet træk eller mentale lidelse:** Antal kausale varianter, der kun er forbundet med det andet træk eller mentale lidelse.
- **Delte varianter**: Antal kausale varianter, der er fælles for begge træk og forklarer 90% af den genetiske variation. Estimatets standardafvigelse er angivet i parentes.
Disse tal beregnes ved at simulere 10.000 kausale effekter, sortere dem efter effektstyrke og identificere, hvor stor en andel (π₁₂ · Nₛₙₚ) der samlet forklarer 90% af arveligheden.
Under Venn diagrammet har vi en tabel som indeholder
- **Genetisk korrelation (rg):** Udtrykker den total genetiske korrelation. Altså hvor meget af den genetiske variation der er fælles mellem de to træk.
- **Korrelation af delte varianter (𝜌𝛽):** Hvor ens effekterne er for de varianter, der påvirker begge træk.
- **Konkordansrate (cr):** Andelen af delte varianter, der har samme effektretning på begge træk.
  
#### QQ-plots

QQ-plots bruges til at vise, om der er flere genetiske sammenhænge mellem to træk, end forventet ved tilfældighed.  
Der laves to QQ-plots per analyse:  
- Trait1 | Trait2: Viser om SNPs, der er associeret med Trait2, også har effekt på Trait1.
- Trait2 | Trait1: Det modsatte.

- **X-akse:** Forventede værdier uden sammenhæng.
- **Y-akse:** Faktiske værdier fra GWAS.
- **Farvet solid linje:** Observeret data for SNP subset.
- **Farvet stiplet linje:** Model forudsigelse for SNP subset.

Hvis de farvede linjer ligger over diagonalen og den blå linje, tyder det på genetisk overlap.  
Hvis solid og stiplet linje følges ad, passer modellen godt til data.  
Hvis de afviger, passer modellen mindre godt for den gruppe.

Overlappet kan være asymmetrisk, især hvis datasættene har forskellig power. Det store datasæt vil lettere opfange signaler, mens det lille datasæt ofte vil følge diagonalen.

#### Log-likelihood plot og AICmin/AICmax

Log-likelihood plottet viser, hvor godt MiXeR-modellen passer til data, sammenlignet med to reference-modeller:

- **AICmin:** Sammenligner MiXeR-modellen med en minimum overlap-model, hvor andelen af delte kausale varianter beregnes ud fra genetisk korrelation og antallet af kausale varianter i hvert træk. En positiv AICmin-værdi betyder, at MiXeR-modellen giver en bedre tilpasning end minimumsmodellen.

- **AICmax:** Sammenligner MiXeR-modellen med en maximum overlap-model, hvor alle kausale varianter i det mindst polygeniske træk også findes i det mest polygeniske træk. En negativ AICmax-værdi kan indikere, at trækkene er næsten identiske, og at en simpel model med fuldt overlap er tilstrækkelig.

Hvis MiXeR-modellen har en positiv AICmin, passer den bedre end minimumsmodellen. Hvis AICmax er negativ, er en model med fuldt overlap tilstrækkelig til at forklare sammenhængen mellem trækkene.

   [Se resten af plotene her](figures/Bivariate_plots) 
- **Robusthedplot**:
![Robushed log-likelihood plot](https://github.com/LaerkeE/Project/blob/main/figures/Robustheds_plots/loglikelihood_models.png)

Dette plot viser log-likelihood-kurverne fra vores fem gentagelser af den bivariate MiXeR-analyse for anoreksi og ADHD. Kurverne er lagt oven i hinanden, så man kan vurdere, hvor stabile modellens resultater er på tværs af forskellige referenceudsnit.

**Sådan vurderes robustheden:**  
Hvis kurverne fra de fem iterationer ligger tæt op ad hinanden, tyder det på, at modellens resultater er robuste og ikke afhænger af det specifikke referencepanel, der er valgt. Store forskelle mellem kurverne kan omvendt indikere, at resultaterne er følsomme over for valg af referencepanel.

Ud over log-likelihood plottet er de øvrige bivariate plots (Venn-diagram og QQ-plots) også genereret for hver iteration og kan findes her
  [Se resten af plotene her](figures/Robustheds_plots) 
## Ekstra læsning

Hvis ektra tid kan denne artikel læses angående MiXeR metoden
[Se artiklen her](https://psychiatryonline.org/doi/10.1176/appi.ajp.21101051)

