USE Szkola
GO

-- Wyzwalacz na usuniecie Osoby, podczas usuniecia Nauczyciela
GO
CREATE TRIGGER TR_Delete_Nauczyciele ON Nauczyciele
AFTER DELETE
AS
	DELETE FROM Osoby
	WHERE idOsoby IN (SELECT idOsoby FROM deleted);
GO

-- Wyzwalacz na usuniecie Osoby, podczas usuniecia Ucznia
GO
CREATE TRIGGER TR_Delete_Uczniowie ON Uczniowie
AFTER DELETE
AS
	DELETE FROM Osoby
	WHERE idOsoby IN (SELECT idOsoby FROM deleted);
GO

-- Procedura na dodanie nowego Nauczyciela
GO
alter PROCEDURE utworz_i_dodaj_nauczyciela
	@imie NVARCHAR(32),
	@drugieImie NVARCHAR(32),
	@nazwisko NVARCHAR(32),
	@dataUrodzenia DATE,
	@plec NVARCHAR(1),
	@miejscowoscZamiszkania NVARCHAR(32),
	@wzrost TINYINT,
	@idPrzedmiotWodzacy INT,
	@ileLatUczy TINYINT,
	@zatrudnionyOd DATE,
	@wynagrodzenie SMALLMONEY,
	@idTytulu INT,
	@prawoDoJazdy BIT
AS
	DECLARE @osoby_identity INT = 0;

	INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
		VALUES (@imie, @drugieImie, @nazwisko, @dataUrodzenia, @plec, @miejscowoscZamiszkania, @wzrost);
	SET @osoby_identity = SCOPE_IDENTITY();

	SET IDENTITY_INSERT Nauczyciele OFF
	INSERT INTO Nauczyciele(idOsoby, idPrzedmiotWodzacy, ileLatUczy, zatrudnionyOd, wynagrodzenie, idTytulu, prawoDoJazdy)
		VALUES (@osoby_identity, @idPrzedmiotWodzacy, @ileLatUczy, @zatrudnionyOd, @wynagrodzenie, @idTytulu, @prawoDoJazdy);
GO

-- Procedura na dodanie nowego Ucznia
GO
ALTER PROCEDURE utworz_i_dodaj_ucznia
	@imie NVARCHAR(32),
	@drugieImie NVARCHAR(32),
	@nazwisko NVARCHAR(32),
	@dataUrodzenia DATE,
	@plec NVARCHAR(1),
	@miejscowoscZamiszkania NVARCHAR(32),
	@wzrost TINYINT,
	@nrSzafki INT,
	@klasa NVARCHAR(2),
	@dojezdzajacy BIT, 
	@sredniaOcen FLOAT,
	@zachowaniePunktacja SMALLINT
AS
	DECLARE @osoby_identity INT = 0;

	INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
		VALUES (@imie, @drugieImie, @nazwisko, @dataUrodzenia, @plec, @miejscowoscZamiszkania, @wzrost);
	SET @osoby_identity = SCOPE_IDENTITY();

	SET IDENTITY_INSERT Nauczyciele OFF
	INSERT INTO Uczniowie(idOsoby, nrSzafki, klasa, dojezdzajacy, sredniaOcen, zachowaniePunktacja)
		VALUES (@osoby_identity, @nrSzafki, @klasa, @dojezdzajacy, @sredniaOcen, @zachowaniePunktacja);
GO

-- zamienia ocenê w postaci zmiennoprzecinkowej na postac slowna
CREATE FUNCTION slowna_ocena(@ocena FLOAT) RETURNS NVARCHAR(16)
AS
BEGIN
	DECLARE @slowna_ocena NVARCHAR(16);

	SET @slowna_ocena = CASE @ocena
		WHEN 1.0 THEN 'jedynka'
		WHEN 1.5 THEN 'jedynka z plusem'
		WHEN 2.0 THEN 'dwójka'
		WHEN 2.5 THEN 'dwójka z plusem'
		WHEN 3.0 THEN 'trójka'
		WHEN 3.5 THEN 'trójka z plusem'
		WHEN 4.0 THEN 'czwórka'
		WHEN 4.5 THEN 'czwórka z plusem'
		WHEN 5.0 THEN 'pi¹tka'
		WHEN 5.5 THEN 'pi¹tka z plusem'
		WHEN 6.0 THEN 'szóstka'
	END

	RETURN @slowna_ocena;
