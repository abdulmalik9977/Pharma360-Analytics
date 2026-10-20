use pharma360;

select * from customers;

select 
c.Customer_Type,
count(distinct c.Customer_ID) as Number_of_Customers,
count(s.Sale_ID) AS Total_Transactions,
round(sum(s.Revenue), 2) as Total_Revenue,
round(sum(s.Gross_Profit), 2) as Total_Gross_Profit,
round(sum(s.Gross_Profit) / sum(s.Revenue) * 100, 2) as Profit_Margin_pct

from fact_sales s
join customers c
on c.Customer_ID = s.Customer_ID
group by 
    c.Customer_Type
order by Total_Gross_Profit desc;


select d.Year_Month,
count(s.Sale_ID) as Total_Transactions,
sum(s.Qty_Sold) as Total_Qty_Sold,
round(sum(s.Revenue), 2) as Total_Revenue,
round(sum(s.Gross_Profit), 2) as Total_Gross_Profit
from fact_sales s
join date d on s.Sale_Date = d.Date_Value
group by d.Year_Month
order by d.Year_Month asc;




select * from product;
select * from fact_sales;
select * from sales_rep;


select p.Product_Name,
round(sum(f.Revenue), 2) as Total_Revenue,
sum(f.Qty_Sold) Total_Quantity_Sold,
round(sum(f.Gross_Profit) /sum(f.Revenue) * 100, 2) as Profit_Margin

from product p
join fact_sales f 
on p.SKU = f.SKU

group by p.Product_Name
order by Total_Revenue desc;


select c.City,
round(sum(f.Revenue), 2) as Total_Revenue,
round(sum(f.Gross_Profit), 2) as Total_Gross_Profit,
round(sum(f.Gross_Profit) /sum(f.Revenue) * 100, 2) as Profit_Margin

from customers c
join fact_sales f
on c.Customer_ID = f.Customer_ID
group by c.City
order by Total_Gross_Profit desc;

select p.Product_Name,
round(s.Total_Gross_Profit, 2) as Total_Gross_Profit,
coalesce(i.Expired_Batches_Count) as Expired_Batches_Count,
coalesce(i.Total_Expired_Cost) as Total_Expired_Cost
from product p
left join ( select SKU, sum(Gross_Profit) as Total_Gross_Profit
from fact_sales
group by SKU) s on p.SKU = s.SKU
left join (select SKU,
count(distinct Batch_ID) as Expired_Batches_Count,
sum(Inventory_Cost_Value) as Total_Expired_Cost 
from inventory
where Expiry_Risk_Period ='Expired (past expiry)'
group by SKU) i on p.SKU = i.SKU
order by Total_Expired_Cost  desc;


select 
Warehouse,
Expiry_Risk_Period,
count(Batch_ID) as Total_Batches,
sum(Qty_Remaining) as Total_Qty_Remaining,
round(sum(Inventory_Cost_Value), 2) as Total_Inventory_Cost
from inventory
where Product_Name = 'Ceftriaxone 1g'
and Expiry_Risk_Period != 'Expired (past expiry)'
group by Warehouse, Expiry_Risk_Period
order by Total_Qty_Remaining desc;


select 
Category,
count(Batch_ID) as Expired_Batches_Count,
sum(Qty_Remaining) as Total_Expired_Quntity,
round(sum(Inventory_Cost_Value), 2) as Total_Inventory_Cost
from inventory
where Expiry_Risk_Period = 'Expired (past expiry)'
group by Category
order by Total_Inventory_Cost desc;


SELECT ROUND(SUM(Revenue), 2) AS Check_Revenue FROM fact_sales;

SELECT ROUND(SUM(Inventory_Cost_Value), 2) AS Check_Expired_Cost 
FROM inventory 
WHERE Expiry_Risk_Period = 'Expired (past expiry)';