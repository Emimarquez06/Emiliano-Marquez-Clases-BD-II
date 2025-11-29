USE sakila;

-- 1) 

SELECT *
FROM address
WHERE postal_code IN ('35200', '17886', '77050');


SELECT a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('35200', '17886');

SELECT *
FROM address
WHERE postal_code = '77050';

SET profiling = 1;

SELECT *
FROM address
WHERE postal_code = '77050';

SHOW PROFILES;

CREATE INDEX idx_postal_code ON address(postal_code);

SELECT *
FROM address
WHERE postal_code = '77050';

SHOW PROFILES;

-- 2) 
SELECT *
FROM actor
WHERE first_name = 'SCARLETT';


SELECT *
FROM actor
WHERE last_name = 'JOHANSSON';

CREATE INDEX idx_first_name ON actor(first_name);

-- 3) 
SELECT title, description
FROM film
WHERE description LIKE '%car%';

SELECT title, description
FROM film_text
WHERE MATCH(description) AGAINST('car' IN NATURAL LANGUAGE MODE);


