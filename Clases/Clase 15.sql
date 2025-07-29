use sakila;

-- 1 
create view list_of_customers as
	select 
	c.customer_id as Id,
	concat(c.first_name, " ", c.last_name) as 'Full Name',
	a.address as Address,
	a.postal_code as 'ZIP Code',
	a.phone as Phone,
	c1.city as City,
	c2.country as Country,
	c.store_id as 'Store Id',
	case 
		when c.active = 1 then 'active'
		else 'inactive'
	end as Status
	from customer c
	inner join address a using(address_id )
	inner join city c1 using(city_id)
	inner join country c2 using(country_id)
	
	
select * from list_of_customers;

-- 2 

create view film_details as

select
f.film_id as Id ,
f.title as Title,
f.description as Descripction,
c.name as Category,
f.rental_rate as Price,
f.`length` as Length,
f.rating as Rating,
group_concat(concat(a.first_name, " ", a.last_name) separator ", ") as Actors
from film f
inner join film_category fc using(film_id) 
inner join category c using(category_id)
inner join film_actor fa using(film_id)
inner join actor a using(actor_id)
group by f.film_id, c.name;

select * from film_details;

-- 3 

create view sales_by_film_category as

select 
c.name as Category,
(

select sum(p.amount) from payment p
inner join rental r using(rental_id)
inner join inventory i using(inventory_id)
inner join film f using(film_id)
inner join film_category fc using(film_id)
inner join category c1 using(category_id)
where c1.category_id = c.category_id

) as total_rental
from category c

select * from sales_by_film_category

-- 4 

create view actor_information as

select 
a.actor_id,
a.first_name,
a.last_name,
count(f.film_id) as amount
from actor a
inner join film_actor fa using(actor_id )
inner join film f using(film_id)
group by a.actor_id 

select * from actor_information

-- 5 

select * from actor_info a;

# la query seria similar a la de la consigna cuatro, donde obtenemos id, nombre y apellido del actor, sin embargo
# en vez de tener la cantidad de peliculas en las que actuo cada actor, se tiene en CUALES peliculas actuo, subdivididas
# dentro del mismo group_concat por categorias. Esto se podria hacer de la sigueitne forma:

select group_concat(CONCAT(cat.name, ": ", (

select group_concat(f.title separator ", ") from film f
inner join film_category fc using(film_id)
inner join category c1 using(category_id)
where c1.category_id = cat.category_id

)
) separator " | ") as films from category cat
group by cat.category_id

# Entonces luego, agregamos esto como subconsulta a la query inicial y le agregamos el validador para que sean solo 
# las del actor de esa row:

select 
a.actor_id,
a.first_name,
a.last_name,
(select group_concat(CONCAT(cat.name, ": ", (

select group_concat(f.title separator ", ") from film f
inner join film_category fc using(film_id)
inner join category c1 using(category_id)
inner join film_actor fa1 using(film_id)
inner join actor a2 using(actor_id)
 
where c1.category_id = cat.category_id and a2.actor_id = a.actor_id

)
) separator " | ") from category cat
inner join film_category fc1 using(category_id)
inner join film f1 using(film_id)
inner join film_actor fa using(film_id)
inner join actor a1 using(actor_id)
where a1.actor_id = a.actor_id

) as films
from actor a
inner join film_actor fa using(actor_id )
inner join film f using(film_id)
group by a.actor_id;



-- 6 
 
# Una vista es como una instancia de query que se guarda como una tabla en la Base de Datos, no es parte de la estructura de la Base de Datos,
# Sino que es como una "tabla virtual", la cual sirve para no estar calculando las logicas de consultas usadas


#Una vista materializada, es esa vista que deja de ser una tabala virtual y se vuelve parte de la Base de Datos, que se suele usar para calculos mas complejos 