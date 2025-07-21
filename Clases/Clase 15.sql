CREATE VIEW list_of_customers AS
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_full_name,
    address,
    postal_code AS zip_code,
    phone,
    city,
    country,
    CASE
        WHEN active = 1 THEN 'active'
        ELSE 'inactive'
    END AS status,
    store_id
FROM customers;

CREATE VIEW film_details AS
SELECT
    film_id,
    title,
    description,
    category,
    price,
    length,
    rating,
    GROUP_CONCAT(actor_name SEPARATOR ', ') AS actors
FROM (
    SELECT
        f.film_id,
        f.title,
        f.description,
        f.category,
        f.price,
        f.length,
        f.rating,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name
    FROM film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
) AS film_actors
GROUP BY film_id;


CREATE VIEW sales_by_film_category AS
SELECT
    category,
    COUNT(rental_id) AS total_rental
FROM film_category fc
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY category;

CREATE VIEW actor_information AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

-- Explicación detallada de la vista actor_info

-- Esta vista devuelve información sobre actores y cuántas películas protagonizaron.

-- Consulta (puede variar según el esquema, ejemplo representativo):
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

-- Vistas Materializadas 

-- ¿Qué es una vista materializada?
-- Es una vista cuyos resultados se almacenan físicamente en disco, a diferencia de las vistas normales
-- que son virtuales y se recalculan cada vez que se consultan.

-- ¿Para qué se usan?
-- - Mejorar el rendimiento de consultas complejas (joins, agrupamientos, etc.)
-- - Reducir el tiempo de respuesta en reportes o dashboards.
-- - Mantener snapshots de datos históricos o agregados.

-- ¿Cuáles son sus ventajas?
-- - Aceleran el acceso a datos complejos.
-- - Permiten trabajar con datos preprocesados.
-- - Se pueden refrescar manual o automáticamente (dependiendo del SGBD).

-- ¿Y sus desventajas?
-- - Ocupan espacio físico.
-- - Pueden quedar desactualizadas si no se actualizan correctamente.
-- - Más complejas de administrar que las vistas normales.

-- Alternativas:
-- - Caching en la aplicación.
-- - Tablas temporales.
-- - Denormalización de datos.

-- Sistemas que las soportan:
-- - Oracle (vista materializada con REFRESH)
-- - PostgreSQL (desde la versión 9.3)
-- - SQL Server (como "indexed views")
-- - MySQL: no las soporta nativamente, pero se pueden emular con triggers o jobs programados.

-- Ejemplo en PostgreSQL:
-- CREATE MATERIALIZED VIEW ventas_mensuales AS
-- SELECT cliente_id, SUM(total) AS total_mensual
-- FROM ventas
-- GROUP BY cliente_id;

-- REFRESH MATERIALIZED VIEW ventas_mensuales;


