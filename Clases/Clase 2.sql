DROP DATABASE IF EXISTS imdb;

CREATE DATABASE IF NOT EXISTS imdb;

USE imdb;

CREATE TABLE actor (
	actor_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (actor_id) 
);

CREATE TABLE film (
    film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT DEFAULT NULL,
    release_year YEAR,
    PRIMARY KEY (film_id)
);

CREATE TABLE film_actor (
	actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE
);


ALTER TABLE film
ADD last_update DATETIME;

ALTER TABLE actor
ADD last_update DATETIME;


ALTER TABLE film_actor ADD
CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE CASCADE;


INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'Sbaraglia'),
('Ricardo', 'Darín'),
('Peter', 'Lanzani');
('Guillermo', 'Francella'),
('Mercedes', 'Morán'),


INSERT INTO film (title, description, release_year) VALUES
('Nueve Reinas', 'Dos estafadores se cruzan con un negocio millonario.', 2000),
('El Secreto de Sus Ojos', 'Un exagente judicial busca resolver un caso sin resolver.', 2009),
('El Robo del Siglo', 'El famoso robo al Banco Río en Acassuso.', 2020);
('El Clan', 'Historia basada en la familia Puccio que secuestraba personas.', 2015),
('Relatos Salvajes', 'Seis historias sobre la violencia cotidiana.', 2014),

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(1, 3),
(2, 4),
(3, 2),
(4, 4),
(5, 5);
