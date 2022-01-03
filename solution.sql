#Drop column picture from staff
Alter Table sakila.staff
Drop Column Picture;

-- #A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly
SELECT 
    *
FROM
    sakila.customer
WHERE
    first_name = 'Tammy';
Insert into sakila.staff
Values('3','Tammy','Sanders','79','TAMMY.SANDERS@sakilacustomer.org','2','1','Tammy',Null,'2006-02-15 04:57:20');


-- #Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date 
-- for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information 
-- you would need to add there. You can query those pieces of information. For eg., you would notice that you need 
-- customer_id information as well. To get that you can use the following query:

SELECT 
    *
FROM
    sakila.customer
WHERE
    first_name = 'CHARLOTTE'
        AND last_name = 'HUNTER';-- to determine customer_id (130)

SELECT 
    MAX(rental_id)
FROM
    sakila.rental;-- For determining rental_id for new customer(It is 16049,so the rental_id of new record will be 16050)

SELECT 
    film_id
FROM
    sakila.film
WHERE
    title = 'Academy Dinosaur';-- to determine film_id for new record(1)

SELECT 
    inventory_id
FROM
    sakila.inventory
WHERE
    film_id = 1
ORDER BY inventory_id DESC;-- to determine new inventory_id (As there are 8 inventory_id for film_id=1,the new record's inventory_id will be 9)

SELECT 
    staff_id
FROM
    sakila.staff
WHERE
    first_name = 'Mike'
        AND last_name = 'Hillyer'; -- to determine staff_id (1)


-- Insert this values to rental table
insert into sakila.rental
values (16050, CURRENT_TIMESTAMP, '9', '130', NULL, '1', CURRENT_TIMESTAMP);

-- We can check that new row is created
SELECT 
    *
FROM
    sakila.rental
WHERE
    rental_id = 16050;


-- #Check if there are any non-active users
SELECT 
    COUNT(*)
FROM
    customer
WHERE
    active = 0;

-- Create a table backup table as suggested
CREATE TABLE deleted_users (
    customer_id INTEGER(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    new_date DATETIME
);
-- Check if table is created
SELECT 
    *
FROM
    sakila.deleted_users;


#Insert the non-active users in the table backup table
insert into deleted_users
select customer_id,email,current_timestamp as new_date from sakila.customer where active = 0;

-- Check if values are inserted to table
SELECT 
    *
FROM
    sakila.deleted_users;

-- In any case create backup table of customer table existing non-active users
CREATE TABLE deleted_customers AS SELECT * FROM
    customer
WHERE
    active = 0;

SELECT 
    *
FROM
    deleted_customers;

-- Delete non-active users from customer table
DELETE FROM sakila.customer 
WHERE
    active = 0;  -- we see that query doesnt work

-- Disable foreign key check to be able to delete records
SET FOREIGN_KEY_CHECKS=OFF;
DELETE FROM sakila.customer 
WHERE
    active = 0; -- Now deleting successfully executed

-- Check that non-active users are deleted
SELECT 
    COUNT(*)
FROM
    customer
WHERE
    active = 0;


