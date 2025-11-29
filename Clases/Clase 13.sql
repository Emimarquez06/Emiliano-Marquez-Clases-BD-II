USE sakila;

-- 1) 
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (
    1,
    'Emi',
    'AlumnoSQL',
    'emi@test.com',
    (
        SELECT MAX(a.address_id)
        FROM address a
        JOIN city c ON a.city_id = c.city_id
        JOIN country co ON c.country_id = co.country_id
        WHERE co.country = 'United States'
    ),
    1
);


-- 2) 
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    (
        SELECT MAX(i.inventory_id)
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE f.title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
    ),
    (SELECT MAX(customer_id) FROM customer),
    (
        SELECT staff_id
        FROM staff
        WHERE store_id = 2
        LIMIT 1
    )
);

-- 3)

UPDATE film
SET release_year = CASE rating
    WHEN 'G' THEN 2001
    WHEN 'PG' THEN 2005
    WHEN 'PG-13' THEN 2010
    WHEN 'R' THEN 2015
    WHEN 'NC-17' THEN 2020
END;

-- 4) 

UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
);

-- 5)

-- A)
DELETE FROM payment
WHERE rental_id IN (
    SELECT rental_id FROM rental
    WHERE inventory_id IN (
        SELECT inventory_id FROM inventory
        WHERE film_id = (
            SELECT film_id FROM film WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
        )
    )
);

-- B)
DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id FROM inventory
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
    )
);

-- C)
DELETE FROM inventory
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
);

-- D)
DELETE FROM film_actor
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
);

--E)
DELETE FROM film_category
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA'
);

--F)
DELETE FROM film
WHERE title = 'PONÉ ACÁ EL TÍTULO DE LA PELÍCULA';

-- 6)

-- A)
SELECT inventory_id
FROM inventory
WHERE inventory_id NOT IN (
    SELECT inventory_id FROM rental WHERE return_date IS NULL
)
LIMIT 1;

-- B)
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    9,  
    (SELECT MAX(customer_id) FROM customer),
    (SELECT staff_id FROM staff LIMIT 1)
);

-- C)
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT MAX(customer_id) FROM customer),
    (SELECT staff_id FROM staff LIMIT 1),
    (SELECT MAX(rental_id) FROM rental),
    4.99,
    NOW()
);
