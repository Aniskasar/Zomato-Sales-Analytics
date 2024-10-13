create database Orders_casestudy;

# 1.	Create the Salespeople table
CREATE TABLE 
salespeople 
(
    snum INTEGER PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50),
    comm DECIMAL(10, 2)
);
INSERT INTO salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New York', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);

select * from salespeople;

# 2. Create the Cust Table  
CREATE TABLE 
cust 
(
    cnum INTEGER PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50),
    rating INTEGER,
    snum INTEGER,
    FOREIGN KEY (snum) REFERENCES salespeople(snum)
);
INSERT INTO cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007);
select *from cust;

#3. Create orders table 
CREATE TABLE 
orders 
(
    onum INTEGER PRIMARY KEY,
    amt DECIMAL(10, 2),
    odate DATE,
    cnum INTEGER,
    snum INTEGER,
    FOREIGN KEY (cnum) REFERENCES cust(cnum),
    FOREIGN KEY (snum) REFERENCES salespeople(snum)
);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);
select * from orders;

# 4. Query to match the salespeople to the customers according to the city they are living
SELECT 
salespeople.sname as Salespeople, 
cust.cname Customers, 
salespeople.city
FROM salespeople
INNER JOIN cust ON salespeople.city = cust.city
WHERE salespeople.snum = cust.snum;

# 5. Write a query to select the names of customers and the salespersons who are providing service to them
SELECT 
cust.cname AS Customers, 
salespeople.sname AS Salesperson
FROM cust
INNER JOIN salespeople ON cust.snum = salespeople.snum;

# 6. Write a query to find out all orders by customers not located in the same cities as that of their salespeople
SELECT 
o.onum as OrderNum,
o.amt as Amount,
o.odate as OrderDate,
c.cname as Customers,
s.sname as Salesperson,
c.city AS customer_city,
s.city AS salesperson_city
FROM orders o
INNER JOIN cust c ON o.cnum = c.cnum
INNER JOIN salespeople s ON o.snum = s.snum
WHERE c.city <> s.city;

# 7. Write a query that lists each order number followed by name of customer who made that order
SELECT 
o.onum as OrederNum,
c.cname as CustomerName
FROM orders o
INNER JOIN cust c ON o.cnum = c.cnum;

# 8. Write a query that finds all pairs of customers having the same rating
SELECT 
CONCAT(c1.cname, ' & ', c2.cname) AS CustomerName,
c1.rating
FROM cust c1
INNER JOIN cust c2 ON c1.rating = c2.rating
WHERE c1.cnum < c2.cnum;

# 9. Write a query to find out all pairs of customers served by a single salesperson
SELECT 
CONCAT(c1.cname, ' & ', c2.cname) AS CustomerName,
s.sname AS SalespersonName
FROM cust c1
INNER JOIN cust c2 ON c1.snum = c2.snum AND c1.cnum < c2.cnum
INNER JOIN salespeople s ON c1.snum = s.snum;

# 10. Write a query that produces all pairs of salespeople who are living in same city
SELECT
CONCAT(s1.sname, ' & ', s2.sname) AS SalespersonNames,
s1.city AS City
FROM salespeople s1
INNER JOIN salespeople s2 ON s1.city = s2.city AND s1.snum < s2.snum;

# 11. Write a Query to find all orders credited to the same salesperson who services Customer 2008
SELECT 
o.onum AS ordernumber,
o.amt as Amount,
o.odate AS orderdate,
s.sname AS salespersonname
FROM orders o
INNER JOIN cust c ON o.cnum = c.cnum
INNER JOIN salespeople s ON o.snum = s.snum
WHERE o.snum = (SELECT snum FROM cust WHERE cnum = 2008);

# 12. Write a Query to find out all orders that are greater than the average for Oct 4th
SELECT *
FROM orders
WHERE amt > (SELECT AVG(amt) FROM orders WHERE odate = '1994-10-04');

# 13. Write a Query to find all orders attributed to salespeople in London.
SELECT o.*
FROM orders o
LEFT JOIN salespeople s ON o.snum = s.snum
WHERE s.city = 'London';

# 14. Write a query to find all the customers whose cnum is 1000 above the snum of Serres
SELECT 
cname as Customers
FROM cust
WHERE cnum > (SELECT snum + 1000 FROM salespeople WHERE sname = 'Serres');

# 15. Write a query to count customers with ratings above San Jose’s average rating
SELECT 
COUNT(*) AS CustomerCount
FROM cust
WHERE rating > (SELECT AVG(rating) FROM cust WHERE city = 'San Jose')
AND city <> 'San Jose';
  
# 16. Write a query to show each salesperson with multiple customers
SELECT 
s.sname AS Salesperson
FROM salespeople s
INNER JOIN cust c ON s.snum = c.snum
GROUP BY s.sname
HAVING COUNT(c.cnum) > 1;





















