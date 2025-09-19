use sakila;



#1-a
select * from address a 
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

#1-abis
select * from address a 
where a.postal_code not in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

#1-b
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

#1-c
explain
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672")

#1-cbis
SET profiling = 1;
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672");
show PROFILES;

#1-d
CREATE INDEX postalCode ON address(postal_code);

#1-e
SET profiling = 1;
select a.address, a.postal_code, c.city, co.country from address a 
inner join city c using(city_id)
inner join country co using(country_id)
where a.postal_code in ("35200","17886","83579","53561","42399","18743","93896","77948","45844","53628","1027","10672");
show PROFILES;

#2
SET profiling = 1;
select * from actor a
where a.first_name LIKE 'Penelope';
show PROFILES;
SET profiling = 1;
select * from actor a
where a.last_name LIKE 'GUINESS';
show PROFILES; 

#3
SET profiling = 1;
SELECT film_id, title, description
FROM film
WHERE description LIKE '%Action%';
show PROFILES;
Alter table film
add FULLTEXT(description);
SET profiling = 1;
SELECT film_id, title, description
FROM film
WHERE MATCH (description) AGAINST('Action');
show PROFILES; 
