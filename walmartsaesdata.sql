CREATE database walmart_sales_data;
use walmart_sales_data;
select * from sales;
-- ----------- Feature Engineering
-- Time of day
select time,
(
case
when 'time' >= '00:00:00' and time <'12:00:00' then "Morning"
when 'time' >= '12:00:00' and time <'16:00:00' then "Afternoon" 
else "Evening"
end
) as time_of_day
from sales;
alter table sales
add column time_of_day varchar(10);
update sales
set time_of_day = (
case
when 'time' >= '00:00:00' and time <'12:00:00' then "Morning"
when 'time' >= '12:00:00' and time <'16:00:00' then "Afternoon" 
else "Evening"
end
);

-- Day name
select date,
dayname(date)
from sales;
alter table sales
add column day_name varchar(10);
update sales
set day_name = dayname(date);

-- Month name
select date,
monthname(date)
from sales;
alter table sales
add column month_name varchar(10);
update sales
set month_name = monthname(date);
alter table sales
drop column mont_name;

-- -----------------------------------------------------------------------
-- ----------- Generic
-- ---How many unique cities does the data have?
select distinct city
from sales;

-- ---In which city is each branch?
select distinct city,branch
from sales;

-- -----------------------------------------------------------------------
-- ----------- Product
-- ---How many unique product lines does the data have?
select count(distinct `product line`)
from sales; 

-- ---What is the most common payment method?
select payment, count(payment) as cnt
from sales
group by payment
order by cnt desc;

-- ---What is the most selling product line?
select `product line`,count(`product line`) as cnt
from sales
group by `product line`
order by cnt desc;

-- ---What is the total revenue by month?
select month_name,sum(total)
from sales
group by month_name
order by month_name desc;

-- ---What month had the largest COGS?
select month_name,sum(cogs)
from sales
group by month_name
order by sum(cogs) desc;

-- ---What product line had the largest revenue?
select `product line`,sum(total)
from sales
group by `product line`
order by sum(total) desc;

-- ---What is the city with the largest revenue?
select city,sum(total)
from sales
group by city
order by sum(total) desc;

-- ---What product line had the largest VAT?
select `product line`,sum(`tax 5%`)
from sales
group by `product line`
order by sum(`tax 5%`) desc;

-- ---Fetch each product line and add a column to those product line showing "Good", "Bad". 
   -- Good if its greater than average sales
    alter table sales
add column comment varchar(10);


  select `product line`,comment
  from sales;
 
   
-- ---Which branch sold more products than average product sold?
select branch,sum(quantity)
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- ---What is the most common product line by gender?
select `product line`,count(gender),gender
from sales
group by `product line`,gender 
order by count(gender) desc;
-- ---What is the average rating of each product line?
select `product line`,round(avg(rating), 2)
from sales
group by `product line`
order by round(avg(rating), 2) desc;

-- -----------------------------------------------------------------------
-- ----------- Sales

-- ---Number of sales made in each time of the day per weekday
select day_name,time_of_day,sum(total)
from sales where day_name= "tuesday" or day_name="wednesday" or day_name="monday" or day_name="thursday" or day_name="friday"
group by day_name,time_of_day
order by day_name desc;
-- ---Which of the customer types brings the most revenue?
select `customer type`,sum(total)
from sales
group by `customer type`
order by sum(total) desc;

-- ---Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,sum(`tax 5%`)
from sales
group by city
order by sum(`tax 5%`) desc;

-- ---Which customer type pays the most in VAT?
select `customer type`,sum(`tax 5%`)
from sales
group by `customer type`
order by sum(`tax 5%`) desc;

-- -----------------------------------------------------------------------
-- ----------- Customer

-- ---How many unique customer types does the data have?
select distinct `customer type`
from sales;

-- ---How many unique payment methods does the data have?
select distinct payment
from sales;

-- ---What is the most common customer type?
select `customer type`,count(`invoice id`)
from sales
group by `customer type`;

-- ---Which customer type buys the most?
select `customer type`,sum(total)
from sales
group by `customer type`
order by sum(total) desc;

-- ---What is the gender of most of the customers?
select gender,count(`invoice id`)
from sales
group by gender;
-- ---What is the gender distribution per branch?
select branch,gender,count(`invoice id`)
from sales
group by branch,gender
order by branch;

-- ---Which time of the day do customers give most ratings?
select time_of_day,sum(rating)
from sales
group by time_of_day
order by sum(rating) desc;

-- ---Which time of the day do customers give most ratings per branch?
select time_of_day,branch,avg(rating)
from sales
group by time_of_day,branch
order by avg(rating) desc;

-- ---Which day of the week has the best avg ratings?
select day_name,avg(rating)
from sales
group by day_name
order by avg(rating) desc;

-- ---Which day of the week has the best average ratings per branch?
select branch,day_name,avg(rating)
from sales
group by branch,day_name
order by avg(rating) desc ;



