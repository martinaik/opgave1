# Opgave 1 - Parser opgave

## Beskrivelse af projektet
Dette projekt er et program, som tager en CSV-formateret tekststreng som input og parser denne til en datastruktur i form af et data frame. Programmet kan fx læse tekststrengen fra en fil. 
Programmet kan desuden konvertere de parsede data til JSON-repræsentation.

## Beskrivelse af, hvordan projektet bygges, testes og køres
### Byg programmet
Programmet udvikles i R. 
Programmet består af en funktion parse_csv(), som tager en CSV-formateret tekststreng som input og parser denne til et data frame. 

### Test programmet
...

### Kør programmet
Programmet køres ved at læse en CSV-fil ind som en tekststreng og give den som input til funktionen parse_csv(). Funktionen parser CSV-indholdet til et data.frame og omskriver derefter dette til JSON-repræsentation. Funktionen returnerer en liste med data framet og JSON outputtet.

## Beskrivelse af den implementerede softwarearkitektur
...

## UML-diagram
+---------------------+
|      CSV tekst      |
+---------------------+
           |
           v
+---------------------+
|  Del tekst i linjer |
+---------------------+
           |
           v
+---------------------+
|  Hent første linje  |
|   som kolonnenavne  |
+---------------------+
           |
           v
+---------------------+
|   Parse de øvrige   |
|  linjer til rækker  |
+---------------------+
           |
           v
+---------------------+
|  Opret data.frame   |
|  og tildel headers  |
+---------------------+
           |
           v
+---------------------+
|  Omskriv til JSON-  |
|    repræsentation   |
+---------------------+
           |
           v
+---------------------+
|  Returnér en liste  |
|  med data.frame og  |
|     JSON output     |
+---------------------+








