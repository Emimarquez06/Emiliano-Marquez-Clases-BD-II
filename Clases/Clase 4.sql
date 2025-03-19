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

#CONSULTAS
#1-SELECT title, description FROM film;

#2-SELECT DISTINCT release_year FROM film;

#3-SELECT title, release_year FROM film;

#4-SELECT title, description FROM film;

#5-SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Inception';

#6-SELECT actor_id, first_name, last_name FROM actor;

#7-SELECT f1.title AS film1, f2.title AS film2, f1.release_year
FROM film f1
JOIN film f2 ON f1.release_year = f2.release_year AND f1.film_id < f2.film_id;

#8-SELECT f.title, a.first_name, a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id;