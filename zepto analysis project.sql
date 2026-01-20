create database zepto_data;
 alter table zepto 
 add column id int auto_increment primary key;
 
 
--DATA EXPLORATION


--ENTIRE TABLE IMPORTED 
select * from zepto;

--COUNT OF ROWS IMPORTED
select count(*) from zepto;

--SAMPLE DATA
select * from zepto limit 10;

--CHECK FOR NULL VALUES IN EVERY ROW OF THE TABLE 
select * from zepto where 
Category is null or 
name is null or 
mrp is null or 
discountPercent is null or 
availableQuantity is null or 
discountedSellingPrice is null or 
weightinGms is null or 
outofstock is null or 
quantity is null;

--DISTINCT PRODUCT CATEGORIES IN THE TABLE 
select distinct category from zepto;

--CHECK COUNT OF PRODUCT WHICH ARE OUT OF STOCK AND WHICH ARE NOT 
select outofstock,count(id) from zepto group by outofstock;

--CHECK WHICH PRODUCT NAME ARE PRESENT MULTIPLE TIME IN THE DATASET 
select name,count(id) from zepto group by name having count(id)>1 order by count(id) desc;


--DATA CLEANING


--CHECK FOR ANY PRODUCT WHERE PRODUCT PRICE IS SET TO 0
select id,name,mrp,discountedsellingprice from zepto where mrp=0 or discountedsellingprice=0;

--DELETE THIS ROW WITH PRICE=0 OR DISCOUNTEDSELLINGPRICE=0
delete from zepto
where id=3517;

--CONVERT MRP AND DISCOUNTEDSELLING PRICE FROM PAISA TO RUPEE
update zepto 
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0
where id is not null;


--BUSINESS ANALYSIS


--TOP 10 BEST VALUE PRODUCT BASED ON THE DISCOUNT PERCENTANGE
select distinct name,discountpercent from zepto order by discountpercent desc limit 10;

--PRODUCTS WITH HIGH MRP BUT OUT OF STOCK 
select distinct name,mrp from zepto where outofstock='TRUE' order by mrp desc;

--REVENUE FOR EACH CATEGORY
select category,sum(discountedsellingprice*availablequantity) as total_revenue from zepto group by category order by total_revenue desc;

--SELECT CATEGORY WHERE MRP IS GREATER THAN 500 AND DISCOUNT IS LESS THAN 10%
select category from zepto where mrp>500 and discountpercent<10 group by category;

--TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE
select category,round(avg(discountpercent),2) as average_discount from zepto group by category order by average_discount desc limit 5;

--PRICE PER GRAM FOR PRODUCT ABOVE 100GM AND SORT BY BEST VALUE
select name,(discountedsellingprice/weightingms) as price_per_gram from zepto where weightingms>100 order by price_per_gram asc;

--GROUP THE PRODUCT INTO CATEGORY LIKE LOW,MEDIUM,BULK
select distinct name,weightingms,
case when weightingms<1000 then 'low'
     when weightingms<5000 then 'medium'
     else 'bulk'
     end as weight_category
from zepto;

--TOTAL INVENTORY WEIGHT PER CATEGORY
select category,sum(weightingms*availablequantity) as total_weight from zepto group by category;

