--Creating Database
CREATE DATABASE GrocerySales;
GO

USE GrocerySales;
GO


--Creating Tables
CREATE TABLE Category(
	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(45)
	);


CREATE TABLE Country(
	CountryID INT PRIMARY KEY,
	CountryName VARCHAR(45),
	CountryCode VARCHAR(2)
	);


CREATE TABLE City(
	CityID INT PRIMARY KEY,
	CityName VARCHAR(45),
	Zipcode DECIMAL(5,0),
	CountryID INT,
	FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
	);


CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
	FirstName VARCHAR(45),
	MiddleInitial VARCHAR(5),
	LastName VARCHAR(45),
	CityID INT,
	FOREIGN KEY (CityID) REFERENCES City(CityID),
	Address VARCHAR(90)
	);



CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY,
	FirstName VARCHAR(45),
	MiddleInitial VARCHAR(1),
	LastName VARCHAR(45),
	BirthDate DATE,
	Gender VARCHAR(10),
	CityID INT,
	FOREIGN KEY (CityID) REFERENCES City(CityID),
	HireDate DATE
	);



CREATE TABLE Products(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(45),
	Price DECIMAL(10,4),
	CategoryID INT,
	Class VARCHAR(15),
	ModifyDate DATE,
	Resistance VARCHAR(15),
	IsAllergic VARCHAR(15),
	VitalityDays INT
	);


CREATE TABLE Sales (
	SalesID INT PRIMARY KEY,
	SalesPersonID INT,
	CustomerID INT,
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	ProductID INT,
	FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
	Quantity INT,
	SalesDate DATE,
	TransactionNumber VARCHAR(25)
	);


--Adding Datas from csv files to previously created tables
BULK INSERT Category
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\categories.csv'
WITH(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0D0A', -- for Windows 
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT Country
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\countries.csv'
WITH(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0D0A', 
    FIRSTROW = 2,
    CODEPAGE = '65001'
);


BULK INSERT City
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\cities.csv'
WITH(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0D0A', 
    FIRSTROW = 2,
    CODEPAGE = '65001'
);



BULK INSERT Customers
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\customers.csv'
WITH(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0D0A', 
    FIRSTROW = 2,
    CODEPAGE = '65001'
);



BULK INSERT Employees
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\employees.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

SELECT * FROM Employees


BULK INSERT Products
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);



BULK INSERT Sales
FROM 'C:\Users\Furkan\data_analysis\grocery_sales\sales.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);


--Checking Tables
SELECT * FROM Category

SELECT * FROM City

SELECT * FROM Country

SELECT * FROM Customers

SELECT * FROM Employees

SELECT * FROM Products

SELECT * FROM Sales


--Concatenating Employee and Customer Names and Removing unneccesary rows
ALTER TABLE Employees
ADD EmployeeName VARCHAR(45)

UPDATE Employees  
SET EmployeeName = CONCAT_WS(' ', FirstName, MiddleInitial, LastName);

ALTER TABLE Employees  
DROP COLUMN FirstName, MiddleInitial, LastName;


ALTER TABLE Customers
ADD CustomerName VARCHAR(45)

UPDATE Customers  
SET CustomerName = CONCAT_WS(' ', FirstName, MiddleInitial, LastName);

ALTER TABLE Customers  
DROP COLUMN FirstName, MiddleInitial, LastName;


--A comprehensive view combining sales, customer, product, category, employee, and location details
CREATE VIEW GrocerySalesView AS
SELECT 
    sales.*,
	DATENAME(MONTH, sales.SalesDate) AS Month, 
	products.Price,
	(sales.Quantity * products.Price) AS Revenue,
	products.ProductName, 
	products.Class,
	products.CategoryID,
    category.CategoryName,
    customers.CustomerName,
	customers.CityID,
    city.CityName,
	city.Zipcode,
	city.CountryID,
    country.CountryName, 
	country.CountryCode,
	employees.EmployeeName,
	employees.Gender
