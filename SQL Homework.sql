--SQL Lab
--
--Setting up Postgres Chinook
--In this section you will begin the process of working with the Oracle Chinook database
--Task  Open the Chinook_PostgreSql.sql file and execute the scripts within.
-- SUCCESS!!!


--2.0 SQL Queries
--In this section you will be performing various queries against the Postgres Chinook database.
--2.1 SELECT
--Task  Select all records from the Employee table.
select * from employee;

--Task  Select all records from the Employee table where last name is King.
select * from employee where lastname = 'King'; 
--Task  Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
select * from employee where firstname = 'Andrew' and reportsto is null;
--2.2 ORDER BY
--Task  Select all albums in Album table and sort result set in descending order by title.
select * from album order by title desc;
--Task  Select first name from Customer and sort result set in ascending order by city
select firstname from customer order by city asc;
--2.3 INSERT INTO
--Task  Insert two new records into Genre table
INSERT INTO genre (genreid, name)
VALUES (26, 'Trance');
INSERT INTO genre (genreid, name)
VALUES (27, 'Hardstyle');
select * from genre;
--Task  Insert two new records into Employee table
INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email )
VALUES (9, 'lastname1', 'firstname1', 'title1', 1, null, null, null, null, null, null, null, null, null, 'buh1@guh.luh' );
INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email )
VALUES (10, 'lastname2', 'firstname2', 'title2', 2, null, null, null, null, null, null, null, null, null, 'buh2@guh.luh' );
select * from employee;
--Task  Insert two new records into Customer table
INSERT INTO customer (customerid, lastname, firstname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid )
VALUES (70, 'lastname1', 'firstname1', 'title1', null, null, null, null, null, null, null,  'buh3@guh.luh', 1 );
select * from customer;
--2.4 UPDATE
--Task  Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Robert', lastname = 'Walter'
WHERE firstname = 'Aaron' and lastname = 'Mitchell';
--Task  Update name of artist in the Artist table Å“Creedence Clearwater Revivalï¿½ to Å“CCRï¿½
UPDATE artist
SET name = 'CRR'
WHERE name = 'Creedence Clearwater Revival';
--2.5 LIKE
--Task  Select all invoices with a billing address like Å“T%ï¿½
SELECT * FROM invoice WHERE billingaddress LIKE 'T%';

--2.6 BETWEEN
--Task  Select all invoices that have a total between 15 and 50
SELECT * FROM invoice WHERE total BETWEEN 15 AND 50;
--Task  Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee WHERE hiredate BETWEEN '2003-06-1' AND '2004-03-1';
--2.7 DELETE
--Task  Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
create view relevantCustomerID as select customerid from customer WHERE firstname = 'Robert' and lastname = 'Walter';
DELETE FROM invoiceline WHERE invoiceid in (select invoiceid from invoice where customerid = (select customerid from relevantCustomerID));
DELETE FROM invoice WHERE customerid = (select customerid from relevantCustomerID);
DELETE FROM customer WHERE customerid = (select customerid from relevantCustomerID);
select * from customer;
--SQL Functions
--In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
--3.1 System Defined Functions
--Task  Create a function that returns the current time.
CREATE FUNCTION getTime() RETURNS timestamptz AS $$
    SELECT now() AS result;
$$ LANGUAGE SQL;
select * from gettime();
--Task  create a function that returns the length of a mediatype from the mediatype table
CREATE FUNCTION getMediaTypeLength() RETURNS bigint AS $$
   	select COUNT(name) FROM mediatype;
$$ LANGUAGE SQL;
select * from getMediaTypeLength();
--3.2 System Defined Aggregate Functions
--Task  Create a function that returns the average total of all invoices
CREATE FUNCTION getInvoiceTotalAverages() RETURNS numeric AS $$
   	select sum(total)/COUNT(total) FROM invoice;
$$ LANGUAGE SQL;
select total from invoice ;
select * from getInvoiceTotalAverages();

--Task  Create a function that returns the most expensive track
CREATE FUNCTION getMostExpensiveTracks() RETURNS setof track AS $$
   select * from track where unitprice = (SELECT MAX(unitprice) FROM track);
$$ LANGUAGE SQL;
select * from getMostExpensiveTracks();
--3.3 User Defined Scalar Functions
--Task  Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE FUNCTION getInvoiceLineAverages() RETURNS numeric AS $$
   	select sum(unitprice)/COUNT(unitprice) FROM invoiceline;
$$ LANGUAGE SQL;
select * from getInvoiceLineAverages();
--3.4 User Defined Table Valued Functions
--Task  Create a function that returns all employees who are born after 1968.
CREATE FUNCTION getOlderThan1968() RETURNS setof employee AS $$
   select * from employee where birthdate > '1968-12-31';
$$ LANGUAGE SQL;
select * from getOlderThan1968();

