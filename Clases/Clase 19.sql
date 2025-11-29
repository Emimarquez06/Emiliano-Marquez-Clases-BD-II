USE sakila;

-- 1) 
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY '12345';

-- 2) 
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- 3)
CREATE TABLE prueba (
  id INT PRIMARY KEY,
  nombre VARCHAR(50)
);


-- 4)
UPDATE sakila.film
SET title = 'NEW TITLE'
WHERE film_id = 1;

-- 5)
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
SHOW GRANTS FOR 'data_analyst'@'localhost';

-- 6) 
UPDATE sakila.film
SET title = 'ANOTHER TITLE'
WHERE film_id = 1;
