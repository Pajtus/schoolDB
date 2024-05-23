USE Szkola
GO

-- XXXX
GO
CREATE TABLE Przedmioty (
	idPrzedmiotu INT PRIMARY KEY IDENTITY(1, 1),
	nazwa NVARCHAR(64) NOT NULL,
	dodatkoweZajecia BIT NOT NULL DEFAULT (0),
)
GO

-- can derive from it
-- cannot delete, prevent it trigger on delete, jezeli w rodzicu jest rekord nie usuwaj
-- canot insert alone
-- XXXX
GO
CREATE TABLE Osoby (
	idOsoby INT PRIMARY KEY IDENTITY(1,1), 
	imie NVARCHAR(32) NOT NULL,
	drugieImie NVARCHAR(32) NULL,
	nazwisko NVARCHAR(32) NOT NULL,
	dataUrodzenia DATE NOT NULL,
	plec NVARCHAR(1) NOT NULL,
	miejscowoscZamiszkania NVARCHAR(32) NOT NULL,
	wzrost TINYINT CHECK(wzrost BETWEEN 50 AND 255),
)
GO

-- zabron usuwanie
-- XXXX
GO
CREATE TABLE Tytuly (
	idTytulu INT PRIMARY KEY IDENTITY(1, 1),
	nazwa NVARCHAR(32)
)
GO

-- dodaj trigger do usuwania, jak usuwa to tez z table Osoby
-- to samo do uczniow
-- XXXX liczba: 43 nauczycieli
GO
CREATE TABLE Nauczyciele (
	idNauczyciela INT PRIMARY KEY IDENTITY(1,1),
	idOsoby INT NOT NULL,
	idPrzedmiotWodzacy INT NOT NULL, 
	ileLatUczy TINYINT NOT NULL,
	zatrudnionyOd DATE NOT NULL,
	wynagrodzenie SMALLMONEY,
	idTytulu INT,
	prawoDoJazdy BIT DEFAULT 0 NOT NULL,

	CONSTRAINT FK_idOsoby_Nauczyciele FOREIGN KEY (idOsoby) REFERENCES Osoby(idOsoby) ON DELETE CASCADE,
	CONSTRAINT FK_idPrzedmiotu_Nauczyciele FOREIGN KEY (idPrzedmiotWodzacy) REFERENCES Przedmioty(idPrzedmiotu),
	CONSTRAINT FK_idTytulu_Nauczyciele FOREIGN KEY (idTytulu) REFERENCES Tytuly(idTytulu)
)
GO

-- XXXX
GO
CREATE TABLE PrzedmiotyNauczycieli (
	idNauczyciela INT FOREIGN KEY REFERENCES Nauczyciele(idNauczyciela),
	idPrzedmiotu INT FOREIGN KEY REFERENCES Przedmioty(idPrzedmiotu),
	wspolczynnikZadowoleniaUcznia FLOAT,

	CONSTRAINT PK_PrzedmiotyNauczycieli PRIMARY KEY (idNauczyciela, idPrzedmiotu)
)
GO

-- XXXX liczba: 400 uczniow
GO
CREATE TABLE Uczniowie (
	idUcznia INT PRIMARY KEY IDENTITY(1, 1),		
	idOsoby INT NOT NULL,
	nrSzafki INT NOT NULL,				-- 101
	klasa NVARCHAR(2) NOT NULL,			-- ex. '1b'
	dojezdzajacy BIT DEFAULT (0), 
	sredniaOcen FLOAT,
	zachowaniePunktacja SMALLINT,

	CONSTRAINT FK_idOsoby_Uczniowie FOREIGN KEY (idOsoby) REFERENCES Osoby(idOsoby) ON DELETE CASCADE
)
GO

-- XXXX
GO 
CREATE TABLE Sale (
	idSali SMALLINT PRIMARY KEY IDENTITY(1, 1),
	nrPietra TINYINT NOT NULL CHECK (nrPietra >= 0 AND nrPietra <= 3),
	nrSali NVARCHAR(4) NOT NULL,
	pojemnoscUczniow SMALLINT CHECK (pojemnoscUczniow >= 0),
)
GO


