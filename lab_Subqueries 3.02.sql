

-- Lab | SQL Subqueries 3.02
-- In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

-- Instructions

 -- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(*) AS number_of_copies FROM(
SELECT f.film_id, i.inventory_id FROM film f
JOIN inventory i
USING (film_id)
WHERE f.title='Hunchback Impossible'
) sub1;

-- 2.List all films whose length is longer than the average of all the films.
SELECT AVG(length) FROM film;

SELECT film_id, title, length FROM film
WHERE length > (
SELECT avg(length)FROM film
);
-- 3.Use subqueries to display all actors who appear in the film Alone Trip

SELECT *  FROM film_actor WHERE film_id = 17;
SELECT * FROM actor WHERE actor_id IN (3,12,13,82,100,160,167,187);
SELECT * FROM film WHERE title = "alone Trip";

SELECT first_name, last_name, actor_id
FROM actor 
WHERE actor_id in(
SELECT actor_id FROM film_actor
	WHERE film_id in(
    SELECT film_id FROM film
		WHERE title = "Alone Trip")
        );
        
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select * from category;
select * from film;
select * from film_category;

SELECT title FROM film
WHERE film_id in(
SELECT film_id FROM film_category
	WHERE category_id in(
    SELECT category_id FROM category
		WHERE name = 'family')
        );

-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.   
        
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM country;
SELECT first_name, last_name, email FROM customer
WHERE address_id in(
SELECT address_id FROM address
    WHERE city_id IN(
    SELECT city_id FROM city
    WHERE country_id IN(
    SELECT country_id FROM country
    WHERE country='CANADA'))
    );
    
-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT actor_id, COUNT(film_id) FROM film_actor
GROUP by actor_id
ORDER by COUNT(film_id) DESC;
SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id= '107'
);

-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer
--  ie the customer that has made the largest sum of payments
SELECT customer_id, COUNT(payment_id) FROM payment
GROUP by customer_id
ORDER by COUNT(payment_id) DESC;

SELECT customer_id, SUM(amount) FROM payment
GROUP by customer_id
ORDER by SUM(amount) DESC
LIMIT 1;
 -- customer_id =526 is the most profitable
 
SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM inventory
WHERE inventory_id IN (
SELECT inventory_id FROM rental
WHERE customer_id='526')
);

-- 8.Customers who spent more than the average payments.
SELECT AVG(amount) FROM payment;

SELECT * FROM customer
WHERE customer_id IN (
SELECT customer_id FROM payment
WHERE amount> (
SELECT
AVG(amount) FROM payment)
);

