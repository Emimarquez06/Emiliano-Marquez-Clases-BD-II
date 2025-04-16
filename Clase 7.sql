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

INSERT INTO direcciones (direcciones, city, postal_code, phone) VALUES
('123 Main St', 'San José', '3100', '123456789'),
('456 Elm St', 'Paraná', '3100', '987654321');

INSERT INTO customer (first_name, last_name, email, address_id, create_date) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 1, NOW()),
('María', 'Gómez', 'maria.gomez@example.com', 2, NOW());

INSERT INTO payment (customer_id, amount, payment_date) VALUES
(1, 5.99, '2025-04-01'),
(1, 3.99, '2025-04-10'),
(2, 2.99, '2025-04-05');

-- 1. Encontrar las películas con menor duración, mostrando título y clasificación
SELECT title, rating
FROM film
WHERE duration = (SELECT MIN(duration) FROM film);

-- 2. Obtener el título de la película con la menor duración. Si hay más de una, no devolver resultados
SELECT title
FROM film
WHERE duration = (SELECT MIN(duration) FROM film)
HAVING COUNT(*) = 1;

-- 3. Generar un informe con la lista de clientes mostrando el pago más bajo realizado por cada uno, incluyendo su información y dirección
-- MIN
SELECT c.customer_id, c.first_name, c.last_name, a.address, a.city, MIN(p.amount) AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address, a.city;

-- ANY
SELECT c.customer_id, c.first_name, c.last_name, a.address, a.city, p.amount AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount <= ALL (
    SELECT amount
    FROM payment
    WHERE customer_id = c.customer_id
);

-- 4. Generar un informe que muestre la información del cliente con el pago más alto y el más bajo en la misma fila
SELECT c.customer_id, c.first_name, c.last_name, a.address, a.city,
       MAX(p.amount) AS highest_payment,
       MIN(p.amount) AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address, a.city;