--1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) 
--as per the following criteria and sort them in descending order of category: 
--a. If the category is 2050, increase the price by 2000 
--b. If the category is 2051, increase the price by 500 
--c. If the category is 2052, increase the price by 600. 
--Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]

SELECT product.PRODUCT_CLASS_CODE ,product.PRODUCT_ID,product.PRODUCT_DESC , product.PRODUCT_PRICE AS UPDATED_PRICE ,

CASE WHEN product.PRODUCT_CLASS_CODE = 2050 
          THEN (product.PRODUCT_PRICE=product.PRODUCT_PRICE+2000) 
WHEN product.PRODUCT_CLASS_CODE=2051 
          THEN (product.PRODUCT_PRICE=product.PRODUCT_PRICE+500)
WHEN product.PRODUCT_CLASS_CODE=2052
          THEN (product.PRODUCT_PRICE=product.PRODUCT_PRICE+600)
ELSE
          product.PRODUCT_PRICE = product.PRODUCT_PRICE
END AS UPDATED_PRICE
FROM product
ORDER BY product.PRODUCT_CLASS_CODE DESC



--2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail )
--and Show inventory status of products as below as per their available quantity: 
--a. For Electronics and Computer categories, if available 
--quantity is <= 10, show 'Low stock', 
--11 <= qty <= 30, show 'In stock', 
-->= 31, show 'Enough stock' 
--b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' 
--c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. Hint: Use case statement. (60 ROWS) 
--[NOTE: TABLES TO BE USED – product, product_class]

SELECT product_class.PRODUCT_CLASS_DESC,
product.PRODUCT_ID,
product.PRODUCT_DESC,
product.PRODUCT_QUANTITY_AVAIL ,
CASE 
WHEN
product_class.PRODUCT_CLASS_DESC = 'ELECTRONICS' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' 
AND product.PRODUCT_QUANTITY_AVAIL <= 10 THEN 'LOW STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Electronics' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' 
AND product.PRODUCT_QUANTITY_AVAIL >= 11 AND product.PRODUCT_QUANTITY_AVAIL <= 30 THEN 'IN STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Electronics' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' AND product.PRODUCT_QUANTITY_AVAIL >= 30 THEN 'ENOUGH STOCK'

WHEN
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR
product_class.PRODUCT_CLASS_DESC = 'Cloths' 
AND product.PRODUCT_QUANTITY_AVAIL <= 20 THEN 'LOW STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR
product_class.PRODUCT_CLASS_DESC = 'Cloths' 
AND product.PRODUCT_QUANTITY_AVAIL >= 21 AND product.PRODUCT_QUANTITY_AVAIL <= 80 THEN 'IN STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR
product_class.PRODUCT_CLASS_DESC = 'Cloths' AND product.PRODUCT_QUANTITY_AVAIL >= 81 THEN 'ENOUGH STOCK'

WHEN
product_class.PRODUCT_CLASS_DESC = 'Electronics' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' OR 
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR 
product_class.PRODUCT_CLASS_DESC = 'Cloths' 
AND product.PRODUCT_QUANTITY_AVAIL <= 15 THEN 'LOW STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Electronics' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' OR 
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR 
product_class.PRODUCT_CLASS_DESC = 'Cloths' 
AND product.PRODUCT_QUANTITY_AVAIL >= 16 AND product.PRODUCT_QUANTITY_AVAIL <= 50 THEN 'IN STOCK'
WHEN
product_class.PRODUCT_CLASS_DESC = 'Electronics' OR
product_class.PRODUCT_CLASS_DESC = 'Computer' OR 
product_class.PRODUCT_CLASS_DESC = 'Stationery' OR 
product_class.PRODUCT_CLASS_DESC = 'Cloths' 
AND product.PRODUCT_QUANTITY_AVAIL >= 51 THEN 'ENOUGH STOCK'
ELSE 'OUT OF STOCK NOT AVAILABLE'
END AS UPDATED_STOCK 
FROM product 
NATURAL JOIN product_class ON product_class.PRODUCT_CLASS_CODE = product.PRODUCT_CLASS_CODE
 
 

--3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more than 1 city, 
--in the descending order of CITIES. (2 rows) [NOTE: ADDRESS TABLE, Do not use Distinct]

SELECT COUNT(address.CITY), address.COUNTRY FROM address 
WHERE address.COUNTRY NOT IN ('Malaysia','USA')
GROUP BY address.COUNTRY 
HAVING COUNT(address.CITY) > 1

--to show all country cities using group 
SELECT COUNT(address.CITY), address.COUNTRY FROM address GROUP BY address.COUNTRY


--4. Write a query to display the customer_id,customer name, email and order details 
--(order id, product desc,product qty, subtotal(product_quantity * product_price)) for 
--all customers even if they have not ordered any item.(225 ROWS) 
--[NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]

SELECT online_customer.CUSTOMER_ID, 
       online_customer.CUSTOMER_FNAME,
       online_customer.CUSTOMER_EMAIL,
       order_items.ORDER_ID,
	   order_items.PRODUCT_QUANTITY ,
       product.PRODUCT_DESC,
       order_items.PRODUCT_QUANTITY*product.PRODUCT_PRICE) AS SUB_TOTAL 
FROM online_customer 
LEFT JOIN 
 order_header ON online_customer.CUSTOMER_ID = order_header.CUSTOMER_ID 
LEFT JOIN
 order_items ON order_header.ORDER_ID = order_items.ORDER_ID
LEFT JOIN 
 product ON order_items.PRODUCT_ID = product.PRODUCT_ID