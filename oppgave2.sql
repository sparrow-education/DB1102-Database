/*
	a) Lag en spørring som gir informasjon om hvilken av de registrerte kommunene som har 
    størst innbyggertall, 
    og hva denne kommunen heter.
*/
select * from kommune;

SELECT 
    MAX(Innbyggertall) AS Innbyggertall, Navn
FROM
    kommune;

-- Får en oversikt over tabellen kommune først 
-- så bruker jeg en MAX funksjon på innbyggertall for å få høyest numerisk verdi
COMMIT;


/*
	b) Lag en spørring som gir informasjon om hvilke registrerte spillere 
    som bor i en kommune 
    som heter Herøy.
*/

SELECT 
    s.Navn, k.Navn
FROM
    Spiller s
        JOIN
    Kommune k ON s.KommuneID = k.KommuneID
WHERE
    k.Navn = 'Herøy';
    
-- Bruker en join (med navn) for å gjøre en spørring mot 2 tabeller.
-- kobler disse to tabellene på felles felt som er kommuneID
COMMIT;


/* 
	c) Lag en spørring som gir navn 
	på alle registrerte kommuner 
	som har samme navn, 
	men ligger i forskjellige fylker.
*/
SELECT 
    f.navn AS Fylke, k.navn AS Kommune
FROM
    fylke f
JOIN
    kommune k ON f.FylkeID = k.Fylke;

-- Bruker en JOIN på fylke og kommune tabellen hvor de har fylkeID til felles
COMMIT;


/* 
	d) Lag en spørring som viser 
	hvor mange registrerte kommuner 
	som har en liten 'u' i navnet sitt. 
	Navngi kolonnen i svaret: Antall U-Kommuner.
*/
SELECT 
	Navn AS 'Antall U-Kommuner'
FROM 
	kommune
WHERE 
	Navn LIKE '%u%';

-- Brukte wildcard % forran og bak for å finne navnene som inneholdt "u" 
COMMIT;


/*
	e) Lag en spørring som viser 
    hvilket fylke som samlet sett har hatt flest premievinnere til nå. 
    Resultatet skal vise fylket, og antall vinnere. 
    Hvis noen har vunnet flere ganger, 
    så skal de telles for hver gang de vinner.
*/
select * from kommune; -- kommuneid + fylke
select * from vinner; --  spillenr gangervunnet subquery
select * from fylke; -- fylkeid, navn
select * from spiller; -- spillernr + kommuneid
SELECT count(k.fylke) antall, f.navn Fylke
FROM kommune k
JOIN fylke f
ON k.fylke = f.fylkeid
GROUP BY fylke;


/*select f.Navn spillerNr, count(trekningsid) AS gangerVunnet
from vinner
group by spillerNr;

SELECT fylke.navn AS Fylke, COUNT(fylke.navn) AS kommuner, vinner.trekningsid 
FROM kommune
JOIN fylke ON kommune.fylke = fylke.fylkeid
JOIN vinner ON 

group by fylke;*/

/*
	f) Lag en spørring som viser hvilke trekninger 
    som ikke har hatt noen vinnere. 
    Resultatet skal vise trekningens dato, 
    og navnet på hvem som var trekningsansvarlig.
*/

SELECT DISTINCT a.navn AS Trekkansvarlig, t.dato AS DatoTrekk, t.utbetaling AS Premie, t.trekningsid AS TrekningsID
FROM  ansatt a
JOIN trekning t 
ON a.ansattid = t.ansattid
LEFT JOIN vinner v 
ON t.trekningsid = v.trekningsid
WHERE t.utbetaling = 0;

-- brukte to joins hvor den første kobler ansatt og trekning det viser hvem som trakk for den dagen
-- brukte en left join for beholde alle data
COMMIT;


/*
	g) Lag en spørring som viser 
    navn på spillere har vunnet flere enn en gang, 
    hvor mange ganger de har vunnet, 
    og hvilken kommune de bor i.
*/
SELECT k.navn Kommune, s.navn Navn, v.spillernr SpillerNr, count(v.trekningsid) as GangerVunnet
FROM vinner v
RIGHT JOIN spiller s 
ON v.spillerNr = s.spillerNr
LEFT JOIN kommune k 
ON s.kommuneId = k.kommuneId
GROUP BY spillernr
HAVING gangervunnet > 1;


/*
	h) Legg inn en ny kolonne Areal i kommunetabellen. Legg inn fornuftige verdier i den nye kolonnen for de eksisterende kommunene. 
    Velg datatype du selv mener er passende. Arealet skal oppgis i antall kvadratkilometer, med to desimaler.
*/
ALTER TABLE kommune
ADD Areal DECIMAL(10,2) DEFAULT NULL;
UPDATE kommune SET Areal = 454 WHERE KommuneID = 0301;
UPDATE kommune SET Areal = 435.5 WHERE KommuneID = 1101;
UPDATE kommune SET AREAL = 71.35 WHERE KommuneID = 1103;
UPDATE kommune SET AREAL = 72.68 WHERE KommuneID = 1106;
UPDATE kommune SET AREAL = 632.4 WHERE KommuneID = 1507;
UPDATE kommune SET AREAL = 119.5 WHERE KommuneID = 1515;
UPDATE kommune SET AREAL = 64.4  WHERE KommuneID = 1818;
UPDATE kommune SET AREAL = 257  WHERE KommuneID = 3018;
UPDATE kommune SET AREAL = 203  WHERE KommuneID = 3020;
UPDATE kommune SET AREAL = 257  WHERE KommuneID = 3419;
UPDATE kommune SET AREAL = 1229  WHERE KommuneID = 3420;

-- https://no.wikipedia.org/wiki/Fylkesnummer ---	
SELECT * FROM KOMMUNE;
COMMIT;	


/*
	i) Det har vært en ny trekning. 
    Legg inn følgende informasjon i databasen: 
    Trekningen ble avholdt 4. desember 2021. 
    Det var nøyaktig 11 millioner i utbetaling. 
    Det var en ny trekningsansvarlig: Jens Jensen, som bor i Oslo. 
    Det var to vinnere som delte utbetalingen: Lars Andersen, som bor i Ålesund (Lilliveien 56) og 
    Line Jensen som bor på Elverum (Blåklokkaleen 4).
*/
select * from ansatt;
select * from trekning;
INSERT INTO ANSATT 
(AnsattID, Navn, KommuneID) VALUES
(3,'Jens Jensen', '0301');
INSERT INTO trekning
(
	TrekningsID,
    Dato,
    Utbetaling,
    AnsattID
) VALUES
(
	5,
    '2021-12-04',
    11000000,
    3
);

/*
	j) (Vanskelig) Lag et view som viser hvilke fylker som har vunnet hvor mye penger. 
    Viewet skal inneholde fylkets navn, og totale utbetalinger til fylkets spillere, 
    sortert slik at fylket som har vunnet mest kommer først.
*/