END

GO
ALTER FUNCTION slowne_zachowanie(@punkty INT) RETURNS NVARCHAR(16)
AS
BEGIN
	DECLARE @slowne_zachowanie NVARCHAR(16);
	DECLARE @prog_wzorowy INT = 220;
	DECLARE @prog_bardz_dobry INT = 160;
	DECLARE @prog_dobry INT = 90;
	DECLARE @prog_poprawny INT = 20;
	DECLARE @prog_niedopowiedni INT = 0;
	DECLARE @prog_naganny INT = -10;

	IF @punkty > @prog_naganny
		IF @punkty > @prog_niedopowiedni
			IF @punkty > @prog_poprawny
				IF @punkty > @prog_dobry
					IF @punkty > @prog_bardz_dobry
						IF @punkty > @prog_wzorowy
							SET @slowne_zachowanie = 'Wzorowy';
						ELSE
							SET @slowne_zachowanie = 'Bardzo Dobry';
					ELSE
						SET @slowne_zachowanie = 'Dobry';
				ELSE
					SET @slowne_zachowanie = 'Poprawny';
			ELSE
				SET @slowne_zachowanie = 'Nieodpowiedni';
		ELSE
			SET @slowne_zachowanie = 'Naganny';
	ELSE
		SET @slowne_zachowanie = 'Naganny';

	RETURN @slowne_zachowanie;
END
GO

-- ranking uczniow po klasie, calosciowo po sredniej
/*
	Podanie liczby z zakresu [1-6] w³¹cznie, wypisze ranking uczniow po sredniej dla podanej wartosci argumentu @klasa
	w przeciwnym wypadku wypisze wszystkich uczniow ze szkoly
*/
GO
	CREATE PROCEDURE ranking_uczniow_po_sredniej
		@klasa INT
	AS
		IF @klasa < 1 OR @klasa > 6
			SELECT *
			FROM Uczniowie AS U
			ORDER BY U.sredniaOcen DESC
		ELSE 
			SELECT *
			FROM Uczniowie AS U
			WHERE U.klasa = @klasa
			ORDER BY U.sredniaOcen DESC
GO

--example
	--EXEC ranking_uczniow_po_sredniej @klasa = 7
	--EXEC ranking_uczniow_po_sredniej @klasa = 2


-- update srednich uczniow na podstawie ich ocen
-- traktowana w formie pomocniczej
GO
CREATE PROCEDURE update_student
AS
	DECLARE @i INT = 1
	WHILE @i <= 400
	BEGIN
		UPDATE Uczniowie
		SET sredniaOcen = 
			(SELECT ROUND(SUM(O.ocena * O.waga)/SUM(O.waga), 2) FROM Oceny as O WHERE O.idUcznia = @i)
		WHERE idUcznia = @i
		SET @i = @i + 1;
	END

GO


--najlepszy nauczyciel pod wzgledem ratingu
/*
	funckja zwraca najlepszego nauczyciela pod wzglêdem {wspolczynnikZadowoleniaUcznia}
*/
GO
	CREATE VIEW najlepszy_nauczyciel 
	AS
		SELECT top 1 Best.idNauczyciela, O.imie, O.drugieImie, O.nazwisko, Best.sredniWspolczynnikZadowoleniaUcznia
		FROM (
				SELECT idNauczyciela, AVG(wspolczynnikZadowoleniaUcznia) as sredniWspolczynnikZadowoleniaUcznia
				FROM PrzedmiotyNauczycieli
				GROUP BY idNauczyciela
			) as Best
			INNER JOIN Nauczyciele as N
				ON Best.idNauczyciela = N.idNauczyciela
				INNER JOIN Osoby as O
					ON O.idOsoby = N.idOsoby
		ORDER BY Best.sredniWspolczynnikZadowoleniaUcznia DESC
