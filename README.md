# Opgave 1 - Parser opgave

## Beskrivelse af projektet
Dette projekt er et program, som læser en CSV-fil og parser indholdet til en datastruktur i form af et data frame. 
Programmet kan desuden konvertere det parsede data frame til både en almindelig JSON-repræsentation og en hierarkisk JSON-struktur, hvor data kan grupperes efter en eller to valgte kolonner.

## Beskrivelse af, hvordan projektet bygges, testes og køres
### Byg programmet
Programmet er udviklet i R og består af tre filer:
- `parse_csv.R` indeholder parserens funktioner.
- `run_parse_csv.R` er programmet, som brugeren kører.
- `test_parse_csv.R` indeholder enhedstest for parseren og dens funktioner.

Programmet består af fire funktioner:
- `parse_csv()` læser en CSV-fil, parser indholdet og returnerer et `data.frame` og en JSON-repræsentation.
- `parse_row()` parser en CSV-række ad gangen og håndterer blandt andet quoted felter og escaped citationstegn.
- `data_to_json()` konverterer data framet til JSON-repræsentation.
- `hierarchical_json()` konverterer data framet til en hierarkisk JSON-struktur ved at gruppere data efter en eller to valgte kolonner.

### Test programmet
Programmet testes med enhedstest ved hjælp af pakken `testthat`. Testene dækker både normale CSV-filer og forskellige edge cases, herunder:
- simpel CSV-fil,
- `employees.ascii.csv`,
- `sogne.dawa.csv`,
- fil med kun en header,
- fil med kun en datarække,
- fil med kun en kolonne,
- filer med for mange eller for få felter,
- tomme felter,
- mellemrum i felter,
- komma i qouted felter,
- komma og citationstegn i samme felt,
- escaped citationstegn,
- uafsluttet quoted felt,
- tomt qouted felt,
- danske tegn,
- specialtegn,
- numeriske værdier,
- tom sidste linje,
- tom linje midt i filen,
- tom fil,
- filer med og uden header,
- JSON-repræsentation.

### Kør programmet
Programmet køres ved at køre scriptet `run_parse_csv.R`, som indlæser parseren og beder brugeren om navnet på den CSV-fil, der skal parses. Brugeren indtaster navnet på den ønskede CSV-fil, for eksempel `employees.ascii.csv` eller `sogne.dawa.csv`. Derefter beder programmet brugeren om at angive, om filen indeholder en header ved at indtaste `TRUE` eller `FALSE`. Programmet parser herefter filen til et `data.frame` og omdanner dette `data.frame` til JSON-repræsentation. Programmet returnerer en liste, som indeholder både data framet og JSON-outputtet og resultaterne udskrives. Brugeren kan desuden vælge at oprette en hierarkisk JSON-struktur ved at angive en eller to koloner, som dataene skal grupperes efter. For eksempel kan `employees.ascii.csv` grupperes efter `office` og `department`, så medarbejderne organiseres efter kontor og derefter afdeling. Programmet opretter samtidig JSON-filer med outputtet, så resultaterne gemmes som både almindelig JSON og eventuelt hierarkisk JSON.

## Beskrivelse af den implementerede softwarearkitektur
Programmet er opdelt i fire funktioner:
`parse_csv()` styrer hele parserprocessen. Funktionen læser CSV-filen som tekst, opdeler teksten i linjer, parser kolonnenavne og datarækker, kontrollerer at alle rækker har det korrekte antal felter, opretter et `data.frame` og konverterer resultatet til JSON-repræsentation. Funktionen har også argumentet `has_header`, hvor brugeren kan angive `TRUE` eller `FALSE` afhængigt af, om CSV-filen indeholder en header. Som standard antager funktionen, at CSV-filen indeholder en header. Hvis `has_header = TRUE`, bruges den første række som kolonnenavne. Hvis `has_header = FALSE`, oprettes der kolonnenavne (V1, V2, ...), og alle rækker behandles som data.

`parse_row()` parser en CSV-række ad gangen. Funktionen gennemgår rækken tegn for tegn og håndterer kommaer uden for citationstegn, qouted felter og escaped citationstegn.

`data_to_json()` konverterer det færdige `data.frame` til JSON-repræsentation. Funktionen gennemgår hver række og kolonne i `data.frame` og opbygger JSON-strengen ved at samle felterne til JSON-objekter og derefter samle alle objekterne i et JSON-array.

`hierarchical_json()` konverterer `data.frame` til hierakisk JSON-struktur. Funktionen har argumenterne `group1` og `group2 = NULL`, hvor `group1` angiver den første kolonne, der skal grupperes efter, og `group2` er en valgfri anden kolonne til et ekstra hierarkisk niveau. 

Programmet fungerer i følgende trin:
1. CSV-filen læses ind som en tekststreng.
2. Tekststrengen opdeles i linjer.
3. Den første linje bruges som kolonnenavne, hvis `has_header = TRUE`. Hvis `has_header = FALSE`, oprettes der kolonnenavne (V1, V2, V3, ...).
4. De resterende linjer parseres række for række og samles i et `data.frame`.
5. Programmet kontrollerer, at alle rækker indeholder det samme antal felter som headeren.
6. Data framet sendes til funktionen `data_to_json()`.
7. Hver række og kolonne gennemgås, og der opbygges en JSON-streng.
8. Programmet udskriver `data.frame` og JSON-repræsentationen og gemmer JSON-outputtet i en json-fil.
9. Brugeren kan vælge at oprette en hierakisk JSON-struktur ved at angive en eller to kolonner, som dataene skal grupperes efter.
10. Data framet sendes til funktionen `hierarchical_json()`, som grupperer data efter de valgte kolonner og opbygger en hierarkisk JSON-struktur.
11. Det hierarkiske JSON-output udskrives og gemmes samtidig som en json-fil.

## UML-diagram
```
+---------------------------+
|          CSV fil          |
+---------------------------+
              |
              v
+---------------------------+
|     Læs fil som tekst     |
+---------------------------+
              |
              v
+---------------------------+
|     Del tekst i linjer    |
+---------------------------+
              |
              v
+---------------------------+
| Hent første linje som     |
| kolonnenavne (eller opret |
| V1, V2, V3, ...)          |
+---------------------------+
              |
              v
+---------------------------+
|    Parse datarækkerne     |
+---------------------------+
              |
              v
+---------------------------+
|    Kontroller antal       |
|    felter i hver række    |
+---------------------------+
              |
              v
+---------------------------+
|  Opret data.frame         |
|  og tildel kolonnenavne   |
+---------------------------+
              |
              v
+---------------------------+
|  Konverter data.frame     |
|  til JSON-repræsentation  |
+---------------------------+
              |
              v
+---------------------------+
|   Udskriv data.frame og   |
|   JSON-output og gem      |
|   JSON-fil                |
+---------------------------+
              |
              v
    +-------------------+
    | Hierarkisk JSON?  |
    +-------------------+
      |               |
     Nej             Ja
      |               |
      |               v
      |     +-----------------------+
      |     |  Vælg group1 og evt   |
      |     |  group2               |
      |     +-----------------------+
      |               |
      |               v
      |     +-----------------------+
      |     | Opret hierarkisk JSON |
      |     +-----------------------+
      |               | 
      |               v
      |     +-----------------------+
      |     |  Udskriv og gem       |
      |     |  hierarkisk JSON-fil  |
      |     +-----------------------+
      |               |
      +---------------+
              |
              v
+---------------------------+
|        Program slut       |
+---------------------------+
```







