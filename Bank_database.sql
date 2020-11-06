CREATE DATABASE UBRIR;
USE UBRIR;

CREATE TABLE table1
(
	ID INT,
    no INT PRIMARY KEY,
    dat1 DATE NOT NULL,
    stavka DECIMAL NOT NULL,
    dat2 DATE NOT NULL,
    sum DECIMAL,
    FOREIGN KEY(ID) REFERENCES table2(ID)
);

CREATE TABLE table2
(
	ID INT PRIMARY KEY,
    FIO VARCHAR(255)
);

CREATE TABLE table3
(
	no INT PRIMARY KEY,
    type VARCHAR(255),
    sum DECIMAL,
    FOREIGN KEY(no) REFERENCES table1(no)
);
  
INSERT INTO table1 VALUES
('1', '1', '2008-10-23', '1000.00', '2010-10-10', '1500.00'),
('1', '2', '2009-10-20', '10000.00', '2010-10-10', '15000.00'),
('1', '3', '2010-01-01', '1050.00', '2010-10-10', '1500.00'),
('2', '4', '2010-01-01', '10050.00', '2010-12-10', '15000.00'),
('3', '5', '2011-10-11', '200000.00', '2025-10-10', '1500000.00'),
('3', '6', '2007-08-23', '100000.00', '2020-10-10', '1500000.00'),
('4', '7', '2007-10-23', '100500.00', '2030-10-10', '991500.00'),
('4', '8', '2010-12-26', '100950.00', '2021-10-10', '1001500.00'),
('5', '9', '2010-01-01', '1000.00', '2020-10-10', '1500.00'),
('6', '10', '2006-10-23', '81000.00', '2022-10-10', '91500.00'),
('7', '11', '2008-10-23', '651000.00', '2023-10-10', '991500.00'),
('8', '12', '2016-10-20', '981000.00', '2026-10-10', '1001500.00'),
('9', '13', '2016-10-23', '31000.00', '2027-10-10', '501500.00'),
('9', '14', '2015-10-23', '21000.00', '2028-10-10', '501500.00'),
('10', '15', '2018-10-23', '5000.00', '2020-10-10', '61500.00'),
('10', '16', '2008-10-23', '1000.00', '2020-10-10', '1500.00'),
('10', '17', '2009-10-23', '1000.00', '2030-10-10', '1500.00'),
('11', '18', '2010-10-23', '7000.00', '2020-10-10', '91500.00'),
('12', '19', '2005-10-23', '600.00', '2010-10-10', '1500.00'),
('13', '20', '2006-10-23', '500.00', '2010-10-10', '1500.00'),
('13', '21', '2009-10-23', '1000.00', '2010-10-10', '1500.00');

INSERT INTO table2 VALUES
('1', 'Кр'),
('2', 'Др'),
('3', 'Ип'),
('4', 'Ог'),
('5', 'Дщ'),
('6', 'Дз'),
('7', 'Дщ'),
('8', 'Жз'),
('9', 'Ке'),
('10', 'Кз'),
('11', 'Хз'),
('12', 'Ек'),
('13', 'Бл');

INSERT INTO table3 VALUES
('1', 'a', '10000.00'),
('3', 'b', '100000.00'),
('5', 'c', '60000.00'),
('6', 'a', '7000.00'),
('8', 'c', '5550000.00'),
('9', 'c', '500.00'),
('11', 'a', '500000.00'),
('12', 'b', '100000.00'),
('20', 'a', '100500.00');

-- Вывести все договора, у которых срок окончания наступит через 6 и более месяцев
SELECT `no` FROM `table1`
WHERE `dat2` >= DATE_ADD(CURDATE(), INTERVAL 6 MONTH) - INTERVAL 1 MONTH;

-- Вывести сгруппированное кол-во договоров, где одинаковая ставка 
-- (два поля в результате - ставка и кол-во договоров с ней)
SELECT stavka, COUNT(ID) AS quantity FROM table1
GROUP BY stavka;

-- Вывести среднюю сумму договоров с датой открытия = '01.01.2010'
SELECT AVG(sum) FROM table1
WHERE dat1 = '2010-01-01';

-- Вывести даты открытия договора, в которые было открыто более 3 договоров с указанием кол-ва договоров 
-- (два поля в результате - дата открытия и кол-во открытых в эту дату договоров)
SELECT dat1, COUNT(`no`) AS quantity 
FROM table1
GROUP BY dat1
HAVING COUNT(`no`) > 3;

-- Вывести все договора, клиентов и обеспечение по договорам 
-- (если таковое имеется)
SELECT `table1`.`no`, `table2`.`ID`, `table2`.`FIO`, `table3`.`type`, `table3`.`sum`
FROM `table1` LEFT OUTER JOIN `table3`
ON `table1`.`no` = `table3`.`no`
INNER JOIN `table2`
ON `table1`.`ID` = `table2`.`ID`;

-- вывести сумму обеспечения по договорам с датой открытия больше, чем '01.01.2010'
SELECT `table3`.`sum` FROM `table3`
INNER JOIN `table1`
ON `table3`.`no` = `table1`.`no`
WHERE `dat1` > '2010-01-01';

-- вывести всех клиентов, договора по ним и обеспечение с условием, 
-- что по 1 клиенту выводим только 1 договор с максимальной датой открытия
SELECT `k`.`ID`, `k`.`FIO`, `p`.`no`, `k`.`data`, `table3`.`type`, `table3`.`sum`
FROM (SELECT `table2`.`ID`, `table2`.`FIO`, MAX(`table1`.`dat1`) AS `data` FROM `table2` INNER JOIN `table1` ON `table2`.`ID` = `table1`.`ID` GROUP BY ID) AS k
INNER JOIN (SELECT `table2`.`ID`, `table1`.`no`, `table1`.`dat1` FROM `table2` INNER JOIN `table1` ON `table2`.`ID` = `table1`.`ID`) AS p
ON `p`.`dat1` = `k`.`data` AND `p`.`ID` = `k`.`ID`
LEFT OUTER JOIN `table3`
ON `p`.`no` = `table3`.`no`;