GO
-- example
	--SELECT * FROM najlepszy_nauczyciel


GO
ALTER PROCEDURE update_teacher_rating
AS
	DECLARE @i INT = 1
	WHILE @i <= 56
	BEGIN
		UPDATE [PrzedmiotyNauczycieli]
		SET [wspolczynnikZadowoleniaUcznia] = [wspolczynnikZadowoleniaUcznia] + ROUND(RAND(), 2)
		WHERE [idNauczyciela] = @i AND [idPrzedmiotu] = 14
		SET @i = @i + 1;
	END
GO
-- example
	--EXEC update_teacher_rating


-- najlepszy przedmiot pod wzgledem ratingu
/*
	funckja zwraca najlepszy przedmiot pod wzglêdem {wspolczynnikZadowoleniaUcznia}
*/
GO
	CREATE VIEW najlepszy_przedmiot 
	AS
		SELECT top 1 Best.idPrzedmiotu, P.nazwa, IIF(P.dodatkoweZajecia = 1, 'Tak', 'Nie') as CzyPozalekcyjny, Best.sredniWspolczynnikZadowoleniaUcznia
		FROM (
				SELECT idPrzedmiotu, AVG(wspolczynnikZadowoleniaUcznia) as sredniWspolczynnikZadowoleniaUcznia
				FROM PrzedmiotyNauczycieli
				GROUP BY idPrzedmiotu
			) as Best
			INNER JOIN Przedmioty as P
				ON Best.idPrzedmiotu = P.idPrzedmiotu
		ORDER BY Best.sredniWspolczynnikZadowoleniaUcznia DESC
GO

--example
	--SELECT * FROM najlepszy_przedmiot

-- najdluzej pracujacy nauczyciele w danej szkole pod wzgledem stazu ogolnie, prowadzacy dany przedmiot lub tez wiodacy
GO
	CREATE PROCEDURE najstarszy_nauczyciel_per_przedmiot
		@nazwaPrzedmiotu NVARCHAR(50)
	AS
		SELECT work_years.idNauczyciela, work_years.lataPracyOgolne, P.nazwa
		FROM (
				SELECT idNauczyciela, idPrzedmiotWodzacy, (ileLatUczy + DATEDIFF(year, zatrudnionyOd, GETDATE()) ) as lataPracyOgolne
				FROM Nauczyciele
			) as work_years
			INNER JOIN PrzedmiotyNauczycieli as NP
				ON work_years.idNauczyciela = NP.idNauczyciela
				INNER JOIN Przedmioty as P
					ON P.idPrzedmiotu = NP.idPrzedmiotu
		WHERE P.nazwa = @nazwaPrzedmiotu
		ORDER BY work_years.lataPracyOgolne DESC
GO

-- example
	--EXEC najstarszy_nauczyciel_per_przedmiot 'Chemia'
	--EXEC najstarszy_nauczyciel_per_przedmiot 'Plastyka'	-- chociaz ucza Biolagi, wodzacy Plastyka

--srednia ocen calej klasy
GO
	CREATE VIEW [Srednie klas] AS
	SELECT ROUND(AVG(ISNULL(sredniaOcen, 0)), 2) as sredniaOcenKlasy, klasa FROM Uczniowie
	GROUP BY klasa
GO
-- example
	--SELECT * FROM [Srednie klas]


