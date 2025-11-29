USE sakila;

-- 1) 
SELECT 
    f.title
FROM film f
LEFT JOIN inventory i 
    ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

-- 2)
SELECT DISTINCT 
    f.title,
    i.inventory_id
FROM inventory i
LEFT JOIN rental r 
    ON i.inventory_id = r.inventory_id
JOIN film f 
    ON f.film_id = i.film_id
WHERE r.rental_id IS NULL;

-- 3) 
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    s.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM customer c
JOIN rental r 
    ON c.customer_id = r.customer_id
JOIN inventory i 
    ON r.inventory_id = i.inventory_id
JOIN film f 
    ON i.film_id = f.film_id
JOIN store s 
    ON s.store_id = i.store_id
ORDER BY s.store_id, c.last_name;

-- 4)
SELECT 
    s.store_id,
    SUM(p.amount) AS total_sales
FROM store s
JOIN staff st 
    ON s.store_id = st.store_id
JOIN payment p 
    ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 5)
SELECT 
    s.store_id,
    CONCAT(ct.city, ', ', co.country) AS location,
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    SUM(p.amount) AS total_sales
FROM store s
JOIN address a 
    ON s.address_id = a.address_id
JOIN city ct 
    ON a.city_id = ct.city_id
JOIN country co 
    ON ct.country_id = co.country_id
JOIN staff m 
    ON s.manager_staff_id = m.staff_id
JOIN payment p 
    ON p.staff_id = m.staff_id
GROUP BY s.store_id, location, manager;

-- 6)
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS total_movies
FROM actor a
JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY total_movies DESC
LIMIT 1;
