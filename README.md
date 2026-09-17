# Opgave 1 - Parser opgave

## Beskrivelse af projektet
Dette projekt er et program, som læser en CSV-fil og parser indholdet til en datastruktur i form af et data frame. 
Programmet kan desuden konvertere det parsede data frame til en JSON-repræsentation og returnerer både 'data.frame' og JSON-output.

## Beskrivelse af, hvordan projektet bygges, testes og køres
### Byg programmet
Programmet er udviklet i R og bruger pakken 'jsonlite' til at konvertere data til JSON-format. 
Programmet består af to funktioner:
- 'parse_csv()' læser en CSV-fil, parser indholdet og returnerer et data.frame og en JSON-repræsentation.
- 'parse_row()' parser en CSV-række ad gangen og håndterer blandt andet quoted felter og escaped citationstegn efter RFC 4180. 

### Test programmet
Programmet testes med enhedstest ved hjælp af pakken 'testthat'. Testene dækker både normale CSV-filer og forskellige edge cases, herunder:
- simpel CSV-fil,
- 'employees.ascii.csv',
- 'sogne.dawa.csv',
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
Programmet køres ved at køre scriptet 'run_parse_csv.R', som indlæser parseren og beder brugeren om navnet på en CSV-fil, der skal parses. Brugeren indtaster navnet på den ønskede CSV-fil, for eksempel 'employees.ascii.csv' eller 'sogne.dawa.csv'. Programmet parser derefter filen og udskriver både 'data.frame' og JSON-output.

## Beskrivelse af den implementerede softwarearkitektur
Programmet er opdelt i to funktioner. 
'parse_csv()' styrer hele parserprocessen. Funktionen læser CSV-filen som tekst, opdeler teksten i linjer, parser kolonnenavne og datarækker, kontrollerer at alle rækker har det korrekte antal felter, opretter et 'data.frame' og konverterer resultatet til JSON.

'parse_row()' parser en CSV-række ad gangen. Funktionen gennemgår rækken tegn for tegn og håndterer kommaer uden for citationstegn, qouted felter og escaped citationstegn.

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
|   Opret data.frame        |
|   og tildel kolonnenavne  |
+---------------------------+
              |
              v
+---------------------------+
|   Konverter data.frame    |
|   til JSON-repræsentation |
+---------------------------+
              |
              v
+---------------------------+
| Returnér en liste med     |
| data.frame og JSON-output |
+---------------------------+
```