-- aktualnie odbywajacych sie zajec dodatkowych w danym dniu o danej godzinie lekcyjnej
GO
	ALTER PROCEDURE aktualnie_odbywajace_zajecia
		@godzinaLekcyjna INT,
		@dzienTygodnia INT
	AS
		SELECT P.nazwa, IIF(P.dodatkoweZajecia = 1, 'Tak', 'Nie') as dodatkowe, PL.idSali
		FROM PlanLekcji as PL INNER JOIN Przedmioty as P
			ON PL.idPrzedmiotu = P.idPrzedmiotu
		WHERE PL.idGodzinaLekcyjna = @godzinaLekcyjna AND PL.dzienTygodnia = @dzienTygodnia
GO
-- example
	EXEC aktualnie_odbywajace_zajecia @godzinaLekcyjna=1, @dzienTygodnia=1	-- brak dodatkowych zajec
	EXEC aktualnie_odbywajace_zajecia @godzinaLekcyjna=2, @dzienTygodnia=1	-- brak zajec
	EXEC aktualnie_odbywajace_zajecia @godzinaLekcyjna=5, @dzienTygodnia=1  -- 2 rekordy


-- lista dojezdzajacych uczniow per miejscowosc
GO
	CREATE VIEW lista_dojezdzajacych
	AS
		SELECT O.idOsoby, O.imie, O.nazwisko, O.miejscowoscZamiszkania
		FROM (
			SELECT * 
			FROM Uczniowie
			WHERE dojezdzajacy = 1
		) as dojezdzajacy INNER JOIN Osoby as O
			ON dojezdzajacy.idOsoby = O.idOsoby
GO
-- example 
	--SELECT * FROM lista_dojezdzajacych

	--SELECT DISTINCT miejscowoscZamiszkania
	--FROM lista_dojezdzajacych

	--SELECT COUNT(*) as liczba, miejscowoscZamiszkania
	--FROM lista_dojezdzajacych
	--GROUP BY miejscowoscZamiszkania

	-- mozna laczyc z distinct- aby zdobyc unikatowe nazwy miejscowosci osob dojezdzajacyh, count- ile dojezdza


-- listuj uczestnikow przedmiotow danego dnia, o pewnej godzinie, stan zapelnienia klas
GO
	CREATE FUNCTION nie_uczestnicy_zajec(@godzinaLekcyjna INT, @dzienTygodnia INT, @data DATE) RETURNS INT
	AS
	BEGIN
		--DECLARE @data DATE = '2022-09-01';
		--DECLARE @godzinaLekcyjna INT = 3;
		DECLARE @id_ucznia INT;
		DECLARE @klasa INT;
		DECLARE @nieobecni_calosc INT = 0;

		DECLARE cursor_klasy CURSOR FOR (SELECT DISTINCT klasa, idUcznia FROM Uczniowie WHERE idUcznia IN(SELECT idUcznia FROM Frekwencje WHERE data = @data))
		OPEN cursor_klasy

		FETCH NEXT FROM cursor_klasy INTO @klasa, @id_ucznia
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @total_students FLOAT = (SELECT COUNT(*) FROM Uczniowie WHERE klasa = @klasa);
			DECLARE @total_nieobecni INT = (SELECT COUNT(DISTINCT idUcznia) FROM Frekwencje WHERE idUcznia = @id_ucznia);
			SET @nieobecni_calosc = @nieobecni_calosc + @total_nieobecni;

			--SELECT @total_nieobecni as nieobecni, @total_students as licznosc_klasy, @klasa as klasa, round((@total_nieobecni/@total_students), 2) as procent_klasy, @godzinaLekcyjna as godzinaLekcyjna

			FETCH NEXT FROM cursor_klasy INTO @klasa, @id_ucznia
		END

		CLOSE cursor_klasy
		DEALLOCATE cursor_klasy

		RETURN @nieobecni_calosc;
	END
GO
-- example
	SELECT dbo.nie_uczestnicy_zajec(3, DATEPART(WEEKDAY, '2022-09-01'), '2022-09-01') as [nieobecni tego dnia]