FROM Sales AS sales
LEFT JOIN Customers AS customers
ON sales.CustomerID = customers.CustomerID
LEFT JOIN City AS city
ON customers.CityID = city.CityID
LEFT JOIN Country AS country
ON city.CountryID = country.CountryID
LEFT JOIN Products AS products
ON sales.ProductID = products.ProductID
LEFT JOIN Category AS category
ON products.CategoryID = category.CategoryID
LEFT JOIN Employees AS employees
ON sales.SalesPersonID = employees.EmployeeID
WHERE sales.SalesDate IS NOT NULL;


--Checking the resulting view ordering by SalesDate and SalesID columns
SELECT * 
FROM GrocerySalesView
ORDER BY SalesDate, SalesID;


--Finding Date ranges
SELECT MIN(SalesDate) AS StartDate, MAX(SalesDate) AS EndDate
FROM GrocerySalesView;

--How many Days are there in May
SELECT COUNT(DISTINCT SalesDate) AS DayCount
FROM GrocerySalesView
WHERE Month = 'May';



-- SALES PERFORMANCE --

-- Calculating Daily Income
SELECT SalesDate, ROUND(SUM(Revenue), 0) AS DailyIncome
FROM GrocerySalesView
GROUP BY SalesDate
ORDER BY SalesDate;


--Calculating Average Daily Income
SELECT AVG(DailyRevenue) AS AvgDailyRevenue
FROM (
    SELECT SalesDate, SUM(Revenue) AS DailyRevenue
    FROM GrocerySalesView
    GROUP BY SalesDate
) AS DailySales;


--Monthly Income
SELECT Month, ROUND(SUM(Revenue), 0) AS TotalSalesAmount
FROM GrocerySalesView
GROUP BY Month
ORDER BY
	CASE Month
	WHEN 'January' THEN 1
	WHEN 'February' THEN 2
	WHEN 'March' THEN 3
	WHEN 'April' THEN 4
	WHEN 'May' THEN 5
	END;


--Average Daily Income by Month
SELECT 
    Month, 
    AVG(DailySales) AS AvgDailySalesByMonth
FROM (
    SELECT 
        Month, 
        SalesDate, 
        SUM(Revenue) AS DailySales
    FROM GrocerySalesView
    GROUP BY Month, SalesDate
) AS DailySalesTable
GROUP BY Month
ORDER BY 
    CASE Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
    END;


--Average Income by Customer
SELECT AVG(SalesAmount) AS AvgSale
FROM(
	SELECT CustomerID, SUM(Revenue) AS SalesAmount
	FROM GrocerySalesView
	GROUP BY CustomerID
) AS OverallAvgSaleByCustomer


--Calculating daily revenue and a 14-day rolling average, setting NULL for periods with fewer than 14 day
WITH DailyData AS (
SELECT SalesDate, 
SUM(Revenue) AS DailyRevenue
FROM GrocerySalesView
GROUP BY SalesDate
)

SELECT SalesDate,
DailyRevenue,
CASE
	WHEN COUNT(*) OVER(
		ORDER BY SalesDate
		ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
		) < 14
	THEN NULL
	ELSE AVG(DailyRevenue) OVER (
	ORDER BY SalesDate
	ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
	)
	END AS RollingAvg14Days
FROM DailyData
ORDER BY SalesDate;


--Calculating total monthly revenue, comparing it with the previous month, and determining the revenue change
WITH MonthlySales AS (
    SELECT 
        Month, 
        SUM(Revenue) AS TotalRevenue
    FROM GrocerySalesView
    GROUP BY Month
)

SELECT Month, TotalRevenue,
    LAG(TotalRevenue) OVER(ORDER BY 
        CASE Month 
            WHEN 'January' THEN 1 
            WHEN 'February' THEN 2 
            WHEN 'March' THEN 3 
            WHEN 'April' THEN 4 
            WHEN 'May' THEN 5 
        END) AS PreviousMonthRevenue,
    (TotalRevenue - LAG(TotalRevenue) OVER(ORDER BY 
        CASE Month 
            WHEN 'January' THEN 1 
            WHEN 'February' THEN 2 
            WHEN 'March' THEN 3 
            WHEN 'April' THEN 4 
            WHEN 'May' THEN 5 
        END)) AS RevenueChange
