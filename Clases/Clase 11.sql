-- Crear la base de datos y usarla
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

-- Crear las tablas necesarias
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

-- Insertar datos de ejemplo
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

-- Consultas solicitadas

-- 1. Encontrar todos los títulos de películas que no están en el inventario
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

-- 2. Encontrar todas las películas que están en el inventario pero nunca fueron alquiladas
SELECT f.title, i.inventory_id
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 3. Generar un informe con el nombre del cliente, ID de la tienda, título de la película, fecha de alquiler y devolución
SELECT c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN store s ON i.store_id = s.store_id
ORDER BY s.store_id, c.last_name;

-- 4. Mostrar las ventas por tienda (dinero de películas alquiladas)
SELECT CONCAT(ci.city, ', ', co.country) AS location,
       CONCAT(m.first_name, ' ', m.last_name) AS manager,
       SUM(p.amount) AS total_sales
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff m ON s.manager_staff_id = m.staff_id
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY s.store_id;

-- 5. ¿Qué actor ha aparecido en más películas?
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

-- 6. Mostrar las categorías de películas con mayor duración promedio
SELECT c.name AS category, AVG(f.length) AS average_duration
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id
ORDER BY average_duration DESC;
