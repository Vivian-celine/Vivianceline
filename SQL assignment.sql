-- Return a table of customers,products and the amount used to ship each order
select Customer_Name,Product_Name,Shipping_Cost
from Orders

--	Prove that the highest profit is greater than the average sales
select MAX(profit) Max_profit
from Orders

-- Max_profit 16332.4140625  and Avg_sales 949.706270923072 therefore  (Max_profit is greater than Avg_sales)

-- Show the shipping methods and the orders that went through them
select Order_ID,Ship_Mode
from orders

-- Return the orders that were delivered through air
select Order_ID,Ship_Mode
from orders
where Ship_Mode = 'Express Air' or ship_mode = 'regular air'

-- Show the total profit that were made by the central customers that delivered goods through trucks
select Customer_Name,Region,Ship_Mode, SUM(profit)total_profit
from Orders
where Ship_Mode = 'delivery truck' and Region = 'central'
group by Region,Ship_Mode,Customer_Name

-- show a table of technology products whose total profit was less than 5000 for orders that were delivered through air
select Product_Name,Product_Category,Ship_Mode,sum(Profit)total_profit
from Orders
where Product_Category = 'technology' and Ship_Mode = 'Express air' or Ship_Mode = 'regular air'
group by Product_Name,Product_Category,Ship_Mode
having sum(profit) < 5000

--On a rainy morning the people of a central region are ordering only furniture and home office products, 
--how much profit could we make from them
select Customer_Name,Region,Product_Category,SUM(profit)total_profit
from Orders
where Region = 'central' and Product_Category = 'furniture' or Product_Category = 'Home office'
group by Customer_Name,Region,Product_Category

-- Our new boss doesnt like repeated enteries show the state and shipping cost
select distinct State_or_Province, Shipping_Cost
from Orders

-- Return a table of customers with letter b whose orders went to the west and the total sales made from each customer
select Customer_Name,Region,sum(sales)total_sales
from Orders
where Customer_Name like '%b%' and  Region = 'west' 
group by Customer_Name,Region

-- retrieve a table of corporate customers with quantity less than 20 whose orders gave above 1000 in total profit
select Customer_Name,Customer_Segment,Quantity_ordered_new, sum(profit) total_profit
from Orders
where Customer_Segment = 'corporate' and Quantity_ordered_new < 20
group by Customer_Name,Customer_Segment,Quantity_ordered_new
having sum(profit) > 1000
order by total_profit desc


--1 The rivers task force on parol is arresting every business owner who cannot prove that they have
-- managers for their business. they also need the receipt of profit and sales made by these managers, as the
-- government is seeking to demolish business running on losses while promoting product sub categories that
-- are booming. save your boss from jail and determine what part of his business gets promoted

select Profit,sales,column2 as manager 
from Orders
right join Users
on Orders.Region = Users.column1
order by column2

select Product_Sub_Category, SUM(Profit)Total_profit,SUM(sales)Total_sales,column2 as manager
from Orders
join Users
on Orders.Region = Users.column1
group by Product_Sub_Category,column2
having sum (profit) < 0

--2 there is an on going protest affecting the airports in the country. show the customers that would have 
-- been unable to return their orders if the protest had started earlier
select orders.Order_ID,ship_mode,Customer_Name,status
from Orders
inner join Returns
on Orders.Order_ID = Returns.Order_ID
where Ship_Mode != 'delivery truck'

-- assignment
--1) with customer yielding,meduim,high and low profit, return a table showing showing the manager of these 
-- customers as well as their region.

select Customer_ID,Customer_Name,Profit,Orders.Region,column2 manager,
case
       when profit > 1000 then 'High'
       when Profit > 100 then 'Medium'
       when profit > 0 then 'low'
       else 'No profit' 
end as order_grade
from Orders
join users
on orders.region=Users.column1


--2) with the result from question 1, return only details of orders delivered by delivery truck and regular air.

select Customer_ID,Customer_Name,Profit,Orders.Region,column2 manager,ship_mode,
case
       when profit > 1000 then 'High'
       when Profit > 100 then 'Medium'
       when profit > 0 then 'low'
       else 'No profit' 
end as order_grade
from Orders
join users
on orders.region=Users.column1
where Ship_Mode <> 'express air'

--3) using the result from 1&2, return the table that includes only orders which sales are greater than 5000.

select Customer_ID,Customer_Name,Profit,Orders.Region,column2 manager,ship_mode,
case
       when profit > 1000 then 'High'
       when Profit > 100 then 'Medium'
       when profit > 0 then 'low'
       else 'No profit' 
end as order_grade
from Orders
join users
on orders.region=Users.column1
where Ship_Mode <> 'express air' and Sales > 5000

--4) with all things being equal, return a table that has my managers and customers in one column while also returning 
-- my total profit according to that column,return my shipmode and the quantity of goods ordered

select Customer_Name,Ship_Mode,sum(profit)total_profit,Quantity_ordered_new,column2 manager, CONCAT(customer_name, '_',column2)as C_M
from Orders
left join Users
on Orders.Region=Users.column1
group by Customer_Name,Ship_Mode,Quantity_ordered_new,column2


--5) return a table of central small business owners whose orders yielded negative profit

select Order_ID,Customer_Name,Region,Customer_Segment,Profit
from Orders
where Region = 'central' and Customer_Segment = 'small business' and Profit < 0


--6) prove the most returned product by certain customers in the corporate world.

select customer_name,Product_Name,Customer_Segment,
COUNT(status)as returned 
from orders  O
join Returns R
On O.Order_ID = R.Order_ID
where Customer_Segment = 'corporate'
group by customer_name,Product_Name,Customer_Segment

-- Return the best candidate for a reward program based on quantity purchased in each customer segment

select Customer_Name,Quantity_ordered_new,Customer_Segment,ranks
from (select Customer_Name,Quantity_ordered_new,Customer_Segment,
rank() over(partition by customer_segment order by quantity_ordered_new desc) as ranks
from Orders) as B
where ranks = 1
order by Customer_Segment asc

select Customer_Name,Quantity_ordered_new,Customer_Segment,ranks
from (select Customer_Name,Quantity_ordered_new,Customer_Segment,
rank() over(order by quantity_ordered_new desc) as ranks
from Orders) as B
where ranks = 1
order by Customer_Segment asc

-- update unique dates, fillblank spaces in names and id columns then delete the age column

