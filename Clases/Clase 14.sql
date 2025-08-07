use sakila;
#1
select 
concat(c.first_name, " ", c.last_name) as Full_name,
a.address,
cy.city
from customer c
inner join address a using(address_id)
inner join city cy using(city_id)
inner join country co using(country_id)
where co.country like 'Argentina';

#2
select f.title, lan.name as language,
case f.rating 
	when 'G' then 'G (General Audiences) – All ages admitted.'
	when 'PG' then 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
	when 'PG-13' then 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
	when 'R' then 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
	when 'NC-17' then 'C-17 (Adults Only) – No one 17 and under admitted.'
	else 'NR - Not Rated'
end as 'rating description'
from film f
inner join language lan using(language_id);


#3
SET @parametro_busqueda = 'Tom';
select f.title, f.release_year,concat(a.first_name," ",a.last_name) as Actor from film f
inner join film_actor fa using(film_id)
inner join actor a using(actor_id)
where concat(a.first_name," ",a.last_name) like concat('%',upper(@parametro_busqueda),'%'); 

#4
select f.title, concat(c.first_name," ",c.last_name) as full_name,
case 
	when r.return_date is null then 'No'
	else 'Yes'
end as returned
from rental r 
inner join inventory i using(inventory_id )
inner join film f using(film_id)
inner join customer c using(customer_id)
where month(r.rental_date) = 5 or month(r.rental_date) = 6;

#5
#CAST
select f.title, cast(f.rating as char)as rating_text from film f
#CONVERT
select f.title, convert(f.rating, char)as rating_text from film f

#6
select f.title, concat(c.first_name," ",c.last_name) as full_name,
ifnull(return_date, "No devuelta") as 'fecha devuelta'
from rental r 
inner join inventory i using(inventory_id )
inner join film f using(film_id)
inner join customer c using(customer_id)
where return_date is null;
select f.title, concat(c.first_name," ",c.last_name) as full_name,

coalesce(return_date, "No devuelta") as 'fecha devuelta'
	
from rental r 
inner join inventory i using(inventory_id )
inner join film f using(film_id)
inner join customer c using(customer_id)
where return_date is null;