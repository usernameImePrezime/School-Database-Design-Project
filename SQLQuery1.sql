USE master;
GO

ALTER DATABASE ProdavnicaDelova SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE IF EXISTS ProdavnicaDelova;
GO

CREATE DATABASE ProdavnicaDelova;
GO

USE ProdavnicaDelova;
GO

DROP TABLE IF EXISTS Narudzbina;
DROP TABLE IF EXISTS Deo;
DROP TABLE IF EXISTS Prodavac;
DROP TABLE IF EXISTS Dobavljac;
GO

CREATE TABLE Dobavljac (
    idD INT IDENTITY(1,1) PRIMARY KEY,
    naziv_dobavljaca VARCHAR(20) NOT NULL,
    grad VARCHAR(20) NOT NULL
);
GO

CREATE TABLE Deo (
    idDeo INT IDENTITY(1,1) PRIMARY KEY,
    idDobavljac INT NOT NULL,
    naziv_dela VARCHAR(30) NOT NULL,
    opis VARCHAR(50),
    tezina DECIMAL(7,2),
    cena DECIMAL(7,2),
    FOREIGN KEY (idDobavljac) REFERENCES Dobavljac(idD)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO

CREATE TABLE Prodavac (
    idP INT IDENTITY(1,1) PRIMARY KEY,
    naziv_prodavca VARCHAR(20) NOT NULL,
    grad VARCHAR(20) NOT NULL
);
GO

CREATE TABLE Narudzbina (
    idN INT IDENTITY(1,1) PRIMARY KEY,
    datum_narudzbine DATE NOT NULL,
    broj_delova INT,
    idDeo INT NOT NULL,
    idDobavljac INT NOT NULL,
    idProdavac INT NOT NULL,
    FOREIGN KEY (idDeo) REFERENCES Deo(idDeo)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (idDobavljac) REFERENCES Dobavljac(idD)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (idProdavac) REFERENCES Prodavac(idP)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CHECK (broj_delova <= 10)
);
GO

 -- 1 Za svaku od tabela uneti po 10 podataka
INSERT INTO Dobavljac (naziv_dobavljaca, grad) 
VALUES 
('Dobavljac 1', 'Beograd'),
('Dobavljac 2', 'Novi Sad'),
('Dobavljac 3', 'Niš'),
('Dobavljac 4', 'Subotica'),
('Dobavljac 5', 'Zrenjanin'),
('Dobavljac 6', 'Kragujevac'),
('Dobavljac 7', 'Pančevo'),
('Dobavljac 8', 'Peking'),
('Dobavljac 9', 'Kraljevo'),
('Dobavljac 10', 'Užice');
GO

INSERT INTO Deo (idDobavljac, naziv_dela, opis, tezina, cena) 
VALUES 
(1, 'Kružna testera, 1500W', 'Visokokvalitetna kružna testera', 3.5, 5000.00),
(2, 'Motorna testera', 'Testera za drvo', 7.2, 12000.00),
(3, 'Bušilica', 'Bušilica sa nastavcima', 2.0, 3000.00),
(4, 'Set odvijača', 'Set od 5 odvijača', 0.5, 1500.00),
(5, 'Čekić', 'Mali čekić', 1.0, 1000.00),
(6, 'Brusilica', 'Brusilica za metal', 4.5, 7000.00),
(7, 'Električna testera', 'Testera za sečenje drveta', 6.0, 8000.00),
(8, 'LED reflektor, 80W', 'LED reflektor za osvetljenje', 1.8, 2500.00),
(9, 'Testera za metal', 'Ručna testera za metal', 2.5, 4000.00),
(10, 'Šmirgla', 'Šmirgla za drvo', 0.3, 500.00);
GO

INSERT INTO Prodavac (naziv_prodavca, grad) 
VALUES 
('Prodavac 1', 'Beograd'),
('Prodavac 2', 'Novi Sad'),
('Prodavac 3', 'Subotica'),
('Prodavac 4', 'Zrenjanin'),
('Prodavac 5', 'Niš'),
('Prodavac 6', 'Beograd'),
('Prodavac 7', 'Pančevo'),
('Prodavac 8', 'Kraljevo'),
('Prodavac 9', 'Čačak'),
('Prodavac 10', 'Užice');
GO

INSERT INTO Narudzbina (datum_narudzbine, broj_delova, idDeo, idDobavljac, idProdavac) 
VALUES 
('2017-01-05', 5, 1, 1, 1),
('2017-01-07', 3, 2, 2, 2),
('2017-01-10', 7, 3, 3, 3),
('2017-01-12', 2, 4, 4, 4),
('2017-01-12', 4, 5, 5, 5),
('2017-01-18', 6, 6, 6, 6),
('2017-01-21', 8, 7, 7, 7),
('2017-01-21', 3, 8, 8, 8),
('2017-01-28', 7, 9, 9, 9),
('2017-01-31', 9, 10, 10, 10);
GO

-- 2 Naći sve dobavljače iz Novog Sada i ispisati njihov naziv
SELECT naziv_dobavljaca 
FROM Dobavljac 
WHERE grad = 'Novi Sad';
GO

-- 3 Naći sve nazive prodavaca koji su iz istog grada, kao i dobavljač od koga je nabavljen bilo koji deo
SELECT DISTINCT p.naziv_prodavca 
FROM Prodavac p
JOIN Narudzbina n ON p.idP = n.idProdavac
JOIN Dobavljac d ON n.idDobavljac = d.idD
WHERE p.grad = d.grad;
GO

-- 4 Naći najjeftiniji deo i ispisati njegov naziv i cenu
SELECT TOP 1 naziv_dela, cena 
FROM Deo 
ORDER BY cena ASC;
GO

-- 5 Naći prosečnu težinu svih naručenih delova koji su namenjeni za Beogradske prodavce. Ispisati prosečnu težinu delova
SELECT AVG(d.tezina) AS prosecna_tezina
FROM Deo d
JOIN Narudzbina n ON d.idDeo = n.idDeo
JOIN Prodavac p ON n.idProdavac = p.idP
WHERE p.grad = 'Beograd';
GO

-- 6 Naći sve delove čiji naziv sadrži reč 'testera' (rezultati mogu biti npr: testera, motorna testera, električna testera, testera za drvo). Ispisati nazive delova
SELECT naziv_dela 
FROM Deo 
WHERE naziv_dela LIKE '%testera%';
GO

-- 7 Naći ukupan broj narudžbina između 01.01.2017 i 31.01.2017
SELECT COUNT(*) AS broj_narudzbina
FROM Narudzbina 
WHERE datum_narudzbine BETWEEN '2017-01-01' AND '2017-01-31';
GO

-- 8 Naći sve narudžbine koje su bile istog dana i koliko ih je bilo. Ispisati datum i broj narudžbina
SELECT datum_narudzbine, COUNT(*) AS broj_narudzbina
FROM Narudzbina
GROUP BY datum_narudzbine
HAVING COUNT(*) > 1;
GO

-- 9 Povećati cenu za svaki deo čiji je naziv 'Kružna testera, 1500W' za 20 posto
UPDATE Deo
SET cena = cena * 1.2
OUTPUT inserted.naziv_dela, inserted.cena
WHERE naziv_dela = 'Kružna testera, 1500W';
GO

-- 10 Zbog neispravne robe, obrisati sve naručene delove čiji je naziv 'Reflektor LED, 80W', koji su naručeni od dobavljača iz 'Pekinga'

-- Prvo brisemo iz Narduzbine
DELETE FROM Narudzbina
WHERE idDeo IN (
    SELECT d.idDeo
    FROM Deo d
    JOIN Dobavljac da ON d.idDobavljac = da.idD
    WHERE d.naziv_dela = 'LED reflektor, 80W' 
    AND da.grad = 'Peking'
);

-- Sad brisemo iz dela
DELETE FROM Deo
WHERE naziv_dela = 'LED reflektor, 80W'
AND idDeo IN (
    SELECT d.idDeo
    FROM Deo d
    JOIN Dobavljac da ON d.idDobavljac = da.idD
    WHERE d.naziv_dela = 'LED reflektor, 80W' 
    AND da.grad = 'Peking'
);

SELECT * FROM Deo;
GO
