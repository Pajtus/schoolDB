SET IDENTITY_INSERT Osoby ON

INSERT INTO Osoby([idOsoby]
      ,[imie]
      ,[drugieImie]
      ,[nazwisko]
      ,[dataUrodzenia]
      ,[plec]
      ,[miejscowoscZamiszkania]
      ,[wzrost])
SELECT [idOsoby]
      ,[imie]
      ,[drugie_Imie]
      ,[nazwisko]
      ,[dataUrodzenia]
      ,[plec]
      ,[miejscowoscZamieszkania]
      ,[wzrost] FROM OsobyUczniowieRazem

------
SET IDENTITY_INSERT Osoby OFF
INSERT INTO Osoby([idOsoby]
      ,[imie]
      ,[drugieImie]
      ,[nazwisko]
      ,[dataUrodzenia]
      ,[plec]
      ,[miejscowoscZamiszkania]
      ,[wzrost])
SELECT ([idOsoby]+400)
      ,[imie]
      ,[drugie_Imie]
      ,[nazwisko]
      ,[dataUrodzenia]
      ,[plec]
      ,[miejscowoscZamieszkania]
      ,[wzrost] FROM OsobyRazemNauczyciele

	  
----------
SET IDENTITY_INSERT Nauczyciele OFF
INSERT INTO Nauczyciele([idNauczyciela]
      ,[idOsoby]
      ,[idPrzedmiotWodzacy]
      ,[ileLatUczy]
      ,[zatrudnionyOd]
      ,[wynagrodzenie]
      ,[idTytulu]
      ,[prawoDoJazdy])
SELECT [idOsoby]
	  ,([idOsoby]+400)
      ,[przedmiot_wodzacy]
      ,[ileLatUczy]
      ,[zatrudnionyOd]
      ,[wynagrodzenie]
      ,[idTytulu]
      ,[prawoDoJazdy] FROM NauczycieleRazem

	  
----------
SET IDENTITY_INSERT Uczniowie ON
INSERT INTO Uczniowie([idUcznia]
      ,[idOsoby]
      ,[nrSzafki]
      ,[klasa]
      ,[dojezdzajacy]
      ,[sredniaOcen]
      ,[zachowaniePunktacja])
SELECT [idOsoby]
	  ,[idOsoby]
      ,[nrSzafki]
      ,[klasa]
      ,[dojezdzajacy]
      ,[sredniaOcen]
      ,[zachowaniePunktacja] FROM UczniowieRazem

----------
--SET IDENTITY_INSERT Uwagi ON
INSERT INTO Uwagi([idWystawiajacego]
      ,[idOtrzymujacego]
      ,[iloscPunktow]
      ,[dataWystawienia]
      ,[opis])
SELECT [idWystawiajacego]
      ,[idOtrzymujacego]
      ,[iloscPunktow]
      ,[dataWystawienia]
      ,[opis] FROM Uwagi2

-------------
INSERT INTO Ogloszenia([idWystawiajacego]
      ,[opis]
      ,[obowiazujeOd]
      ,[obowiazujeDo])
SELECT [idWystawiajacego]
      ,[opis]
      ,[obowiazujeOd]
      ,[obowiazujeDo] FROM Ogloszenia2
----------------------
INSERT INTO Frekwencje([data]
      ,[godzinaLekcyjna]
      ,[idUcznia]
      ,[obecnosc])
SELECT [data]
      ,[godzinaLekcyjna]
      ,[IdUcznia]
      ,[obecnosc] FROM Frekwencja


------------------
INSERT INTO PlanLekcji([idKlasy]
      ,[idPrzedmiotu]
      ,[idProwadzacy]
      ,[idSali]
      ,[idGodzinaLekcyjna]
      ,[dzienTygodnia])
SELECT [idKlasy]
      ,[idPrzedmiotu]
      ,[idProwadzacego]
      ,[idSali]
      ,[idGodzinaLekcyjna]
      ,[dzienTygodnia]
	  FROM Plan_Lekcji

	  ------------------
 SET IDENTITY_INSERT Oceny ON
INSERT INTO Oceny([idOceny]
      ,[idPrzedmiotu]
      ,[idUcznia]
      ,[ocena]
      ,[waga])
SELECT [idOceny]
,[idPrzedmiotu]
      ,[idUcznia]
      ,[ocena]
      ,[waga]
	  FROM Oceny2


	  -----------
	  INSERT INTO PrzedmiotyNauczycieli([idNauczyciela]
      ,[idPrzedmiotu]
      ,[wspolczynnikZadowoleniaUcznia])
SELECT [idNauczyciela]
      ,[idPrzedmiotu]
      ,[wspolczynnikZadowolenia]
	  FROM PrzedmiotyNauczycieli2