# Genetisk Overlap i Mentale Sygdomme 

Dette repository indeholder kode, visualiseringer og baggrundsmateriale til dataprojektet om genetisk overlap mellem mentale sygdomme, hvor MiXer-metoden er anvendt.

## Indholdsfortegnelse

- [Introduktion](#introduktion)
- [Projektstruktur](#projektstruktur)
- [Kode](#kode)
  - [Univariat analyse](#univariat-analyse)
  - [Bivariat analyse](#bivariat-analyse)
  - [Visualiseringskode](#visualiseringskode)
- [Visualiseringer](#visualiseringer)
- [Ekstra læsning](#ekstra-læsning)

## Introduktion

Kort beskrivelse af projektets formål, problemstilling og hvorfor MiXer-metoden er valgt.

## Projektstruktur

Forklaring af mappestruktur og hvad de enkelte mapper/sektioner indeholder.

## Kode
Her Findes en beskrivelse af alt kode der er blevet brugt i projektet.
*Måske nævne noget med at downloade summary statistic* 
Den samme kode er blevet brugt på forskellige mentale lidelser og træk, og der ikke være alt kodefiler i mapperne da de er ens udover den data der er blevet brugt
### Univariat analyse
Den Univariate analyse bruges til at estimere hvor mange genetiske varianter der samlet set har indflydelse på risikoen for den mentale lidelse, samt Styrken af de genetiske bidrag. Dette gøres for én enkelt mental lidelse (Eller et andet træk) af gangen. Dette er baseret på GWAS-summary statistics.

Koden er delt op i en fit kode og en test kode

#### Fit kode
Denne kode kører MiXeR’s univariate fit-analyse på et sæt GWAS-summary statistics. Koden læser først GWAS-dataene fra den angivne fil og udvælger de SNPs, der skal indgå i analysen, baseret på en separat liste. I koden bruges der referencefiler, der indeholder information om SNP-positioner og deres indbyrdes genetiske sammenhæng (linkage disequilibrium). Ud fra dette estimerer MiXeR en statistisk model, der beskriver, hvor mange genetiske varianter der har betydning for egenskaben, og hvordan deres effekter er fordelt. Resultaterne gemmes i en outputfil, som kan bruges til videre analyser. 

#### Test kode
Denne kode anvender MiXeR’s test-funktion til at evaluere den statistiske model, der blev estimeret med fit-analysen. Koden indlæser de samme GWAS-summary statistics samt de parametre, der blev beregnet i fit-trinnet (fra en JSON-fil). Med de samme referencefiler for genetiske varianter og deres indbyrdes sammenhæng tester MiXeR, hvor godt den estimerede model passer til de observerede data. Resultatet gemmes i en outputfil 

### Bivariat analyse
Beskrivelse og kode til bivariat analyse.

### Visualiseringskode
Kode til at generere figurer.

#### Powerplot
Kode og kort beskrivelse.

#### Bivariateplot
Kode og kort beskrivelse.

## Visualiseringer

- **Powerplot**: Forklaring og billede/link.
- **Bivariateplot**: Forklaring og billede/link.
- **Robusthedplot**: Forklaring og billede/link.

## Ekstra læsning

Links til relevante artikler, dokumentation og evt. slides.

