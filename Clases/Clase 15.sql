USE sakila;
-- 1)

DROP VIEW IF EXISTS list_of_customers;
CREATE OR REPLACE VIEW list_of_customers AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    ci.city,
    co.country,
    CASE WHEN c.active = 1 THEN 'active' ELSE 'inactive' END AS status,
    c.store_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 2)

DROP VIEW IF EXISTS film_details;
CREATE OR REPLACE VIEW film_details AS
SELECT
    f.film_id,
    f.title,
    f.description,
    GROUP_CONCAT(DISTINCT cat.name SEPARATOR ', ') AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    GROUP_CONCAT(DISTINCT CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name, a.first_name SEPARATOR ', ') AS actors
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category cat ON fc.category_id = cat.category_id
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, f.rental_rate, f.length, f.rating;


-- 3)

DROP VIEW IF EXISTS sales_by_film_category;
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT
    cat.name AS category,
    ROUND(SUM(p.amount),2) AS total_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.category_id, cat.name;


-- 4)

DROP VIEW IF EXISTS actor_information;
CREATE OR REPLACE VIEW actor_information AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(DISTINCT fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;
-- 5) 

DROP VIEW IF EXISTS actor_info;
CREATE OR REPLACE VIEW actor_info AS
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    sub.film_count,
    sub.categories
FROM actor a
LEFT JOIN
(
    SELECT
        fa.actor_id,
        COUNT(DISTINCT fa.film_id) AS film_count,
        GROUP_CONCAT(DISTINCT cat.name ORDER BY cat.name SEPARATOR ', ') AS categories
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    GROUP BY fa.actor_id
) AS sub ON a.actor_id = sub.actor_id;