FROM MonthlySales
ORDER BY 
    CASE Month 
        WHEN 'January' THEN 1 
        WHEN 'February' THEN 2 
        WHEN 'March' THEN 3 
        WHEN 'April' THEN 4 
        WHEN 'May' THEN 5 
    END;




WITH MonthlySales AS (
    SELECT 
        Month, 
        SUM(Revenue) AS TotalRevenue
    FROM GrocerySalesView
    GROUP BY Month
),
MoMChange AS (
    SELECT 
        Month, 
        TotalRevenue,
        LAG(TotalRevenue) OVER(ORDER BY 
            CASE Month 
                WHEN 'January' THEN 1 
                WHEN 'February' THEN 2 
                WHEN 'March' THEN 3 
                WHEN 'April' THEN 4 
                WHEN 'May' THEN 5 
            END) AS PreviousMonthRevenue
    FROM MonthlySales
)
SELECT 
    Month,
    TotalRevenue,
    PreviousMonthRevenue,
    CASE 
        WHEN PreviousMonthRevenue IS NOT NULL THEN
            ((TotalRevenue - PreviousMonthRevenue) / PreviousMonthRevenue) * 100
        ELSE NULL 
    END AS MoMChange
FROM MoMChange
ORDER BY 
    CASE Month 
        WHEN 'January' THEN 1 
        WHEN 'February' THEN 2 
        WHEN 'March' THEN 3 
        WHEN 'April' THEN 4 
        WHEN 'May' THEN 5 
    END;





-- PRODUCT ANALYSIS --

-- Product Rank based on Total Sales
SELECT ProductName, SUM(Revenue) AS TotalSales,
RANK() OVER(ORDER BY SUM(Revenue) DESC) AS RevenueRank
FROM GrocerySalesView
GROUP BY ProductName;


-- Category Rank based on Total Sales
SELECT CategoryName, SUM(Revenue) AS TotalSales,
RANK() OVER(ORDER BY SUM(Revenue) DESC) AS RevenueRank
FROM GrocerySalesView
GROUP BY CategoryName;


--Top 5 Best Selling Products Each Month

WITH RankedProductSales AS (
    SELECT ProductName, 
           Month, 
           ROUND(SUM(Revenue), 0) AS TotalRevenue,
           RANK() OVER(PARTITION BY Month ORDER BY SUM(Revenue) DESC) AS SalesRank
    FROM GrocerySalesView
    GROUP BY ProductName, Month
)
SELECT ProductName, Month, TotalRevenue, SalesRank
FROM RankedProductSales
WHERE SalesRank <= 5
ORDER BY 
    CASE Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
	END,
	SalesRank;
	

--Ranking product categories by monthly revenue and selecting the top 5 for each month
WITH RankedCategorySales AS (
    SELECT CategoryName, 
           Month, 
           ROUND(SUM(Revenue), 0) AS TotalRevenue,
           RANK() OVER(PARTITION BY Month ORDER BY SUM(Revenue) DESC) AS SalesRank
    FROM GrocerySalesView
    GROUP BY CategoryName, Month
)
SELECT CategoryName, Month, TotalRevenue, SalesRank
FROM RankedCategorySales
WHERE SalesRank <= 5
ORDER BY 
    CASE Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
	END,
	SalesRank;


--Top 10 Highest Demanding Products--

WITH DemandingProducts AS (
SELECT ProductName, 
SUM(Quantity) AS TotalQuantity, 
RANK() OVER(ORDER BY SUM(Quantity) DESC) AS QuantityRank
FROM GrocerySalesView
GROUP BY ProductName
)

SELECT ProductName, TotalQuantity, QuantityRank
From DemandingProducts
WHERE QuantityRank <=10
ORDER BY QuantityRank;