-- ktore klasy maja dodatkowe zajecia i na jakie
GO
	CREATE FUNCTION zajecia_pozalekcyjne() RETURNS TABLE
	AS
	RETURN 
	SELECT PL.dzienTygodnia, PL.idGodzinaLekcyjna, PL.idKlasy, P.idPrzedmiotu, P.nazwa
	FROM PlanLekcji as PL INNER JOIN Przedmioty as P
		ON PL.idPrzedmiotu = P.idPrzedmiotu
	WHERE P.dodatkoweZajecia = 1
GO
-- example
	--SELECT * FROM zajecia_pozalekcyjne()


-- funkcja do dodawania oceny uczniowi i przez to zmiana sredniej
GO
ALTER FUNCTION dodaj_uczen_ocena(@uczenId INT, @ocena FLOAT, @waga INT) RETURNS FLOAT
AS
BEGIN
	DECLARE @liczba_wag INT = (SELECT SUM(waga) FROM Oceny WHERE idUcznia=@uczenId);
	DECLARE @srednia_przed_podzieleniem INT = ((SELECT sredniaOcen FROM Uczniowie WHERE idUcznia=@uczenId) * @liczba_wag);

	DECLARE @new_srednia FLOAT = ((@srednia_przed_podzieleniem + (@ocena * @waga)) / (@liczba_wag + @waga));

	RETURN ROUND(@new_srednia, 2);
END
GO
--SELECT dbo.dodaj_uczen_ocen(2, 6, 3)
-- uczen 2 ma srednia 4.86, po dodaniu 6 wagi 3, jego srednia to 5.2


-- funkcja odejmujaca ocene i zwracajaca nowa wartosc sredniej ucznia
GO
ALTER FUNCTION odejmij_uczen_ocena(@id_ucznia INT, @ocena FLOAT, @waga INT)  RETURNS FLOAT
AS
BEGIN
	DECLARE @stara_srednia FLOAT = (SELECT sredniaOcen FROM Uczniowie WHERE idUcznia=@id_ucznia);
	DECLARE @liczba_wag INT = (SELECT SUM(waga) FROM Oceny WHERE idUcznia=@id_ucznia);

	DECLARE @nowa_srednia FLOAT = (((@stara_srednia * @liczba_wag) - (@ocena * @waga)) / (@liczba_wag - @waga))

	RETURN ROUND(@nowa_srednia, 2);
END
GO


	SELECT dbo.odejmij_uczen_ocena(2, 4, 3)		-- srednia 5.51
	SELECT dbo.odejmij_uczen_ocena(2, 6, 3)
	-- uczen 2 ma srednia 4.86, po dojeciu 6 wagi 3, jego srednia to 4.01


GO
	ALTER TRIGGER TR_InsteadOfInsert_Oceny ON Oceny
	INSTEAD OF INSERT
	AS
		DECLARE @id_ucznia INT;
		DECLARE @id_przedmiotu INT;
		DECLARE @ocena INT;
		DECLARE @waga INT;
		DECLARE inserted_cursor CURSOR FOR (SELECT idUcznia, idPrzedmiotu, ocena, waga FROM inserted)
		OPEN inserted_cursor

		FETCH NEXT FROM inserted_cursor INTO @id_ucznia,@id_przedmiotu, @ocena, @waga
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @nowa_srednia FLOAT = (SELECT dbo.dodaj_uczen_ocena(@id_ucznia, @ocena, @waga));

			--SELECT @nowa_srednia, @id_ucznia, @ocena, @waga

			-- to jak chcemy zapisywac na stale wartosci
			UPDATE Uczniowie
			SET sredniaOcen = @nowa_srednia
			WHERE idUcznia = @id_ucznia

			INSERT INTO Oceny([idPrzedmiotu]
			      ,[idUcznia]
			      ,[ocena]
			      ,[waga])
			VALUES
				(@id_przedmiotu, @id_ucznia, @ocena, @waga)

			FETCH NEXT FROM inserted_cursor INTO @id_ucznia, @id_przedmiotu, @ocena, @waga
		END

		CLOSE inserted_cursor
		DEALLOCATE inserted_cursor
GO

