-- CREACIÓN DE BASE DE DATOS Y USO
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

-- TABLAS EXISTENTES
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
  rating VARCHAR(10) DEFAULT NULL,
  duration SMALLINT UNSIGNED DEFAULT NULL,
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

-- NUEVAS TABLAS NECESARIAS
CREATE TABLE country (
  country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  country VARCHAR(50) NOT NULL,
  PRIMARY KEY (country_id)
);

CREATE TABLE city (
  city_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (city_id),
  FOREIGN KEY (country_id) REFERENCES country (country_id)
);

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10),
  phone VARCHAR(20),
  PRIMARY KEY (address_id),
  FOREIGN KEY (city_id) REFERENCES city (city_id)
);

CREATE TABLE customer (
  customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50),
  address_id SMALLINT UNSIGNED NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (address_id) REFERENCES address (address_id)
);

CREATE TABLE payment (
  payment_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id SMALLINT UNSIGNED NOT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

CREATE TABLE category (
  category_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  PRIMARY KEY (category_id)
);

CREATE TABLE film_category (
  film_id SMALLINT UNSIGNED NOT NULL,
  category_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (film_id, category_id),
  FOREIGN KEY (film_id) REFERENCES film (film_id),
  FOREIGN KEY (category_id) REFERENCES category (category_id)
);

-- INSERCIÓN DE DATOS DE EJEMPLO
-- Países
INSERT INTO country (country) VALUES ('Argentina'), ('Brasil'), ('Chile');

-- Ciudades
INSERT INTO city (city, country_id) VALUES
('Buenos Aires', 1),
('Córdoba', 1),
('Rosario', 1),
('São Paulo', 2),
('Rio de Janeiro', 2),
('Santiago', 3),
('Valparaíso', 3),
('Mendoza', 1),
('La Plata', 1),
('Mar del Plata', 1),
('Salta', 1),
('Tucumán', 1);

-- Direcciones
INSERT INTO address (address, city_id, postal_code, phone) VALUES
('123 Main St', 1, '1000', '123456789'),
('456 Elm St', 2, '5000', '987654321');

-- Clientes
INSERT INTO customer (first_name, last_name, email, address_id, create_date) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 1, NOW()),
('María', 'Gómez', 'maria.gomez@example.com', 2, NOW());

-- Pagos
INSERT INTO payment (customer_id, amount, payment_date) VALUES
(1, 5.99, '2025-04-01'),
(1, 3.99, '2025-04-10'),
(2, 2.99, '2025-04-05');

-- Categorías
INSERT INTO category (name) VALUES ('Action'), ('Drama'), ('Comedy');

-- Películas
INSERT INTO film (title, description, release_year, rating, duration) VALUES
('Inception', 'A mind-bending thriller', 2010, 'PG-13', 148),
('The Irishman', 'A mob drama', 2019, 'R', 209),
('Black Widow', 'A Marvel superhero movie', 2021, 'PG-13', 134),
('Short Film', 'A short film example', 2022, 'G', 90);

-- Relación película-categoría
INSERT INTO film_category (film_id, category_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3);

-- Relación actor-película
INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Robert', 'De Niro'),
('Scarlett', 'Johansson');

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(1, 2);

-- CONSULTAS

-- 1. Obtener la cantidad de ciudades por país, ordenadas por nombre de país y country_id
SELECT co.country, co.country_id, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
ORDER BY co.country, co.country_id;

-- 2. Obtener la cantidad de ciudades por país, mostrando solo los países con más de 10 ciudades, ordenados de mayor a menor cantidad
SELECT co.country, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id, co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY city_count DESC;

-- 3. Generar un informe con nombre del cliente, dirección, total de películas rentadas y total de dinero gastado
SELECT c.first_name, c.last_name, a.address, COUNT(p.payment_id) AS total_rentals, SUM(p.amount) AS total_spent
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address
ORDER BY total_spent DESC;

-- 4. ¿Qué categorías de películas tienen mayor duración promedio?
SELECT cat.name AS category, AVG(f.duration) AS average_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.category_id, cat.name
ORDER BY average_duration DESC;

-- 5. Mostrar ventas por clasificación de película
SELECT f.rating, COUNT(p.payment_id) AS total_sales
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN payment p ON p.customer_id IN (
  SELECT customer_id FROM customer
)
GROUP BY f.rating;
