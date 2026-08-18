create database amazon;
use amazon;
-- task 3
select * from amazon.customers order by city;
select * from amazon.products where Category = 'fruits';

-- task 5--
insert into amazon.products(productID,ProductName,Category,Subcategory,PricePerUnit,StockQuantity,supplierID)
values('94224DHL-U795-87P2-75ed,526jj96ab9h7b','We Baker','baco','Sub-baco-4',787,300,'0656c953-95c4-4d88-bf30-4fbfe4dda4cd');
insert into amazon.products(productID,ProductName,Category,Subcategory,PricePerUnit,StockQuantity,supplierID)
values('9224DFH-E987-98P5-64fd,546jh97ab5h6b','word fruit ','baca','sub-baco-4',758,400,'0856c785-95c8-4b88-bf32-4fbfe4dda4cd');
insert into amazon.products(productID,ProductName,Category,Subcategory,PricePerUnit,StockQuantity,supplierID)
values('9524DFH-E687-92P5-63fv,586jh87ab5h6b','room snack ','bacy','sub-bacy-4',750,500,'0756c785-95c8-4b88-bf32-4fbfe4dda4cd');

-- task 6
update amazon.products set stockquantity=400
where productid='9224DFH-E987-98P5-64fd,546jh97ab5h6b';
select * from amazon.products;

-- task 7--
delete from amazon.suppliers 
where supplierid ='03ec3130-f542-432e-b173-f110efd69026';
select * from amazon.suppliers;

-- task 8--
ALTER TABLE amazon.reviews
ADD CONSTRAINT check_rating
CHECK (Rating >= 1 AND Rating <= 5);
alter table amazon.customers add df_primemember varchar(10) default 'NO';
select * from amazon.reviews;

-- task 9--
-- where clause--
select * from amazon.orders where orderdate > '2024-01-01';

-- having clause--
select productid,avg(rating) as avgrating 
from amazon.reviews group by productid 
having avg(rating)>4;

-- group by and order by--

select productid,sum(stockquantity * priceperunit) as totalsales
from amazon.products
group by productid order by totalsales desc;

-- task 10 identifiying high value customers--
 alter table customers add total_spend decimal(10,2);
select * from amazon.customers;

-- 1.Calculate each customer's total spending -- 

select o.customerid,sum(od.quantity * p.priceperunit) as totalspending
from amazon.orders as o
join amazon.order_details as od on o.orderid = od.orderid
join amazon.products as p on od.productid = p.productid
group by o.customerid;

-- 11. Task: Aggregations and Joins

-- Join the Orders and OrderDetails tables to calculate total revenue per order

SELECT o.orderid,
       SUM(od.quantity * p.priceperunit) AS totalrevenue
FROM amazon.orders o
JOIN amazon.order_details od
ON o.orderid = od.orderid
JOIN amazon.products p
ON od.productid = p.productid
GROUP BY o.orderid;

-- Identify customer who placed the most orders in a specific time period

SELECT customerid,
       COUNT(orderid) AS totalorders
FROM amazon.orders
WHERE orderdate BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY customerid
ORDER BY totalorders DESC;

FIND THE SUPPLIERS WITH THE MOST PRODUCTS IN STOCK

SELECT supplierid,
       SUM(stockquantity) AS totalstock
FROM amazon.products
GROUP BY supplierid
ORDER BY totalstock DESC
LIMIT 1;

-- TASK 12
-- SEPARATE PRODUCT CATEGORIES AND SUBCATEGORIES INTO A NEW TABLE

CREATE TABLE categories (
    categoryid VARCHAR(100) PRIMARY KEY,
    category VARCHAR(100),
    subcategory VARCHAR(100)
);

INSERT INTO categories (categoryid, category, subcategory)
SELECT DISTINCT UUID(), category, subcategory
FROM amazon.products;

-- Create foreign keys to maintain relationships

ALTER TABLE amazon.products ADD categoryid VARCHAR(100);

SET SQL_SAFE_UPDATES = 0;

UPDATE amazon.products p
JOIN amazon.categories c ON p.category = c.category and p.subcategoy = c.subcategory
set p.categoryid = c.categoryid;

-- Task 13 --

SELECT ProductID, total_revenue
FROM (
    SELECT ProductID,
           SUM((UnitPrice * Quantity) - discount) AS total_revenue
    FROM amazon.order_details
    GROUP BY ProductID) AS revenue ORDER BY total_revenue DESC LIMIT 3;

SELECT CustomerID, name FROM amazon.customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM orders);

-- Task 14: Provide actionable insights

-- Which cities have the highest concentration of Prime members?

SELECT City,
       COUNT(*) AS PrimeMembers
FROM amazon.customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY PrimeMembers DESC;

-- What are the top 3 most frequently ordered categories?

SELECT p.category,
       COUNT(oi.ProductID) AS total_orders
FROM amazon.order_details AS oi
INNER JOIN Products p
ON oi.ProductID = p.ProductID
GROUP BY p.category
ORDER BY total_orders DESC LIMIT 3;

select * from amazon.suppliers;