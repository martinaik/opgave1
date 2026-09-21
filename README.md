# Opgave 1 - Parser opgave

## Beskrivelse af projektet
Dette projekt er et program, som læser en CSV-fil og parser indholdet til en datastruktur i form af et data frame. 
Programmet kan desuden konvertere det parsede data frame til en JSON-repræsentation og returnerer både `data.frame` og JSON-output.

## Beskrivelse af, hvordan projektet bygges, testes og køres
### Byg programmet
Programmet er udviklet i R. 
Programmet består af tre funktioner:
- `parse_csv()` læser en CSV-fil, parser indholdet og returnerer et `data.frame` og en JSON-repræsentation.
- `parse_row()` parser en CSV-række ad gangen og håndterer blandt andet quoted felter og escaped citationstegn.
- `data_to_json()` konverterer data framet til JSON-repræsentation.

### Test programmet
Programmet testes med enhedstest ved hjælp af pakken `testthat`. Testene dækker både normale CSV-filer og forskellige edge cases, herunder:
- simpel CSV-fil,
- `employees.ascii.csv`,
- `sogne.dawa.csv`,
- fil med kun en header,
- fil med kun en datarække,
- tomme felter,
- mellemrum i felter
- filer med for mange eller for få felter,
- komma i qouted felter,
- escaped citationstegn,
- danske tegn,
- tom fil,
- tom sidste linje,
- JSON-output

### Kør programmet
Programmet køres ved at køre scriptet `run_parse_csv.R`, som indlæser parseren og beder brugeren om navnet på en CSV-fil, der skal parses. Brugeren indtaster navnet på den ønskede CSV-fil, for eksempel `employees.ascii.csv` eller `sogne.dawa.csv`. Programmet parser derefter filen til et data frame og omdanner dette data frame til JSON-repræsentation. Programmet returnerer til sidst en liste, som indeholder både data framet og JSON-outputtet.

## Beskrivelse af den implementerede softwarearkitektur
Programmet er opdelt i tre funktioner. 
`parse_csv()` styrer hele parserprocessen. Funktionen læser CSV-filen som tekst, opdeler teksten i linjer, parser kolonnenavne og datarækker, kontrollerer at alle rækker har det korrekte antal felter, opretter et `data.frame` og konverterer resultatet til JSON-repræsentation.

`parse_row()` parser en CSV-række ad gangen. Funktionen gennemgår rækken tegn for tegn og håndterer kommaer uden for citationstegn, qouted felter og escaped citationstegn.

`data_to_json()` konverterer det færdige `data.frame` til JSON-repræsentation. Funktionen gennemgår hver række og kolonne i `data.frame` og opbygger JSON-strengen ved at samle felterne til JSON-objekter og derefter samle alle objekterne i et JSON-array.

Programmet fungerer i følgende trin:
1. CSV-filen læses ind som en tekststreng.
2. Tekststrengen opdeles i linjer.
3. Den første linje bruges som kolonnenavne.
4. De resterende linjer opdeles i rækker og samles i et `data.frame`.
5. Data framet sendes til funktionen `data_to_json()`.
6. Hver række og kolonne gennemgås, og der opbygges en JSON-streng.
7. Programmet returnerer en liste med både `data.frame` og JSON-output.

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
|     Hent første linje     |
|     som kolonnenavne      |
+---------------------------+
              |
              v
+---------------------------+
|     Parse de øvrige       |
|     linjer til rækker     |
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
| Returnér en liste med     |
| data.frame og JSON-output |
+---------------------------+
```