GO
	ALTER TRIGGER TR_InsteadOfDelete_Oceny ON Oceny
	INSTEAD OF DELETE
	AS
		DECLARE @id_ucznia INT;
		DECLARE @id_oceny INT;
		DECLARE @ocena INT;
		DECLARE @waga INT;
		DECLARE deleted_cursor CURSOR FOR (SELECT idOceny, idUcznia, ocena, waga FROM deleted)
		OPEN deleted_cursor

		FETCH NEXT FROM deleted_cursor INTO @id_oceny, @id_ucznia, @ocena, @waga
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @nowa_srednia FLOAT = (SELECT dbo.odejmij_uczen_ocena(@id_ucznia, @ocena, @waga));

			--SELECT @nowa_srednia, @id_ucznia, @ocena, @waga

			--SELECT * FROM deleted

			UPDATE Uczniowie
			SET sredniaOcen = @nowa_srednia
			WHERE idUcznia = @id_ucznia

			DELETE FROM Oceny
			WHERE idOceny = @id_oceny

			FETCH NEXT FROM deleted_cursor INTO @id_oceny, @id_ucznia, @ocena, @waga
		END

		CLOSE deleted_cursor
		DEALLOCATE deleted_cursor
GO

-- example
SELECT *
FROM Oceny
WHERE idUcznia = 2

	INSERT INTO Oceny(
		  [idPrzedmiotu]
		  ,[idUcznia]
		  ,[ocena]
		  ,[waga])
	VALUES
		(1, 2, 4, 3)

SELECT *
FROM Oceny
WHERE idUcznia = 2

SELECT *
FROM Uczniowie
WHERE idUcznia = 2

UPDATE Uczniowie
SET sredniaOcen = 4.85
WHERE idUcznia = 2

	DELETE FROM Oceny
	WHERE idOceny = 1007
	-- trzeba zmienic id recznie, bo identity sie zmienia

SELECT *
FROM Oceny
WHERE idUcznia = 2

SELECT *
FROM Uczniowie
WHERE idUcznia = 2



-- Przykladowe Zapytania
	--@imie NVARCHAR(32),
	--@drugieImie NVARCHAR(32),
	--@nazwisko NVARCHAR(32),
	--@dataUrodzenia DATE,
	--@plec NVARCHAR(1),
	--@miejscowoscZamiszkania NVARCHAR(32),
	--@wzrost TINYINT,
	--@idPrzedmiotWodzacy INT,
	--@ileLatUczy TINYINT,
	--@zatrudnionyOd DATE,
	--@wynagrodzenie SMALLMONEY,
	--@idTytulu INT,
	--@prawoDoJazdy BIT
--dbo.utworz_i_dodaj_nauczyciela 'Barbara', 'Barburka', 'Testowa', '2024-12-12', 0, 'Bedlno', 160, 13, 14, '2024-12-13', 4321, 1, 1

	--@imie NVARCHAR(32),
	--@drugieImie NVARCHAR(32),
	--@nazwisko NVARCHAR(32),
	--@dataUrodzenia DATE,
	--@plec NVARCHAR(1),
	--@miejscowoscZamiszkania NVARCHAR(32),
	--@wzrost TINYINT,
	--@nrSzafki INT,
	--@klasa NVARCHAR(2),
	--@dojezdzajacy BIT, 
	--@sredniaOcen FLOAT,
	--@zachowaniePunktacja SMALLINT
--dbo.utworz_i_dodaj_ucznia 'Piter', 'Piotrulo', 'Piotr', '2024-12-12', 1, 'Krakow', 160, 13, 1, 1, 3.21, 1

-- zachowanie
	--SELECT dbo.slowne_zachowanie(230);
	--SELECT dbo.slowne_zachowanie(170);
	--SELECT dbo.slowne_zachowanie(100);
	--SELECT dbo.slowne_zachowanie(30);
	--SELECT dbo.slowne_zachowanie(10);
	--SELECT dbo.slowne_zachowanie(-20);