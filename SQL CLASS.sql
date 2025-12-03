select * 
from Orders

select Product_Name,Unit_Price
from Orders

use Superstores
select *
from Returns

select Customer_Name,Customer_ID,Sales
from Orders

select *
from Users

select SUM(sales)Sum_sales
from Orders

select AVG(profit)Avg_profit
from Orders

select Min(sales), MAX(sales)
from orders

-- alias (AS); used to name or rename a table or column

select SUM(sales) as Total_sales
from orders

select AVG(profit) average_profit
from Orders

select customer_name
from Orders

-- group by (used to group a table after aggregation based on a certain column and columns)

--Total sales per region
select region,SUM(sales) as total_sales
from Orders
group by Region

-- Avg quantity bought for each customer segment by ship mode
select Customer_segment,ship_mode, AVG(quantity_ordered_new) avg_quantity
from Orders
group by customer_segment, ship_mode

-- order by (arranges the output in ascending and descending order)

-- Avg quantity bought for each customer segment by ship mode
select Customer_segment,ship_mode, AVG(quantity_ordered_new) avg_quantity
from Orders
group by customer_segment, ship_mode
order by Customer_Segment

select Customer_segment,ship_mode, AVG(quantity_ordered_new) avg_quantity
from Orders
group by customer_segment, ship_mode
order by Customer_Segment,avg_quantity desc

select Customer_segment,ship_mode, AVG(quantity_ordered_new) avg_quantity
from Orders
group by customer_segment, ship_mode
order by avg_quantity asc

-- filtering (where and having) this is used to filter our output based on certain criteria
-- where filters already existing columns in a table

-- avg quantity bought for home office customers by ship mode
select Customer_segment,ship_mode, AVG(quantity_ordered_new) avg_quantity
from Orders
where Customer_Segment = 'HOME OFFICE'
group by customer_segment, ship_mode
ORDER BY Customer_Segment DESC

-- TOTAL PROFIT FROM EASTERN ORDERS
Select region, sum(profit) total_profit
from orders
where Region = 'East'
group by region


-- total profit  from each region where total profit is greater than 320,000
Select region, sum(profit) total_profit
from orders
group by Region
having sum(profit) > 320000
order by total_profit

-- Return a table that shows the technology products that went through express air which yielded  profits greater than 100
select order_id,Product_Category,Ship_Mode,Profit
from Orders
where Product_Category = 'technology' and Ship_Mode = 'Express air' and Profit > 100

-- Return atable of customers whose names begins with A
select customer_name 
from Orders
where customer_name like 'A%'

-- return a table of customers whose name begins and ends with A
select customer_name
from orders
where Customer_Name like 'A%A'

-- return a table of customers whose name contain A
select customer_name
from orders
where Customer_Name like '%A%'

-- Removing duplicate (distinct)
-- return a table of customers whose name begins and end with A
 select distinct customer_name
 from Orders
 where Customer_Name like '%A%'
 order by Customer_Name asc

-- joins (inner,full, right,left)
-- Inner join returns matching rows on both tables (join is automatically an inner join)
-- Full join returns every row in both tables 
-- Right join returns every row in the right table and matching rows in the left table
-- Left join returns every row in the left table and matching rows in the right table

-- table of orders that were returned and the sales amount
select *
from Returns
order by Order_ID

select *
from Orders
order by Order_ID

select Orders.Order_ID,sales,Status
from Orders inner join Returns
on Orders.Order_ID = Returns.Order_ID
order by Order_ID

-- table of orders whether returned or not and their sales amount 
select Orders.Order_ID,sales,Status
from Orders 
full join Returns
on Orders.Order_ID = Returns.Order_ID

-- table of orders,status and their sales amount
select Orders.Order_ID,Sales, status
from Orders left join Returns
on Orders.Order_ID = Returns.Order_ID

select Orders.Order_ID,Sales, status
from Returns right join orders
on Orders.Order_ID = Returns.Order_ID

select Orders.Order_ID,Sales, status
from Orders right join Returns
on Orders.Order_ID = Returns.Order_ID

