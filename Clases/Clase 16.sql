use sakila;

-- 1) 
SORT() no existe, se usa ORDER BY
TO_DATE() es de Oracle, en MySQL se usa STR_TO_DATE()
Las demás (DATE_ADD, FLOOR, MID, LENGTH) son válidas en MySQL

-- 2) 
select distinct s.staff_id, s.first_name, s.last_name
from staff s
join payment p on s.staff_id = p.staff_id;

-- 3) 
select title, length
from film
order by length desc;

-- 4) 
select c.customer_id, c.first_name, c.last_name
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'Argentina';

-- 5) 
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_recaudado
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id, s.first_name, s.last_name;

-- 6) 
select f.title
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
where c.first_name = 'MARY' and c.last_name = 'SMITH';

