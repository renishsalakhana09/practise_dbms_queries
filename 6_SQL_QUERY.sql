--1. Write a query to display the customer_id,customer full name ,city,pincode,
--and order details (order id,order date, product class desc, product desc, 
--subtotal(product_quantity * product_price)) for orders shipped to cities 
--whose pin codes do not have any 0s in them. Sort the output on customer name, 
--order date and subtotal. (52 ROWS) [NOTE: TABLE TO BE USED - online_customer, 
--address, order_header, order_items, product, product_class]


SELECT CUSTOMER_ID , 
CONCAT(CUSTOMER_FNAME," ",CUSTOMER_LNAME) AS FULL_NAME , 
A.CITY , A.PINCODE , OI.ORDER_ID, O.ORDER_DATE , 
PC.PRODUCT_CLASS_DESC , P.PRODUCT_DESC , 
(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS SUBTOTAL 
FROM online_customer AS C 
NATURAL JOIN address AS A 
NATURAL JOIN order_header AS O 
NATURAL JOIN order_items AS OI 
NATURAL JOIN product AS P 
NATURAL JOIN product_class AS PC 
WHERE A.PINCODE NOT LIKE "%0%" AND order_status='shipped' 
ORDER BY CONCAT(C.CUSTOMER_FNAME) , O.ORDER_DATE , SUBTOTAL ;




--#2
--Write a Query to display product id,product description,totalquantity(sum(product quantity) 
--for a given item whose product id is 201 and which item has been bought along with it maximum no. of times. 
--(USE SUB-QUERY) (1 ROW) [NOTE: ORDER_ITEMS TABLE, PRODUCT TABLE]

SELECT DISTINCT OI1.PRODUCT_ID,COUNT(*) AS COUNT, PRODUCT_DESC
FROM order_items OI1
JOIN product USING (PRODUCT_ID)
WHERE (ORDER_ID) IN (SELECT ORDER_ID
FROM order_items OI2
WHERE OI2.PRODUCT_ID = 201)
GROUP BY OI1.PRODUCT_ID
ORDER BY COUNT DESC
LIMIT 2

--#3
--Write a query to display carton id, (len*width*height) as carton_vol and identify the 
--optimum carton (carton with the least volume whose volume is greater than the total volume 
--of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, 
--Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]

SELECT carton.CARTON_ID,
MIN(carton.LEN*carton.WIDTH*carton.HEIGHT) AS CARTON_VOL
FROM carton
WHERE (carton.LEN*carton.WIDTH*carton.HEIGHT) >
(SELECT SUM(product.LEN*product.WIDTH*product.HEIGHT) FROM product NATURAL JOIN order_items
WHERE
order_items.ORDER_ID=10006) 
;


--#4
--Write a query to display details (customer id,customer fullname,order id,product quantity)
-- of customers who bought more than ten (i.e. total order qty) products per shipped order. 
--(11 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]


SELECT online_customer.CUSTOMER_ID , order_items.ORDER_ID, 
CONCAT(online_customer.CUSTOMER_FNAME,online_customer.CUSTOMER_LNAME) AS FULL_NAME ,
SUM(order_items.PRODUCT_QUANTITY) AS TOTAL_QUANTITY 
FROM order_items 
INNER JOIN order_header ON order_items.ORDER_ID = order_header.ORDER_ID 
INNER JOIN online_customer ON order_header.CUSTOMER_ID = online_customer.CUSTOMER_ID 
WHERE order_header.ORDER_STATUS = 'SHIPPED' 
GROUP BY (order_items.ORDER_ID)
HAVING SUM(order_items.PRODUCT_QUANTITY) > 10
;

--#5
--Write a query to display the order_id, customer id and cutomer full name of customers 
--along with (product_quantity) as total quantity of products shipped for order ids > 10060. 
--(6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items]

SELECT order_header.ORDER_ID , online_customer.CUSTOMER_ID , CONCAT(online_customer.CUSTOMER_FNAME, online_customer.CUSTOMER_LNAME) AS FULL_NAME,
SUM(order_items.PRODUCT_QUANTITY) AS TOTAL_QUANTITY 
FROM 
online_customer INNER JOIN order_header ON online_customer.CUSTOMER_ID = order_header.CUSTOMER_ID 
INNER JOIN order_items ON
order_header.ORDER_ID = order_items.ORDER_ID 
WHERE 
order_header.ORDER_STATUS="Shipped" AND 
order_header.ORDER_ID > 10060 
GROUP BY (order_items.ORDER_ID) 
;
--OR
SELECT order_header.ORDER_ID , online_customer.CUSTOMER_ID , CONCAT(online_customer.CUSTOMER_FNAME, online_customer.CUSTOMER_LNAME) AS FULL_NAME,
SUM(order_items.PRODUCT_QUANTITY) AS TOTAL_QUANTITY 
FROM 
online_customer INNER JOIN order_header USING(CUSTOMER_ID) 
INNER JOIN order_items USING(ORDER_ID)
WHERE 
order_header.ORDER_STATUS="Shipped" AND 
order_header.ORDER_ID > 10060 
GROUP BY (order_items.ORDER_ID) 
;

--#6
-- Write a query to display country, product class description ,total quantity (sum(product_quantity),
--Total value (product_quantity * product price) and 
--show which class of products have been shipped highest(Quantity) 
--to countries outside India other than USA? Also show the total value of those items. (1 ROWS)
--[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

SELECT address.COUNTRY,product_class.PRODUCT_CLASS_DESC ,SUM(order_items.PRODUCT_QUANTITY) AS TOTAL_QUANTITY,
(order_items.PRODUCT_QUANTITY*product.PRODUCT_PRICE) AS TOTAL_VALUE
FROM
address
INNER JOIN online_customer
ON address.ADDRESS_ID = online_customer.ADDRESS_ID
INNER JOIN order_header
ON online_customer.CUSTOMER_ID = order_header.CUSTOMER_ID
INNER JOIN order_items
ON order_header.ORDER_ID = order_items.ORDER_ID
INNER JOIN product
ON order_items.PRODUCT_ID = product.PRODUCT_ID
INNER JOIN product_class
ON product.PRODUCT_CLASS_CODE = product_class.PRODUCT_CLASS_CODE
WHERE
order_header.ORDER_STATUS ='Shipped'
AND
address.COUNTRY NOT IN('INDIA','USA')
GROUP BY online_customer.CUSTOMER_ID,order_header.ORDER_STATUS
HAVING MAX(order_items.PRODUCT_QUANTITY)
ORDER BY TOTAL_QUANTITY DESC
LIMIT 1
;
SELECT COUNTRY, PRODUCT_CLASS_DESC, SUM(PRODUCT_QUANTITY) AS TOTAL_QUANTITY, (PRODUCT_QUANTITY*PRODUCT_PRICE) AS TOTAL_VALUE
FROM address
JOIN online_customer USING (ADDRESS_ID)
JOIN order_header USING (CUSTOMER_ID)
JOIN order_items USING (ORDER_ID)
 JOIN product USING (PRODUCT_ID)
JOIN product_class USING (PRODUCT_CLASS_CODE)
WHERE ORDER_STATUS = 'Shipped'
AND COUNTRY NOT IN ('India','USA')
GROUP BY COUNTRY , PRODUCT_CLASS_DESC
HAVING MAX(PRODUCT_QUANTITY)
ORDER BY TOTAL_QUANTITY DESC
LIMIT 1


------additional query for checking vlalues
SELECT * FROM order_header INNER JOIN order_items ON order_header.ORDER_ID = order_items.ORDER_ID
			WHERE order_items.PRODUCT_ID = 201
