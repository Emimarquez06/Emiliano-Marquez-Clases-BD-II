USE sakila;

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    employeeNumber INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    hireDate DATE
);

INSERT INTO employee VALUES
(101, 'Ana', 'Gomez', 'ana@mail.com', '2018-01-10'),
(102, 'Luis', 'Perez', 'luis@mail.com', '2019-03-15'),
(103, 'Carla', 'Diaz', 'carla@mail.com', '2020-06-01');



-- 1) 

INSERT INTO employee VALUES
(104, 'Pedro', 'Ramos', NULL, '2023-05-01');

-- 2)

UPDATE employee 
SET employeeNumber = employeeNumber - 20;

UPDATE employee 
SET employeeNumber = employeeNumber + 20;

-- 3) 
ALTER TABLE employee
ADD age INT CHECK (age BETWEEN 16 AND 70);


-- 4) 
-- EXPLICACIÓN TEÓRICA:
-- actor(actor_id) es PK
-- film(film_id) es PK
-- film_actor(actor_id, film_id) es tabla intermedia

-- film_actor.actor_id → FK hacia actor.actor_id
-- film_actor.film_id → FK hacia film.film_id

-- RELACIÓN:
-- actor 1 ⬄ N film_actor N ⬄ 1 film

-- Esto impide:
-- * Agregar relaciones con actores inexistentes
-- * Agregar relaciones con películas inexistentes
-- * Borrar actores o películas mientras estén relacionadas

-- MANTIENE INTEGRIDAD REFERENCIAL AUTOMÁTICA



-- =========================================================
-- 5)

ALTER TABLE employee
ADD lastUpdate DATETIME,
ADD lastUpdateUser VARCHAR(100);


DELIMITER //

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END //

DELIMITER ;

-- 6) 
SHOW TRIGGERS LIKE 'film%';
SHOW CREATE TRIGGER ins_film;
SHOW CREATE TRIGGER upd_film;
SHOW CREATE TRIGGER del_film;


