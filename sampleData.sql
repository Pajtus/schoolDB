-- [Biologia , Chemia , Fizyka , Geografia , Historia , Informatyka , Jêzyk angielski , Jêzyk niemiecki , Jêzyk polski , Matematyka , Muzyka , Plastyka , Przyroda , Religia , Technika , Wychowanie fizyczne , Wychowanie do ¿ycia w rodzinie]
-- Przedmioty szkolne

USE Szkola
GO

-- PRZEDMIOTY
INSERT INTO Przedmioty(nazwa, dodatkoweZajecia)
VALUES 
	('Biologia', 0),
	('Chemia', 0),
	('Angielski', 1),
	('Biologia', 0),
	('Chemia', 0),
	('Fizyka', 0),
	('Geografia', 0),
	('Historia', 0),
	('Informatyka', 0),
	('Jêzyk angielski', 0),
	('Jêzyk niemiecki', 0),
	('Jêzyk polski', 0),
	('Matematyka', 0),
	('Muzyka', 0),
	('Plastyka', 0),
	('Przyroda', 0),
	('Religia', 0),
	('Technika', 0),
	('Wychowanie fizyczne', 0),
	('Wychowanie do ¿ycia w rodzinie', 0),
	('Matematyka akademicka', 1),
	('Lutowanie', 1),
	('Spawanie', 1),
	('Kolko teatralne', 1),
	('Lekcje Œpiewu', 1),
	('Lekcje Tañca', 1);


-- TYTULY
INSERT INTO Tytuly(nazwa)
VALUES 
	('magister'),
	('doktor'),
	('magister'),
	('in¿ynier'),
	('doktor'),
	('doktor habilitowany'),
	('profesor'),
	('in¿ynier magister'),
	('doktor habilitowany profesor');


-- NAUCZYCIELE KOBIETY
INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
VALUES
	('JAGODA','EWELINA','STANKIEWICZ','1976.01.13',0,'Dêba',167),
	('TETIANA','MAJA','STACHOWIAK','1992-10-9',0,'Radoszyce',154),
	('SYLWIA','ROKSANA','AUGUSTYNIAK','1975-04-17',0,'W¹glany',153),
	('ANGELIKA','ZOFIA','MAZURKIEWICZ','1979-03-15',0,'¯arnów',152);

INSERT INTO Nauczyciele(idOsoby, idPrzedmiotWodzacy, ileLatUczy, zatrudnionyOd, wynagrodzenie, idTytulu, prawoDoJazdy)
VALUES
	(1,1,6,'2015-01-01',4170,1,0),
	(2,2,3,'2007-07-31',4132,2,0),
	(3,3,2,'2013-08-31',3959,1,0),
	(4,1,15,'2006-03-28',3815,2,1);


-- NAUCZYCIELE MEZCZYZNI
INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
VALUES
	('DMYTRO', 'WALDEMAR', 'KUCHARSKI', '1970-09-23', 1, 'Koliszowy', 160),
	('W£ODZIMIERZ', 'KUBA', 'GAJDA', '1982-04-09', 1, 'Dêba Kolonia', 165),
	('ADAM', 'BOLES£AW', 'WOLSKI', '1993-03-25', 1, 'Grabków', 193);

INSERT INTO Nauczyciele(idOsoby, idPrzedmiotWodzacy, ileLatUczy, zatrudnionyOd, wynagrodzenie, idTytulu, prawoDoJazdy)
VALUES
	(5, 1, 14, '2002-11-04', 4020, 1, 0),
	(6, 2, 11, '2006-10-08', 3231, 2, 0),
	(7, 3, 11, '2000-07-17', 4381, 1, 0);


-- UCZNIOWIE MEZCZYZNI
INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
VALUES
	('BOGDAN', 'RADOS£AW', 'JANIK', '2012-03-17', 1, 'Grabków', 160),
	('YURII', 'MARCEL', 'KOT', '2016-01-21', 1, 'Kopaniny', 159),
	('SEBASTIAN', 'ERYK', 'KOWALCZYK', '2014-07-06', 1, 'Sielpia', 151),
	('WOJCIECH', 'W£ODZIMIERZ', 'MICHALAK', '2010-10-01', 1, 'G³upiów', 155),
	('GRACJAN', 'YEVHEN', 'NOWAK', '2016-08-08', 1, 'Dêba Kolonia', 165),
	('DAMIAN', 'BORYS', 'ZIÊBA', '2014-05-23', 1, 'Trzemoszna', 144),
	('LEON', 'ANDRZEJ', 'SZYMCZAK', '2015-09-08', 1, 'Grabków', 181),
	('DMYTRO', 'ALFRED', 'CZARNECKI', '2010-09-20', 1, 'Grabków', 156),
	('ERNEST', 'ANDRII', 'TOMCZAK', '2010-12-27', 1, 'Radoszyce', 168),
	('ZBIGNIEW', 'ANATOLII', 'PRZYBYLSKI', '2012-10-06', 1, 'W¹glany', 181);