-- show a table of managers and the total amount made from office supplies product
select orders.Order_ID,column2 manager,product_category, SUM(sales) total_sales
from Orders
join Users
on Orders.Region = Users.column1
where Product_Category = 'office supplies'
group by order_id,product_category,column2

-- union arranges in alphabetical order
-- note while using union the columns has to be equal in number and data type must be thesame
select column1
from Users
union
select column2
from Users

-- union all brings the two columns together without arranging alphabetically
select column1
from Users
union all
select column2
from Users

-- "Except" returns difference between two columns
select column1
from Users
except
select distinct Region
from Orders

-- intersect returns similarities between two columns
select column1
from Users
intersect
select distinct Region
from Orders

select *
from Users

-- case --
select Customer_Name,Ship_Mode,Sales,Profit,Quantity_ordered_new,
case
     when quantity_ordered_new < 50 then 'small'
     when quantity_ordered_new < 100 then 'medium'
     else 'bulk'
end as order_type
from Orders
order by quantity_ordered_new desc

-- string function (Concat,upper,lower,left,right,mid,trim[ltim,Rtrim)
select Customer_Name,Region,CONCAT(customer_name,'_',Region) as C_R
from Orders

select Customer_Name,Region,UPPER (CONCAT(customer_name,'_',Region)) as C_R
from Orders

select Customer_Name,Region, lower (CONCAT(customer_name,'_',Region)) as C_R
from Orders

select Customer_Name,Region, right (CONCAT(customer_name,'_',Region), 5) as C_R
from Orders

select Customer_Name,Region, left (CONCAT(customer_name,'_',Region), 5) as C_R
from Orders

-- partition by
-- return a table that shows the total returned orders per region alongside the customer names.

select customer_name,region,
COUNT(status) over (partition by region) as returned
from orders  O
join Returns R
On O.Order_ID = R.Order_ID

select customer_name,region,
COUNT(status) --over (partition by region) as returned
from orders  O
join Returns R
On O.Order_ID = R.Order_ID
group by Region,Customer_Name

-- Top N--

select top (10) customer_name,customer_id,sales,profit,product_name,
case
     when sales <= 1000 then 'low'
     else 'high'
end
as sales_remark,
case
     when profit <= 139 then 'low'
     else 'high'
end
as profit_remark
from orders
order by sales desc

-- Return the 5 most expensive orders based on shipping prices to california
select top (5) Order_ID,Customer_Name,state_or_Province,Ship_Date,Ship_Mode,Shipping_Cost 
from Orders
where State_or_Province = 'california'
order by Shipping_Cost desc

--Rank
-- return a ranked table of sales according to product category.
select Customer_Name,Product_Category,column2 as manager,Sales,
RANK() over (partition by product_category order by sales desc) saleswork
from Orders
     join Users
on Orders.Region = Users.column1

select Customer_Name,Product_Category,column2 as manager,Sales,
RANK() over (order by sales desc) salesrank
from Orders
     join Users
     on Orders.Region = Users.column1

-- subquery(nested query)
-- subquery is also known as a query inside a query these queries can be used at the FROM,WHERE,
-- SELECT clauses etc.in Sql the inner query is usually executed before the outer query. We can also implememnt
-- subqueries with the SELECT,INSERT,UPDATE AND DELETE statements along with operators
-- like IN,BETWEEN,=,<,>,<=,>= etc.

--subqueries (select)
-- Return a table of customer segment,sales and average sales
select Customer_Name,Customer_Segment,sales, (select avg (sales) from Orders) as avgsales
from Orders

select Customer_Name,Customer_Segment,sales, 
(select avg (sales) from Orders) as avgsales
from Orders
group by Customer_Name,Customer_Segment,sales

-- subquery
-- rank your product with the sales
select Product_Name,total_sales,sales_rank
from
     (select product_name,product_sub_category,sum(sales)total_sales ,
    rank() over (order by sum (sales) desc) as sales_rank
    from Orders
    group by product_name,product_sub_category) as A
order by sales_rank asc

-- return top 3 most profitable products in each product category
select product_name,product_category,profit, Ranks
from (select product_name,product_category,profit,
        rank() over(partition by product_category order by profit desc) as Ranks
        from Orders) as Q
where Ranks <= 3
order by Product_Category asc

-- or

select top (9) Product_Name,Product_Category,Profit,Ranks
from (select Product_Name,Product_Category,Profit,
Rank() over (partition by product_category order by profit desc) Ranks 
     from Orders) Q
     order by Ranks asc

-- common table expressions: CTE's contain commands like with, create, insert,delete,select,update,alter
-- cte's offers temporary results and improves readability alongside organisation of complex queries. cte's are
-- usually defined using the WITH keyword

With Q as 
(select product_name,product_category,profit,
  rank() over(partition by product_category order by profit desc) as Ranks
  from Orders)

 Select product_name,product_category,profit,ranks
 from Q
 where Ranks <= 3
order by Product_Category asc

-- Return the table of customers with returned goods whose total sales was above 5000 alongside manager
-- using WHERE for your filter. (cte)

With sales_table
As (
     Select Customer_Name, sum(sales) Total_sales,Region,Status,column2 as manager
            from orders
                 inner join Returns
                   on Orders.Order_ID = Returns.Order_ID
                      inner join Users
                         on Orders.Region = Users.column1
                            group by Customer_Name,Region,Status,column2)

select Customer_Name,Total_sales,manager, status
from sales_table
where Total_sales > 5000
order by Total_sales ASC

-- CREATE TABLE (temporary (#) and permanent)

-- Create a table for DA Students with their names, id and age.
 
 CREATE TABLE DA_Students (
 ID INT,
 Names varchar (50),
 Age int)

 select *
 from DA_Students

 -- INSERT INTO
 Insert into DA_Students 
 values ('5431', 'Youndy','35'),
        ('08763', 'Kingsley',''),
        ('90923', '','38'),
        ('', 'Homa','35'),
        ('', 'Tola','26'),
        ('12243', 'Edi','22')

 -- deleting from table (delete from t.n...... where t.n=)

 Delete from DA_Students
 where Names = 'Homa'

 select *
 from DA_Students

 -- update table ( Update T.N, SET C.N=, WHERE C.N)--

 UPDATE DA_Students
 SET Age = 27
 where ID = 08763

 select *
 from DA_Students

 UPDATE DA_Students
 SET ID = 2134
 Where age = 35
 and Names like 'Homa'

 UPDATE DA_Students
 SET ID = 5431
 Where age = 35
 and Names like 'Youndy'

 UPDATE DA_Students
 SET ID = 8822
 Where age = 26

 UPDATE DA_Students
 SET Names = 'Vivian'

UPDATE DA_Students
 SET date_of_resumption = '2025-10-01'
 Where ID = 90923

 UPDATE DA_Students
 SET date_of_resumption = '2025-10-06'
 Where ID = 5431

 UPDATE DA_Students
 SET date_of_resumption = '2025-10-05'
 Where ID = 8763

 UPDATE DA_Students
 SET date_of_resumption = '2025-10-03'
 Where ID = 2134

 UPDATE DA_Students
 SET date_of_resumption = '2025-10-02'
 Where ID = 8822

 UPDATE DA_Students
 SET date_of_resumption = '2025-10-04'
 Where ID = 12243

 alter table da_students
 drop column age 

 --Alter table (Add, drop)

 Alter table DA_students
 add date_of_resumption date;

 -- deleting duplicate rows from our dataset

  With duplicate_row as
 (select Names,ID,
 Row_number () over (partition by names, id order by names desc ) as row_num
 from DA_Students)

 --select names,id, row_num
 --from duplicate_row

delete from duplicate_row
where row_num > 1

--creating duplicate copy of your table
create table DA_STUDENT_COPPYS
(ID INT,
Names varchar (50),
Age int,
Date_of_resumption date)

insert into DA_STUDENT_COPPYS
SELECT * FROM DA_Students

select * from DA_STUDENT_COPPYS

-- stored procedure

Create procedure Customer_details
@order_id int
As
BEGIN
     SELECT Order_ID,Customer_ID,Customer_Name,Customer_Segment,Sales,Region,Ship_Mode,Profit
     from Orders
     where Order_ID = @order_id;
END;

EXECUTE Customer_details @order_id = 88523

EXECUTE Customer_details @order_id = 90676

Create procedure customer_names
@customer_name varchar (50)
AS
BEGIN
     SELECT Customer_ID,Customer_Name,Customer_Segment,SUM (SALES) TOTAL_SALES,Column2 as manager, sum (profit) t_p, Order_ID
     FROM Orders O
     join Users u
     on o.region = u.column1
     where Customer_Name = @customer_name
     group by Customer_ID,Customer_Name,Customer_Segment,column2,Order_ID
     Having sum (sales) > 1000;
END;

EXECUTE customer_names @CUSTOMER_NAME = 'Janice fletcher'

EXECUTE customer_names @CUSTOMER_NAME = 'Bonnie potter'
-- create a procedure with customer names so i can easily view customer details with total sales greater than 1000
-- alongside the manager and total profit

--commit

Begin transaction;
update DA_STUDENT_COPPYS
SET AGE = AGE + 50
WHERE ID = 0

update DA_STUDENT_COPPYS
SET AGE = AGE + 20
WHERE ID = 08786
COMMIT

SELECT * FROM DA_STUDENT_COPPYS

--ROLLBACK
update DA_STUDENT_COPPYS
SET NAMES = 'AKPAN'
WHERE ID = 90923

update DA_STUDENT_COPPYS
SET Date_of_resumption = 'Obi'
WHERE ID = 08763
rollback

-- date functions (getdate,datediff,dateadd,current_timestamp,sysdatetime,year,month,datepart)
--getdate

select GETDATE()

select CURRENT_TIMESTAMP

select SYSDATETIME()

-- dateadd
select GETDATE() as timenow, dateadd(day,5,getdate()) five_days_time

select GETDATE() as timenow, dateadd(day,-5,getdate()) five_days_time

--datediff
select Order_ID,Order_Date,Ship_Date, DATEDIFF(day, Order_Date,Ship_Date) days_to_ship
from Orders

select Order_ID,Order_Date,Ship_Date, DATEDIFF(MONTH, Order_Date,Ship_Date) days_to_ship
from Orders

--datepart
select Order_Date, DATEpart (day, Order_Date) DOM, DATEPART (YEAR,Order_Date) YEARS
from Orders

select order_date, year (order_date), day(order_date)
from orders

-- isdate
select isdate('2021-09-30')

select isdate('abel')


-- lets start off by creating a table

create table accounts (
id INT Primary key,
acct_no Int,
Amt decimal(10,2),
Bal decimal(10,2))

--Insert accounts
insert into accounts values (1,4567,5000.00,5000.00)
insert into accounts values (2,3567,9000.00,9000.00)

--Commit
--Debit sender's account
Begin transaction
Update accounts
set Bal = Amt + 3000.00
where acct_no = 4567

--Credit recipient's account
Update accounts
set Bal = Amt - 3000.00
where acct_no = 3567
commit

-- rollback
create table accounts_copys (
id INT Primary key,
acct_no Int,
Amt decimal(10,2),
Bal decimal(10,2))

--Insert accounts
insert into accounts_copys values (4,4847,3000.00,3000.00)
insert into accounts_copys values (5,3567,5000.00,5000.00)

Begin transaction
Update accounts_copys
set Bal = Amt - 3000.00
where acct_no = 4847

--Credit recipient's account
Update accounts_copys
set Bal = Amt + 3000.00
where acct_no = 3567
rollback

-- case statement
-- Banks remove charges when transactions are done, with this a case statement can be written
select Amt,
 case
     when amt < 10000 then 10.26
     when amt < 50000 then 26.00
     when amt < 100000 then 52.00
     Else 150.00
 end as transaction_charge
 from accounts
  