--Top 5 Highest Demanding Products by Month--
WITH DemandingProductsMonth AS (
Select ProductName,
Month,
SUM(Quantity) AS TotalQuantity, 
RANK() OVER(PARTITION BY Month ORDER BY SUM(Quantity) DESC) AS QuantityRank
FROM GrocerySalesView
GROUP BY ProductName, Month
)

SELECT ProductName, Month, TotalQuantity, QuantityRank
FROM DemandingProductsMonth
WHERE QuantityRank <= 5
ORDER BY
	CASE Month
		WHEN 'January' THEN 1
		WHEN 'February' THEN 2
		WHEN 'March' THEN 3
		WHEN 'April' THEN 4
		WHEN 'May' THEN 5
	END,
	QuantityRank




--CUSTOMER ANALYSIS--

--How many customers are there?
SELECT COUNT(DISTINCT CustomerID)
FROM GrocerySalesView


--Counting the number of customers who made more than one purchase
SELECT COUNT(*) AS NumberOfRepeatCustomer
FROM (
    SELECT CustomerID
    FROM GrocerySalesView
    GROUP BY CustomerID
    HAVING COUNT(CustomerID) > 1
) AS RepeatCustomers;


--Counting the number of customers who made only one purchase
SELECT COUNT(*) AS NumberOfSinglePurchaseCustomers
FROM (
    SELECT CustomerID
    FROM GrocerySalesView
    GROUP BY CustomerID
    HAVING COUNT(CustomerID) = 1
) AS SinglePurchaseCustomers;


--Calculating the average total sales amount per customer
SELECT AVG(SalesAmount) AS AvgSale
FROM(
	SELECT CustomerID, SUM(Revenue) AS SalesAmount
	FROM GrocerySalesView
	GROUP BY CustomerID
) AS OverallAvgSaleByCustomer


--Calculating the average purchase frequency per customer
WITH CustomerMonthlyPurchaseData AS (
	SELECT 
		CustomerID,
		Count(DISTINCT TransactionNumber) AS PurchaseFreq,
		SUM(Revenue) AS TotalSpend
	FROM GrocerySalesView
	GROUP BY CustomerID
)
SELECT AVG(PurchaseFreq) AS OverallAvgPurchaseFreq
FROM CustomerMonthlyPurchaseData


--Segmenting customers based on purchase frequency and total spending
WITH CustomerMonthlyPurchaseData AS (
	SELECT 
		CustomerID,
		Count(DISTINCT TransactionNumber) AS PurchaseFreq,
		SUM(Revenue) AS TotalSpend
	FROM GrocerySalesView
	GROUP BY CustomerID
)

SELECT CustomerID, PurchaseFreq, TotalSpend,
	CASE
        WHEN PurchaseFreq BETWEEN 0 AND 4 THEN 'Very Low Frequency'
        WHEN PurchaseFreq BETWEEN 5 AND 8 THEN 'Low Frequency'
        WHEN PurchaseFreq BETWEEN 9 AND 13 THEN 'Average Frequency'
        WHEN PurchaseFreq BETWEEN 14 AND 18 THEN 'High Frequency'
        ELSE 'Very High Frequency'
	END AS FrequencySegment,
	CASE
		WHEN TotalSpend <= 3000 THEN 'Very Low Spend'
		WHEN TotalSpend BETWEEN 3001 AND 6000 THEN 'Low Spend'
		WHEN TotalSpend BETWEEN 6001 AND 10000 THEN 'Average Spend'
		WHEN TotalSpend BETWEEN 10001 AND 17000 THEN 'High Spend'
		ELSE 'Very High Spend'
	END AS SpendSegment
FROM CustomerMonthlyPurchaseData
ORDER BY  CustomerID;




--SALESPERSON EFFECTIVENESS--

--Calculating total revenue for each salesperson
SELECT SalesPersonID, EmployeeName, SUM(Revenue) AS TotalRevenue
FROM GrocerySalesView
GROUP BY SalesPersonID, EmployeeName
ORDER BY TotalRevenue DESC;



