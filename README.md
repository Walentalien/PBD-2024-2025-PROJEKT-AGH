# PBD-2024-2025-PROJEKT-AGH
Projekt realizowany w ramach przedmiotu *"Bodstawy baz danych"* na 3. semestrze kierunku Informatyka na AGH

## Peole behind  <!-- (gwaizdka) -->
(Walentyn Olijnyk)[https://github.com/Walentalien]
TODO: Dodaj 1
TODO: Dodaj 2


## Treść
Pełną treść zadania można znaleźć (pod tym linkiem)[

# Opis Schematu Bazy
## People-related tables
### Table *Students*
Zawiera podstawowe informacje o studentach:
- *StudentID* int – klucz główny, identyfikator studenta
- *FirstName*  – imię studenta
- *LastName*  – nazwisko studenta
- Address – adres studenta
- CityID  – identyfikator miasta, z którego pochodzi student
- BirthDate - data urodzenia studenta
- Email   – adres poczty elektronicznej studenta.
- PhoneNumber  – numer telefonu do studenta
```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL foreign key references Cities(CityID),
    BirthDate DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL unique CHECK (Email like '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL unique check (len(PhoneNumber) = 9 and ISNUMERIC(PhoneNumber)),
);
```


###Tabela Cities
Przechowuje informacje o miastach:

- CityID (INT): Klucz główny, unikalny identyfikator miasta.

- City (NVARCHAR(100)): Nazwa miasta, wartość nie może być pusta.

- CountryID (INT): Identyfikator kraju, klucz obcy odnoszący się do Countries(CountryID).

- PostalCode (NVARCHAR(20)): Kod pocztowy, wartość nie może być pusta.

```sql
CREATE TABLE Cities (
    CityID INT PRIMARY KEY,
    City NVARCHAR(100) NOT NULL,
    CountryID INT NOT NULL FOREIGN KEY REFERENCES Countries(CountryID),
    PostalCode NVARCHAR(20) NOT NULL
);
```
###Tabela *Countries*

Przechowuje informacje o krajach:


- CountryID (INT): Klucz główny, unikalny identyfikator kraju.

- CountryName (NVARCHAR(50)): Nazwa kraju, wartość nie może być pusta.

```sql
Copy code
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY,
    CountryName NVARCHAR(50) NOT NULL
);
```

Tabela *Employees*
Przechowuje informacje o pracownikach:


EmployeeID (INT): Klucz główny, unikalny identyfikator pracownika.

FirstName (NVARCHAR(50)): Imię pracownika, wartość nie może być pusta.

SecondName (NVARCHAR(50)): Drugie imię pracownika (opcjonalne).

LastName (NVARCHAR(50)): Nazwisko pracownika, wartość nie może być pusta.

Address (NVARCHAR(255)): Adres pracownika, wartość nie może być pusta.

CityID (INT): Identyfikator miasta, klucz obcy odnoszący się do Cities(CityID).

BirthDate (DATE): Data urodzenia pracownika, wartość nie może być pusta.

HireDate (DATE): Data zatrudnienia pracownika, wartość nie może być pusta.

Email (NVARCHAR(100)): Adres e-mail pracownika, wartość nie może być pusta, musi być zgodna z poprawnym formatem adresu e-mail.

PhoneNumber (NVARCHAR(20)): Numer telefonu pracownika, wartość nie może być pusta, unikalna, musi składać się z 9 cyfr i być numeryczna.

EmployeeFunctionID (INT): Identyfikator funkcji pracownika, klucz obcy odnoszący się do 
EmployeeFunctions(EmployeeFunctionID).

```sql
Copy code
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50),
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL,
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL,
    Email NVARCHAR(100) NOT NULL CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE CHECK (LEN(PhoneNumber) = 9 AND ISNUMERIC(PhoneNumber)),
    EmployeeFunctionID INT NOT NULL FOREIGN KEY REFERENCES EmployeeFunctions(EmployeeFunctionID)
);
```

Tabela *EmployeeFunctions*

Przechowuje informacje o funkcjach pracowników:


EmployeeFunctionID (INT): Klucz główny, unikalny identyfikator funkcji pracownika.
EmployeeFunctionName (NVARCHAR(100)): Nazwa funkcji, wartość nie może być pusta.
sql
Copy code
CREATE TABLE EmployeeFunctions (
    EmployeeFunctionID INT PRIMARY KEY,
    EmployeeFunctionName NVARCHAR(100) NOT NULL
);
Tabela Translators
Przechowuje informacje o tłumaczach:

TranslatorID (INT): Klucz główny, unikalny identyfikator tłumacza.
FirstName (NVARCHAR(50)): Imię tłumacza, wartość nie może być pusta.
LastName (NVARCHAR(50)): Nazwisko tłumacza, wartość nie może być pusta.
Address (NVARCHAR(255)): Adres tłumacza, wartość nie może być pusta.
CityID (INT): Identyfikator miasta tłumacza, klucz obcy odnoszący się do Cities(CityID).
BirthDate (DATE): Data urodzenia tłumacza, wartość nie może być pusta.
HireDate (DATE): Data zatrudnienia tłumacza, wartość nie może być pusta, musi być późniejsza od daty urodzenia.
Email (NVARCHAR(100)): Adres e-mail tłumacza, wartość nie może być pusta, unikalna, musi być zgodna z poprawnym formatem adresu e-mail.
PhoneNumber (NVARCHAR(20)): Numer telefonu tłumacza, wartość nie może być pusta, unikalna, musi składać się z 9 cyfr i być numeryczna.
sql
Copy code
CREATE TABLE Translators (
    TranslatorID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    CityID INT NOT NULL FOREIGN KEY REFERENCES Cities(CityID),
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL CHECK (HireDate > BirthDate),
    Email NVARCHAR(100) NOT NULL UNIQUE CHECK (Email LIKE '%_@_%._%'),
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE CHECK (LEN(PhoneNumber) = 9 AND ISNUMERIC(PhoneNumber))
);
Tabela Languages
Przechowuje informacje o językach:

LanguageID (INT): Klucz główny, unikalny identyfikator języka.
LanguageName (NVARCHAR(50)): Nazwa języka, wartość nie może być pusta.
sql
Copy code
CREATE TABLE Languages (
    LanguageID INT PRIMARY KEY,
    LanguageName NVARCHAR(50) NOT NULL
);
Tabela TranslatorLanguages
Przechowuje informacje o językach, które tłumacze znają:

TranslatorID (INT): Identyfikator tłumacza, klucz obcy odnoszący się do Translators(TranslatorID).
LanguageID (INT): Identyfikator języka, klucz obcy odnoszący się do Languages(LanguageID).
Klucz główny to kombinacja kolumn TranslatorID i LanguageID, aby zapewnić unikalność każdego przypisania tłumacza do języka.

sql```
Copy code
CREATE TABLE TranslatorLanguages ( 
    TranslatorID INT NOT NULL, 
    LanguageID INT NOT NULL, 
    PRIMARY KEY (TranslatorID, LanguageID), 
    FOREIGN KEY (TranslatorID) REFERENCES Translators(TranslatorID), 
    FOREIGN KEY (LanguageID) REFERENCES Languages(LanguageID) 
); 
```
