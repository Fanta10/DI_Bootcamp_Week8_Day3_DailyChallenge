-- Database: day3Daily

-- DROP DATABASE IF EXISTS "day3Daily";

CREATE DATABASE "day3Daily"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'French_France.1252'
    LC_CTYPE = 'French_France.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- 	create customer table
CREATE TABLE customer(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100) NOT NULL
);
INSERT INTO customer(first_name, last_name)
VALUES('John', 'Doe'),
	   ('Jerome', 'Lalu'),
	   ('Lea','Rive');
	   
-- 	   create table customer profile
CREATE TABLE customer_profile(
	id SERIAL PRIMARY KEY,
	isLoggedIn BOOLEAN DEFAULT false,
	customer_id INTEGER REFERENCES customer(id)
);

INSERT INTO customer_profile(isLoggedIn, customer_id)
VALUES(true, (SELECT id FROM customer WHERE id = 1)),
	   (false, (SELECT id FROM customer WHERE id = 2));
	   
	 QUIZ 4.1  Le first_name des clients LoggedIn
SELECT C.last_name FROM customer C INNER JOIN customer_profile CP
ON C.id = CP.customer_id WHERE isLoggedIn = true;

QUIZ 4.2 Tous les clients first_name et isLoggedIn colonnes - même les
clients qui n’ont pas de profil
SELECT C.first_name, P.isLoggedIn FROM customer C LEFT JOIN customer_profile AS P
ON C.id = P.customer_id;

QUIZ 4.3 Le nombre de clients qui ne sont pas connectés
SELECT COUNT(*) FROM customer AS C INNER JOIN customer_profile AS p
ON C.id = p.customer_id GROUP BY p.isLoggedIn HAVING p.isLoggedIn = false;						  

-- create table Book
CREATE TABLE Book(
	 book_id SERIAL PRIMARY KEY,
	 title 	VARCHAR(100) NOT NULL,
	author VARCHAR(100) NOT NULL
);
INSERT INTO Book(title, author)
VALUES('Alice In Wonderland', 'Lewis Carroll'),
	   ('Harry Potter', 'J.K Rowling'),
	   ('To kill a mockingbird',' Harper Lee');

-- create Student table
CREATE TABLE Student(
	 student_id SERIAL PRIMARY KEY,
	 name VARCHAR(100) NOT NULL UNIQUE,
	age NUMERIC(20) CHECK(age <= 15)
);

INSERT INTO Student(name, age)
VALUES('Jean', 12),
	   ('Lera', 11),
	   ('Patrick', 10),
	   ('Bob', 14);
	   
CREATE TABLE Library(
	book_fk_id INTEGER REFERENCES book (book_id) ON DELETE CASCADE ON UPDATE CASCADE,
	student_id INTEGER REFERENCES student (student_id) ON DELETE CASCADE ON UPDATE CASCADE,
	borrowed_date DATE
	
);
INSERT INTO library (book_fk_id, student_id,borrowed_date)
	VALUES (1, 1, '15/02/2022'),
		   (1, 4, '03/03/2021'),
		   (1, 3, '23/05/2021'),
		   (2, 4, '12/08/2021');
	
	SELECT * FROM library L 
	INNER JOIN book B ON L.book_fk_id = B.book_id
	INNER JOIN student USING(student_id);
	
	SELECT S.name, B.title FROM library L 
	INNER JOIN book B ON L.book_fk_id = B.book_id
	INNER JOIN student S USING(student_id);
	
	SELECT AVG(S.age) FROM library L 
	INNER JOIN book B ON L.book_fk_id = B.book_id
	INNER JOIN student S USING(student_id);
	
	DELETE FROM student
	WHERE student_id = 2;