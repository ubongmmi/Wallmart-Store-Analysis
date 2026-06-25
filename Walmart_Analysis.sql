USE UBONG
go

--1 compare avg weekly sales for holiday vs regular weeks 
SELECT
    Store_Id,
    Holiday_label,
    ROUND(AVG(Weekly_Sales), 2) AS Avg_Weekly_Sales
FROM walmart
GROUP BY Store_Id,  Holiday_label
ORDER BY Store_Id,  Holiday_label;

--2 Top 5 stores by annual sales
WITH StoreSales AS (
    SELECT
        Store_Id,
        SUM(Weekly_Sales) AS Total_Sales
    FROM walmart
    GROUP BY Store_Id
)
SELECT
    Store_Id,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM StoreSales
limit 5;

--3 Bottom 5 store by annual sales

WITH StoreSales AS (
    SELECT
        Store_Id,
        SUM(Weekly_Sales) AS Total_Sales
    FROM walmart
    GROUP BY Store_Id
)
SELECT
    Store_Id,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales asc) AS Sales_Rank
FROM StoreSales
limit 5;




-- aggregating sales by month

WITH MonthlySales AS (
    SELECT
        Year  AS Sales_Year,
        MONTH(Date) as month_num,
        Month AS Sales_Month,
        SUM(Weekly_Sales) AS Monthly_Sales
    FROM walmart
    GROUP BY Year, Month
)
SELECT
    Sales_Year,
    Sales_Month,
    Monthly_Sales,
    LAG(Monthly_Sales) OVER (
        ORDER BY Sales_Year, month_num asc
    ) AS Previous_Month_Sales
FROM MonthlySales;

-- calculating the growth percentage
WITH MonthlySales AS (
    SELECT
        Year  AS Sales_Year,
        MONTH(Date) as month_num,
        Month AS Sales_Month,
        SUM(Weekly_Sales) AS Monthly_Sales
    FROM walmart
    GROUP BY Year, Month
)
SELECT
    Sales_Year,
    Sales_Month,
    Monthly_Sales,
    LAG(Monthly_Sales) OVER (
        ORDER BY Sales_Year, month_num
    ) AS Previous_Month_Sales,
    ROUND(
        (
            Monthly_Sales -
            LAG(Monthly_Sales) OVER (
                ORDER BY Sales_Year, month_num
            )
        ) /
        LAG(Monthly_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) * 100,
        2
    ) AS Growth_Percentage
FROM MonthlySales;
