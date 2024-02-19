--Select*
--From WalmartSalesData
-- Feature Engineering 
--TimeOfDay
--Select Time,
--Case 
--	When Time between '00:00:00' And '12:00:00' Then 'Morning'
--	When Time between '12:01:00' And '16:00:00' Then 'Afternoon'
--	Else 'Evening' 
--End AS TimeOfDay
--From WalmartSalesData
SELECT 
    Time,
    CASE 
        WHEN CAST(Time AS TIME) >= '00:00:00' AND CAST(Time AS TIME) <= '12:00:00' THEN 'Morning'
        WHEN CAST(Time AS TIME) > '12:00:00' AND CAST(Time AS TIME) <= '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS TimeOfDay
FROM WalmartSalesData;

Alter Table WalmartSalesData
Add TimeOfDay nvarchar(20)
-- Adding  a column with the timeofday and adding the values 
Update WalmartSalesData
Set TimeOfDay = (
    CASE 
        WHEN CAST(Time AS TIME) >= '00:00:00' AND CAST(Time AS TIME) <= '12:00:00' THEN 'Morning'
        WHEN CAST(Time AS TIME) > '12:00:00' AND CAST(Time AS TIME) <= '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- Adding DayOfWeek 

Select Date,DATENAME(DW,Date) as DayOfWeek
From WalmartSalesData

Alter Table WalmartSalesData Add DayOfWeek nvarchar(10)

Update WalmartSalesData
Set DayOfWeek =(DATENAME(DW,Date))

Select*
From WalmartSalesData

--Adding MonthName

SELECT Date, DATENAME(MONTH, Date) AS MonthName
FROM WalmartSalesData;

Alter Table WalmartSalesData Add MonthName nvarchar(25)

Update WalmartSalesData
Set MonthName = (DATENAME(MONTH, Date))

Select* 
From WalmartSalesData

-- Answering some Exploratory Data analysis Questions 
---------------------------------------------------------Generic---------------------------------------------------------------
-- How many unique cities does the data have?
Select Distinct City
From WalmartSalesData
-- Three Unique Cities 

-- In Which City is each Brand ?
Select Distinct Branch
From WalmartSalesData

Select Distinct City,Branch
From WalmartSalesData
-- Branch B is in Mandalay 
-- Branch C is in Naypitaw
-- Branch A is in Yangon 
--------------------------------------------Product-------------------------------------------------------
--How many unique product lines does the data have?
Select Count(Distinct [Product line])
From WalmartSalesData
-- 6 

-- What is the most common payment method?
Select payment,Count(Payment) as CNT
From WalmartSalesData
Group by Payment
Order By CNT Desc
-- Ewallet was the most common payment method 

-- What is the most selling product line?
Select [Product line],Count([Product line]) as CNT
From WalmartSalesData
Group by [Product line]
Order By CNT Desc
-- Fashion accessories is the most sellling product line 

-- What is the total revenue by month?
Select MonthName as Month, Sum(total)as TotalRevenue 
From WalmartSalesData
Group By MonthName
order by TotalRevenue desc
-- January had 116291  
-- March had 109455
-- February had 97219  

--What month had the largest COGS?
Select MonthName as month ,
SUM(cogs) as cogs
From WalmartSalesData
Group By MonthName
order by cogs desc
-- January had the most of cogs with 110,754

--What product line had the largest revenue?
Select [Product line],
SUM(total) as TotalRevenue 
From WalmartSalesData
Group by [Product line]
Order by TotalRevenue DESC
-- Food and beverages had the largest revenue 

-- What is the city with the largest revenue?
Select Branch,City,
SUM(total) as TotalRevenue 
From WalmartSalesData
Group by City,Branch
Order by TotalRevenue DESC
-- Branch C in Naypyitaw had the largest revenue

--What product line had the largest VAT?
Select [Product line],avg([Tax 5%]) as AVGTax
From WalmartSalesData
group by [Product line]
order by AVGTax desc
-- Home and lifestyle had the largest Vat

--Which branch sold more products than average product sold?
Select Branch,SUM(quantity) as Qty
From WalmartSalesData
group by Branch
Having Sum(Quantity) > (Select AVG(Quantity) From WalmartSalesData)
-- Branch A sold the most products than average product sold

-- What is the most common product line by gender?
Select Gender, [Product line], COUNT(Gender) as Total_cnt
From WalmartSalesData
Group by Gender,[Product line]
order by total_cnt

-- What is the average rating of each product line?
Select Round(AVG(Rating),2) as AvgRating , [Product line]
From WalmartSalesData
Group By [Product line]
Order By AvgRating DESC

-- -----------------------------------------Sales-----------------------------------------------

--Number of sales made in each time of the day per weekday.
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Sunday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Monday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Tuesday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Wednesday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Thursday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Friday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;
SELECT TimeOfDay, COUNT(*) AS TotalSales
FROM WalmartSalesData
WHERE DayOfWeek = 'Saturday'
GROUP BY TimeOfDay 
ORDER BY TotalSales DESC;

--Which of the customer types brings the most revenue?
Select [Customer type],SUM(total) as TotalRevenue
From WalmartSalesData
Group By [Customer type]
Order By TotalRevenue DESC
-- Members

--Which city has the largest tax percent/ VAT (**Value Added Tax**)?
Select City, Avg([Tax 5%]) AS VAT
From WalmartSalesData
Group By City
order by VAT Desc
--Naypyitaw

--Which customer type pays the most in VAT?
Select [Customer type], Avg([Tax 5%]) AS VAT
From WalmartSalesData
Group By [Customer type]
order by VAT Desc
--Member
-- ----------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------Customers------------------------------------------------------------

--How many unique customer types does the data have?
Select Distinct [Customer type]
From WalmartSalesData
-- Members And Normals

--How many unique payment methods does the data have?
Select Distinct Payment
From WalmartSalesData
-- 3

--What is the most common customer type?
SELECT [Customer type], COUNT(*) AS TotalCount
FROM WalmartSalesData
GROUP BY [Customer type]
ORDER BY TotalCount DESC;

-- Which customer type buys the most?
Select [Customer type],COUNT(*) as CustomerCount
From WalmartSalesData
Group BY [Customer type]
Order By CustomerCount

--What is the gender of most of the customers?
Select Gender, COUNT(*) as GenderCount
From WalmartSalesData
Group By Gender
Order By GenderCount Desc
-- Female 501 - Male 499

-- What is the gender distribution per branch?
Select Gender, COUNT(*) as GenderCount
From WalmartSalesData
Where Branch = 'C'
Group By Gender
Order By GenderCount Desc
Select Gender, COUNT(*) as GenderCount
From WalmartSalesData
Where Branch = 'A'
Group By Gender
Order By GenderCount Desc
Select Gender, COUNT(*) as GenderCount
From WalmartSalesData
Where Branch = 'B'
Group By Gender
Order By GenderCount Desc

-- Which time of the day do customers give most ratings?
Select TimeOfDay,Round(AVG(Rating),2) As AVGRating
From WalmartSalesData
Group by TimeOfDay
Order By AVGRating desc
-- Afternoon

--Which time of the day do customers give most ratings per branch?
Select TimeOfDay,Round(AVG(Rating),2) As AVGRating
From WalmartSalesData
Where Branch = 'C'
Group by TimeOfDay
Order By AVGRating desc
Select TimeOfDay,Round(AVG(Rating),2) As AVGRating
From WalmartSalesData
Where Branch = 'B'
Group by TimeOfDay
Order By AVGRating desc
Select TimeOfDay,Round(AVG(Rating),2) As AVGRating
From WalmartSalesData
Where Branch = 'A'
Group by TimeOfDay
Order By AVGRating desc

--Which day of the week has the best avg ratings?
Select DayOfWeek,Round(AVG(Rating),2) as AVGRating
From WalmartSalesData
Group By DayOfWeek
Order By AVGRating desc
-- Monday

-- Which day of the week has the best average ratings per branch?
Select DayOfWeek,Round(AVG(Rating),2) as AVGRating
From WalmartSalesData
Where Branch = 'C'
Group By DayOfWeek
Order By AVGRating desc
Select DayOfWeek,Round(AVG(Rating),2) as AVGRating
From WalmartSalesData
Where Branch = 'B'
Group By DayOfWeek
Order By AVGRating desc
Select DayOfWeek,Round(AVG(Rating),2) as AVGRating
From WalmartSalesData
Where Branch = 'A'
Group By DayOfWeek
Order By AVGRating desc