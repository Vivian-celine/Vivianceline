--1
--Find duplicate order entries (same order_id + product_id + created at)
With duplicate_row as
(select order_id,product_id,created_at,
row_number() over (partition by order_id,product_id,created_at order by order_id)as row_num
from [order_2 (1)])

select *
from duplicate_row
where row_num > 1

select *
from product

select *
from [order_2 (1)]
--2
--Find the top 3 best best selling products by quantity for each day.
 With ranked_sales as
(
       Select 
             CONVERT(date,o.created_at) AS sales_date,P.name, Sum(O.quantity) AS Total_quantity,
             Rank() over (partition by convert(Date,O.created_at) order by Sum (o.quantity) desc) As ranks
       From [order_2 (1)] o
       Join product P On O.product_id = P.id
       Group by O.created_at, p.name
)
Select *
from ranked_sales
where ranks <= 3
order by sales_date asc


--3
--How many unique orders are placed each day
select cast(created_at As date) as date_only,
count (distinct order_id) as unique_orders
from
[order_2 (1)]
group by cast(created_at As date)


--4 What is the average order value per order id
select 
      order_id, Avg(total) AS Avg_order
from 
      [order_2 (1)]
group by order_id
order by AVG(total) desc


--5
--Which product generated the highest total revenue
select product_id,name,Sum_total,Ranks
from
      (select O.product_id,name,Sum(total) as Sum_total,
       rank() over(order by Sum(total)desc) as ranks
      from [order_2 (1)] O
      join
     product P on O.product_id = P.id
     group by O.product_id,name) as A
Where ranks = 1
order by Sum_total


--6
--Top 5 products that generated the highest total revenue
Select top 5 P.name,P.id,sum(total) revenue
from product P
Join [order_2 (1)] O
on P.id = O.product_id
group by P.name,p.id
order by revenue desc


--7
--What are the top 5 most frequently ordered product
select top 5 name,Count(O.product_id) total,
rank() over(order by COUNT(O.product_id)desc) as ranks
from [order_2 (1)] O
join product P on O.product_id = P.id
group by name

select top 5 p.name, count(*) AS total_orders
from [order_2 (1)] O
join product P ON O.product_id = P.id
Group by P.name
Order by total_orders desc

-- 8           
--What is the total number of items sold for each product
select P.name, 
Sum(O.quantity) as T_Q
from [order_2 (1)] O
join Product P on O.product_id = P.id
group by P.id,P.name
order by T_Q desc

--9
--Stored procedure to get total sales summary by product for a given date range
Create procedure totalsaless
@created_at Date,
@updated_at date
AS
Begin
     Select product_id,name,sum(total)total_sales
     from [order_2 (1)] O
     join
     product P on O.product_id = p.id
     where Cast(O.created_at as date) between @created_at and @updated_at
     group by product_id,name
End

Execute totalsaless @created_at = '2025-04-21', @updated_at = '2025-04-21'

--10
--Which product has never been ordered
select name,id
from product
where id in
           (select id
            from product
            except
            select product_id
            from [order_2 (1)])

--11
--What is the total number of distinct products ordered per order id
select order_id,product_id,
count( distinct product_id) as Dis_product
from [order_2 (1)]
group by order_id,product_id
order by Dis_product desc

select order_id,product_id
from [order_2 (1)]
where order_id = 52


--12
-- What is the average quantity ordered per product
select 
      product_id, Avg(quantity) AS Avg_order
from 
      [order_2 (1)]
group by product_id
order by AVG(quantity) desc


--13
-- list products with the lowest sales
Select P.id,p.name,Sum(total) sales
from product P
Join [order_2 (1)] O
on p.id = O.product_id
group by P.id,p.name
order by sales Asc 


--14
-- What is the total revenue generated over time monthly
Select sum(total) AS monthly_revenue ,CONVERT(varchar(7),created_at,120) as Year_month
from [order_2 (1)]
group by CONVERT(varchar(7),created_at,120) as Year_month
order by monthly_revenue desc


--15
-- Products with high revenue but low price
Select top 10 P.name,P.id,P.price,sum(total) revenue
from product P
Join [order_2 (1)] O
on P.id = O.product_id
group by P.name,p.id,p.price
order by P.price asc,revenue 


--16
-- What products are consistently purchased together






-- Which products were updated recently

--What are the recently created products
--Monthly revenue for the year 2022
--Total sales in the last 30 days
--When was the earliest and latestsales of each product