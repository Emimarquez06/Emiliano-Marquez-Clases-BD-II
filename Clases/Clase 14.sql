USE sakila;

-- 1) 

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.address,
    ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

-- 2) 

SELECT 
    f.title,
    l.name AS language,
    CASE f.rating
        WHEN 'G' THEN 'General Audiences'
        WHEN 'PG' THEN 'Parental Guidance Suggested'
        WHEN 'PG-13' THEN 'Parents Strongly Cautioned'
        WHEN 'R' THEN 'Restricted'
        WHEN 'NC-17' THEN 'Adults Only'
        ELSE 'No Rating'
    END AS rating_description
FROM film f
JOIN language l ON f.language_id = l.language_id;


-- 3)
SELECT 
    f.title,
    f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE 
    CONCAT(a.first_name, ' ', a.last_name) LIKE 
    CONCAT('%', TRIM('PONÉ ACA EL NOMBRE DEL ACTOR'), '%');
-- 4)

SELECT 
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CASE 
        WHEN r.return_date IS NULL THEN 'No'
        ELSE 'Yes'
    END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);

-- 5)

SELECT 
    CAST(rental_date AS DATE) AS only_date
FROM rental;

SELECT 
    CONVERT(rental_date, DATE) AS only_date
FROM rental;


-- 6) 


SELECT 
    first_name,
    IFNULL(email, 'SIN MAIL') AS email_displayed
FROM customer;

SELECT 
    first_name,
    COALESCE(email, address_id, 'SIN DATOS') AS info
FROM customer;

SELECT 
    first_name,
    ISNULL(email) AS is_email_null
FROM customer;