INSERT INTO Uczniowie(idOsoby, nrSzafki, klasa, dojezdzajacy, sredniaOcen, zachowaniePunktacja)
VALUES
	(1, 0, 0, 0, 5.51, 54),
	(2, 1, 1, 0, 3.63, 54),
	(3, 0, 0, 1, 4.46, 146),
	(4, 0, 0, 0, 4.95, 74),
	(5, 0, 0, 0, 3.21, 22),
	(6, 0, 1, 1, 4.39, 109),
	(7, 1, 1, 0, 3.01, 203),
	(8, 0, 1, 1, 5.49, 83),
	(9, 0, 1, 0, 4.27, 245),
	(10, 1, 0, 1, 2.05, 116);

-- UCZNIOWIE KOBIETY
INSERT INTO Osoby(imie, drugieImie, nazwisko, dataUrodzenia, plec, miejscowoscZamiszkania, wzrost)
VALUES
	('NINA', 'CZES£AWA', 'PAWLAK', '2015-06-12', 0, 'Modliszewice', 168),
	('WANDA', 'MAGDALENA', 'G£OWACKA', '2009-11-07', 0, '¯arnów', 150),
	('TERESA', 'BO¯ENA', 'WIŒNIEWSKA', '2015-02-04', 0, 'W¹glany', 141),
	('JAGODA', 'CECYLIA', 'BUKOWSKA', '2017-10-19', 0, 'G³upiów', 161),
	('ZDZIS£AWA', 'KARINA', 'STANISZEWSKA', '2009-10-12', 0, 'Dêba Kolonia', 138),
	('LIUDMYLA', 'VALENTYNA', 'BOROWSKA', '2013-07-02', 0, 'Radoszyce', 148),
	('DANUTA', 'MARIANNA', 'BRZEZIÑSKA', '2009-04-23', 0, 'Przybyszowy', 155),
	('ANASTASIIA', 'IRYNA', 'KOZ£OWSKA', '2014-06-03', 0, 'Dêba Kolonia', 163);

INSERT INTO Uczniowie(idOsoby, nrSzafki, klasa, dojezdzajacy, sredniaOcen, zachowaniePunktacja)
VALUES
	(1, 1, 0, 0, 2.48, 89),
	(2, 1, 0, 0, 3.8, 61),
	(3, 1, 1, 1, 5.99, 11),
	(4, 1, 1, 0, 2.34, 33),
	(5, 0, 0, 1, 4.94, 148),
	(6, 1, 0, 1, 3.3, 29),
	(7, 1, 0, 1, 4.22, 112),
	(8, 0, 1, 0, 2.75, 78);


-- przedmioty nauczycieli (dla 100 nauczycieli)
--(37, 1, 5.84),(45, 1, 2.45),(17, 2, 8.95),(20, 2, 4.54),(31, 2, 3.4),(48, 2, 8.86),(3, 3, 4.77),(4, 3, 7.88),(1, 4, 3.46),(15, 4, 2.94),(16, 4, 6.35),(52, 4, 2.98),(41, 5, 3.73),(44, 5, 3.48),(34, 6, 5.6),(71, 6, 1.77),(93, 7, 6.11),(66, 8, 3.5),(23, 9, 5.58),(44, 10, 3.48),(5, 10, 5.74),(9, 10, 9.72),(67, 11, 9.93),(76, 11, 8.19),(11, 12, 5.78),(48, 12, 8.86),(88, 13, 9.61),(31, 14, 3.4),(41, 14, 3.73),(62, 14, 8.96),(19, 15, 8.06),(59, 15, 7.65),(51, 16, 7.02),(61, 16, 8.69),(78, 16, 5.4),(58, 17, 7.36),


-- sale
INSERT INTO Sale(nrPietra, nrSali, pojemnoscUczniow)
VALUES 
	(0, '0001', 25), (0, '0002', 28), (0, '0003', 24), (0, '0004', 25), (0, '0005', 25), (0, '0006', 30), (0, '0011', 20), (0, '0012', 30), (0, '0013', 28),
	(1, '0001', 25), (1, '0002', 30), (1, '0003', 30), (1, '0004', 28), (1, '0005', 25), (1, '0011', 30), (1, '0012', 25), (1, '0013', 25), (1, '0014', 22), (1, '0015', 24),
	(2, '0001', 25), (2, '0002', 25), (2, '0003', 30), (2, '0004', 28), (2, '0005', 22), (2, '0006', 20), (2, '0007', 25), (2, '0008', 20), (2, '0011', 22), (2, '0012', 22), (2, '0013', 20);


-- oceny