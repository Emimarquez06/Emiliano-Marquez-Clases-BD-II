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

SELECT title, description 
FROM film 
WHERE release_year > 2010;

SELECT actor.first_name, actor.last_name, film.title
FROM film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN film ON film_actor.film_id = film.film_id;

SELECT title, release_year
FROM film
ORDER BY release_year DESC;

SELECT * FROM actor
LIMIT 10;

SELECT title, description 
FROM film 
WHERE description LIKE '%thriller%';

SELECT title, release_year, 150 * 2 AS "Rental Rate Multiplied" 
FROM film;