-- funckaj do przeksztalcania wagi oceny na slowne wagi i vice versa
-- XXXX
GO
CREATE TABLE Oceny (
	idOceny INT IDENTITY (1, 1),
	idPrzedmiotu INT NOT NULL,
	idUcznia INT NOT NULL,
	ocena FLOAT NOT NULL CHECK (ocena IN (1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0)),
	waga TINYINT DEFAULT 1 CHECK (waga IN (1, 2, 3)),

	-- 2X REFERENCES
	CONSTRAINT FK_idPrzedmiotu_Oceny FOREIGN KEY (idPrzedmiotu) REFERENCES Przedmioty(idPrzedmiotu),
	CONSTRAINT FK_idUcznia_Oceny FOREIGN KEY (idUcznia) REFERENCES Uczniowie(idUcznia)
)
GO

-- opcja tez taka ze brak daty oznacza iz jest obecny
-- XXXX
GO
CREATE TABLE Frekwencje (
	data DATE NOT NULL,
	godzinaLekcyjna TINYINT NOT NULL CHECK(godzinaLekcyjna BETWEEN 1 AND 10),
	idUcznia INT NOT NULL,
	obecnosc NVARCHAR(1) NOT NULL CHECK (obecnosc IN (N'O', N'N', N'Z', N'U')),

	-- REFERENCES
	CONSTRAINT PK_Frekwencje PRIMARY KEY (data, godzinaLekcyjna, idUcznia),
	CONSTRAINT FK_idUcznia_Frekwencja FOREIGN KEY (idUCznia) REFERENCES Uczniowie(idUcznia)
)
GO

-- slowne zwracanie jakie ma zachowanie
-- XXXX
GO
CREATE TABLE Uwagi (
	idWystawiajacego INT NOT NULL,
	idOtrzymujacego INT NOT NULL,
	iloscPunktow SMALLINT CHECK (iloscpunktow BETWEEN -100 AND 100),
	dataWystawienia DATE NOT NULL,
	opis NVARCHAR(255),

	-- 2x REFERENCES
	CONSTRAINT FK_idWystawiajacego_Uwagi FOREIGN KEY (idWystawiajacego) REFERENCES Nauczyciele(idNauczyciela),
	CONSTRAINT FK_idOtrzymujacego_Uwagi FOREIGN KEY (idOtrzymujacego) REFERENCES Uczniowie(idUcznia)
)
GO

-- XXXX
GO
CREATE TABLE Ogloszenia (
	idWystawiajacego INT NOT NULL,
	opis NVARCHAR(512),
	obowiazujeOd DATE NOT NULL,
	obowiazujeDo DATE NOT NULL,

	-- REFERENCES
	CONSTRAINT FK_idWystawiajacego_Ogloszenia FOREIGN KEY (idWystawiajacego) REFERENCES Nauczyciele(idNauczyciela)
)
GO

-- xxxx
GO
CREATE TABLE PlanLekcji (
	idKlasy NVARCHAR(2),
	idPrzedmiotu INT NOT NULL,
	idProwadzacy INT NOT NULL,
	idSali SMALLINT NOT NULL,
	idGodzinaLekcyjna TINYINT NOT NULL,
	dzienTygodnia TINYINT NOT NULL CHECK(dzienTygodnia BETWEEN 1 AND 5),

	-- references do ids
	CONSTRAINT FK_idPrzedmiotu_PlanLekcji FOREIGN KEY (idPrzedmiotu) REFERENCES Przedmioty(idPrzedmiotu),
	CONSTRAINT FK_idProwadzacy_PlanLekcji FOREIGN KEY (idProwadzacy) REFERENCES Nauczyciele(idNauczyciela),
	CONSTRAINT FK_idSali_PlanLekcji FOREIGN KEY (idSali) REFERENCES Sale(idSali)
)
GO