-- Segmenting employees based on their total revenue performance and categorizing them into performance groups
WITH EmployeeRevenue AS (
    SELECT 
        SalesPersonID, 
        EmployeeName, 
        SUM(Revenue) AS TotalRevenue
    FROM GrocerySalesView
    GROUP BY SalesPersonID, EmployeeName
)
SELECT 
    SalesPersonID, 
    EmployeeName, 
    TotalRevenue,
    CASE 
        WHEN TotalRevenue  <= 29691764 THEN 'Low Performance'
        WHEN TotalRevenue BETWEEN 29691765 AND 29910448 THEN 'Average Performance'
        ELSE 'High Performance'
    END AS PerformanceSegment
FROM EmployeeRevenue
ORDER BY TotalRevenue DESC;



-- Ranking salespersons based on their total revenue within each month and selecting the top 5 performers for each month.
WITH MonthlySalesRanking AS (
    SELECT 
        SalesPersonID, 
        EmployeeName, 
        Month, 
        SUM(Revenue) AS TotalRevenue,
        RANK() OVER(PARTITION BY Month ORDER BY SUM(Revenue) DESC) AS RevenueRank
    FROM GrocerySalesView
    GROUP BY SalesPersonID, EmployeeName, Month
)

SELECT SalesPersonID, EmployeeName, Month, TotalRevenue, RevenueRank
FROM MonthlySalesRanking
WHERE RevenueRank <= 5
ORDER BY 
    CASE Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
    END,
    RevenueRank;


-- Calculating the revenue change for each salesperson by comparing their current month's revenue with the previous month's revenue.
WITH MonthlySales AS (
    SELECT 
        SalesPersonID, 
        EmployeeName, 
        Month, 
        SUM(Revenue) AS TotalRevenue
    FROM GrocerySalesView
    GROUP BY SalesPersonID, EmployeeName, Month
)

SELECT SalesPersonID, EmployeeName, Month, TotalRevenue,
    LAG(TotalRevenue) OVER(PARTITION BY SalesPersonID ORDER BY 
        CASE Month 
            WHEN 'January' THEN 1 
            WHEN 'February' THEN 2 
            WHEN 'March' THEN 3 
            WHEN 'April' THEN 4 
            WHEN 'May' THEN 5 
        END) AS PreviousMonthRevenue,
    (TotalRevenue - LAG(TotalRevenue) OVER(PARTITION BY SalesPersonID ORDER BY 
        CASE Month 
            WHEN 'January' THEN 1 
            WHEN 'February' THEN 2 
            WHEN 'March' THEN 3 
            WHEN 'April' THEN 4 
            WHEN 'May' THEN 5 
        END)) AS RevenueChange
FROM MonthlySales
ORDER BY SalesPersonID, 
    CASE Month 
        WHEN 'January' THEN 1 
        WHEN 'February' THEN 2 
        WHEN 'March' THEN 3 
        WHEN 'April' THEN 4 
        WHEN 'May' THEN 5 
    END;



--GEOGRAPHICAL SALES INSIGHTS--

--Which cities are there?
SELECT DISTINCT CityName
FROM GrocerySalesView;

-- Calculating the total revenue for each city
SELECT CityName, SUM(Revenue) AS TotalRevenue
FROM GrocerySalesView
GROUP BY CityName
ORDER BY TotalRevenue DESC;


-- Calculating total revenue by city, comparing it to the overall average revenue, and categorizing cities into income levels.
WITH AvgValue AS(
SELECT AVG(TotalRevenue) AS OverallAvg
FROM(
	SELECT CityName, SUM(Revenue) AS TotalRevenue
	FROM GrocerySalesView
	GROUP BY CityName
	) AS OverallAvgRevenue
)

SELECT CityName, 
SUM(Revenue) AS TotalRevenue,
SUM(Revenue) - (SELECT OverallAvg FROM AvgValue) AS Difference,
CASE
	WHEN SUM(Revenue) <= 6964541 THEN 'Low'
	WHEN SUM(Revenue) BETWEEN 6964542 AND 7292886 THEN 'Average'
	ELSE 'High'
END AS IncomeLevel
FROM GrocerySalesView
GROUP BY CityName
ORDER BY TotalRevenue DESC;


