USE sakila;


-- 1) 
DROP FUNCTION IF EXISTS stock_by_store;

DELIMITER $$

CREATE FUNCTION stock_by_store(
    film_name VARCHAR(100),
    store INT
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    WHERE f.title = film_name
      AND i.store_id = IFNULL(store, i.store_id);

    RETURN total;
END $$

DELIMITER ;

SELECT stock_by_store('ADAPTATION HOLES', 1);
SELECT stock_by_store('ADAPTATION HOLES', NULL);

-- 2) 
DROP PROCEDURE IF EXISTS sp_people_by_country;

DELIMITER $$

CREATE PROCEDURE sp_people_by_country(
    IN input_country VARCHAR(50),
    OUT result TEXT
)
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE name TEXT;
    DECLARE result_list TEXT DEFAULT '';

    DECLARE cur_names CURSOR FOR
        SELECT CONCAT(c.first_name, ' ', c.last_name)
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = input_country;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN cur_names;

    read_loop: LOOP
        FETCH cur_names INTO name;
        IF finished = 1 THEN
            LEAVE read_loop;
        END IF;

        SET result_list = 
            CASE 
                WHEN result_list = '' THEN name
                ELSE CONCAT(result_list, ' | ', name)
            END;
    END LOOP;

    CLOSE cur_names;

    SET result = result_list;
END $$

DELIMITER ;

SET @lista = '';
CALL sp_people_by_country('Argentina', @lista);
SELECT @lista;

-- 3)

DROP FUNCTION IF EXISTS available_stock;

DELIMITER $$

CREATE FUNCTION available_stock(filmId INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE qty INT;

    SELECT COUNT(*) INTO qty
    FROM inventory i
    LEFT JOIN rental r
        ON i.inventory_id = r.inventory_id
        AND r.return_date IS NULL
    WHERE i.film_id = filmId
      AND r.inventory_id IS NULL;

    RETURN qty;
END $$

DELIMITER ;


SELECT available_stock(1);
SELECT available_stock(50);


DROP PROCEDURE IF EXISTS list_available_inventory;

DELIMITER $$

CREATE PROCEDURE list_available_inventory(
    IN filmId INT,
    IN storeId INT
)
BEGIN
    SELECT i.inventory_id
    FROM inventory i
    WHERE i.film_id = filmId
      AND i.store_id = storeId
      AND NOT EXISTS (
            SELECT 1
            FROM rental r
            WHERE r.inventory_id = i.inventory_id
              AND r.return_date IS NULL
      );
END $$

DELIMITER ;

CALL list_available_inventory(1, 1);
