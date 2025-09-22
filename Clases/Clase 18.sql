use sakila;

#1 
delimiter 
CREATE FUNCTION cantidad_copias(
    pelicula_id INT,
    tienda_id INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE copias_vendidas INT;

    SELECT COUNT(*)
    INTO copias_vendidas
    FROM inventory i
    WHERE i.store_id = tienda_id
      AND i.film_id = pelicula_id;

    RETURN copias_vendidas;
END
delimiter ;

SELECT cantidad_copias(1,1) AS total_copias;

#2
delimiter Esta_re_dificil_el_Cursor
create Procedure clientes_x_pais (
in pais text ,
out lista_clientes text

)
begin
	
	declare fin int default 0;
	declare v_cliente varchar(200);

	declare bucle cursor for 
	select concat(c.first_name, " ",c.last_name) from customer c
	inner join address a using(address_id)
	inner join city ci using(city_id)
	inner join country co using(country_id)
	where co.country LIKE pais;

	declare continue handler for NOT FOUND set fin = 1;
	
	set lista_clientes = "";
	
	open bucle;
	
	bucle_loop: loop
		
		fetch bucle into v_cliente;
		if fin = 1 then 
			leave bucle_loop;
		end if;
		
		set lista_clientes = concat(lista_clientes, v_cliente, "; " );
	end loop;

	close bucle;
end Esta_re_dificil_el_Cursor


#3a
show create function inventory_in_stock ;
CREATE DEFINER=`root`@`localhost` FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1) 
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT; 
    DECLARE v_out     INT;


    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
    RETURN TRUE; 
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL; 

    IF v_out > 0 THEN
    RETURN FALSE; 
    ELSE
    RETURN TRUE; 
    END IF;
END
SELECT inventory_in_stock(inventory_id) from inventory i


#3b
show create procedure film_in_stock;
CREATE DEFINER=`root`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT) 
    READS SQL DATA
BEGIN
    SELECT inventory_id
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id); 
    SELECT COUNT(*)
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id)
    INTO p_film_count; 
END

call film_in_stock(1,1,@total);
select @total;
