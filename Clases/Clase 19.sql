use sakila;

#1 
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'analyst123';

#2 
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

#3 
-- mysql -u data_analyst -p
CREATE TABLE prueba (
  id INT PRIMARY KEY,
  nombre VARCHAR(50)
);

#4 
UPDATE film
SET title = 'Padrino Reloaded'
WHERE film_id = 1;

#5 
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
SHOW GRANTS FOR 'data_analyst'@'localhost';

#6 
UPDATE film
SET title = 'Padrino Reloaded'
WHERE film_id = 1;

