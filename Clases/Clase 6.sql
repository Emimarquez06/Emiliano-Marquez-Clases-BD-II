-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id)
);

CREATE TABLE film (
  film_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year YEAR DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id)
);

CREATE TABLE film_actor (
  actor_id SMALLINT UNSIGNED NOT NULL,
  film_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (actor_id, film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- INSERCIÓN DE DATOS
INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Robert', 'De Niro'),
('Scarlett', 'Johansson');

INSERT INTO film (title, description, release_year) VALUES
('Inception', 'A mind-bending thriller', 2010),
('The Irishman', 'A mob drama', 2019),
('Black Widow', 'A Marvel superhero movie', 2021);

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),  -- Leonardo DiCaprio en Inception
(2, 2),  -- Robert De Niro en The Irishman
(3, 3),  -- Scarlett Johansson en Black Widow
(1, 2);  -- Leonardo DiCaprio en The Irishman

-- CONSULTAS
-- 1. Listar todos los actores que comparten el mismo apellido y mostrarlos en orden
SELECT a1.actor_id, a1.first_name, a1.last_name
FROM actor a1
JOIN actor a2 ON a1.last_name = a2.last_name AND a1.actor_id <> a2.actor_id
ORDER BY a1.last_name, a1.first_name;

-- 2. Encontrar actores que no trabajaron en ninguna película
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- 3. Encontrar clientes que alquilaron solo una película
-- NOTA: Se asume que hay una tabla llamada 'rental' para esta consulta, ajústala según sea necesario.
SELECT customer_id, COUNT(rental_id) AS num_rentals
FROM rental
GROUP BY customer_id
HAVING num_rentals = 1;

-- 4. Encontrar clientes que alquilaron más de una película
SELECT customer_id, COUNT(rental_id) AS num_rentals
FROM rental
GROUP BY customer_id
HAVING num_rentals > 1;

-- 5. Listar los actores que actuaron en 'Inception' o 'The Irishman'
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('Inception', 'The Irishman');

-- 6. Listar los actores que actuaron en 'Inception' pero no en 'The Irishman'
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Inception'
AND NOT EXISTS (
    SELECT 1
    FROM film_actor fa2
    JOIN film f2 ON fa2.film_id = f2.film_id
    WHERE fa2.actor_id = a.actor_id AND f2.title = 'The Irishman'
);