--4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
--4.1 Basic Stored Procedure
--Task  Create a stored procedure that selects the first and last names of all the employees.

create or replace FUNCTION selectEmployeeFirstLast() 
returns TABLE(firstname text, lastname text) AS $$
SELECT firstname, lastname FROM employee;
$$ LANGUAGE SQL;

select * from selectEmployeeFirstLast();
--4.2 Stored Procedure Input Parameters
--Task  Create a stored procedure that updates the personal information of an employee.
create or replace FUNCTION updatesEmployee(int, text, text, text, int, timestamp, timestamp, text, text, text, text, text, text, text, text)
returns void AS $$
UPDATE employee
SET employeeid = $1, lastname = $2, firstname = $3, title = $4, reportsto = $5, birthdate = $6, hiredate = $7, address = $8, city = $9, state = $10, country = $11, postalcode = $12, phone = $13, fax = $14, email = $15
WHERE employee.employeeid = $1;
$$ LANGUAGE SQL;
select * from updatesEmployee(9, 'lastboogersname1', 'firstname1', 'title1', 1, null, null, null, null, null, null, null, null, null, 'buh1@guh.luh' );
select * from employee;
--Task  Create a stored procedure that returns the managers of an employee.
create or replace FUNCTION selectEmployeeManagers() returns text as $$
select 'there are no managers in db'
$$ language sql;
select * from selectEmployeeManagers() as error;

--4.3 Stored Procedure Output Parameters
--Task  Create a stored procedure that returns the name and company of a customer.
create or replace FUNCTION selectCustomerFirstLastCompany() 
returns TABLE(firstname text, lastname text, company text) AS $$
SELECT firstname, lastname, company FROM customer;
$$ LANGUAGE SQL;
select * from selectCustomerFirstLastCompany();
--5.0 Transactions
--In this section you will be working with transactions. Transactions are usually nested within a stored procedure.
--Task  Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
create or replace FUNCTION deleteInvoice(numeric) returns void AS $$
	begin;
		-- delete the invoiceline where id matches
		DELETE FROM invoiceline WHERE invoiceline.invoiceid = $1;
		--delete invoice
		DELETE FROM invoice WHERE invoice.invoiceid = $1;
	commit;
$$ LANGUAGE SQL;
--Task  Create a transaction nested within a stored procedure that inserts a new record in the Customer table
create or replace FUNCTION insertCustomer(int, text, text, text, text, text, text, text, text, text, text, text, int)
returns void AS $$
begin;
	INSERT INTO customer (customerid, lastname, firstname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid )
	values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) ;
commit;
$$ LANGUAGE SQL;
--6.0 Triggers
--In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
--6.1 AFTER/FOR
--Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
create or replace function myTrigger()
returns trigger as $$
	begin
		Update customer
		set firstname = 'success'
		Where customerid = 602;
	return null;
	end;
$$ language plpgsql;

create trigger afteremployeeinsert
	after insert on employee
	for each row
    execute procedure myTrigger();
--Task  Create an after update trigger on the album table that fires after a row is inserted in the table

create trigger afterAlbumUpdate
	after update on album
	for each row
    execute procedure myTrigger();
--Task  Create an after delete trigger on the customer table that fires after a row is deleted from the table.
create trigger afterCustomerDelete
	after delete on customer
	for each row
    execute procedure myTrigger();

--7.0 JOINS
--In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
--7.1 INNER
--Task  Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
select 
	customer.firstname as "First Name", 
	customer.lastname as "Last Name", 
	invoice.invoiceid as "Invoice ID"
from 
	customer inner join invoice 
on 
	customer.customerid = invoice.customerid
order by
	invoice.invoiceid;
--7.2 OUTER
--Task  Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
select 
	customer.customerid as "CustomerId",
	customer.firstname as "First Name", 
	customer.lastname as "Last Name", 
	invoice.invoiceid as "Invoice ID",
	invoice.total as "Total"
from 
	customer full join invoice 
on 
	customer.customerid = invoice.customerid
order by
	invoice.total;
--7.3 RIGHT
--Task  Create a right join that joins album and artist specifying artist name and title.
select 
	artist."name" as "Artist Name",
	album.title as "Title"
from 
	artist right join album 
on 
	artist.artistid = album.artistid
order by
	artist."name";
--7.4 CROSS
--Task  Create a cross join that joins album and artist and sorts by artist name in ascending order.
select 
	*
from 
	artist cross join album 
order by
	artist."name" asc;
--7.5 SELF
--Task  Perform a self-join on the employee table, joining on the reportsto column.
select 
	employee.firstname,
	employee.lastname,
	other.firstname as ManagerName,
	other.lastname as ManagerSurname
from 
	employee join employee as other 
on 
	employee.reportsto = other.employeeid;
