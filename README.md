# Grocery-Sales-Analysis-and-Dashboard
SQL Operations and Data Processing
1. Database and Table Creation
Creating the GrocerySales database and structured it with multiple tables, including:
Category (Product categories)
Country and City (Geographical data)
Customers (Customer details)
Employees (Staff information)
Products (Product details with prices)
Sales (Transactional data)
Stores (Store locations)

2. Data Relationships and Joins

Establising foreign key relationships:
Customers linked to City (CityID)
City linked to Country (CountryID)
Employees linked to City (CityID)
Sales linked to Customers, Products, and Stores

LEFT JOINs are used to combine information:
Fetching sales data by combining Sales, Customers, and Products
Retrieving customer location data by joining Customers, City, and Country
Linking product categories using Products and Category


3. View Creation (GrocerySalesView)
A view named GrocerySalesView is created to simplify Power BI integration. This view:

Aggregates sales, income, and customer information
Joins relevant tables for easier reporting
Filters necessary columns for visualization


Power BI Dashboard Insights
Once the SQL dataset was prepared, GrocerySalesView was imported into Power BI and created a dashboard with:

Key Metrics
Total Income
Total Customers
Total Sales

Geographical Analysis
Used a map visualization to show income distribution by state.

Sales and Customer Segmentation

Category-wise income breakdown (Treemap)

Customer spending segmentation (Pie Chart: Low, Medium, High)

Trend Analysis
Time series chart for daily income and 14-day rolling average
Monthly income trend comparison with goals



Conclusion: Grocery Sales Performance Analysis
The Grocery Sales Dashboard provides key insights into sales performance, customer behavior, and revenue trends over the first four months of 2018.

1. Overall Business Performance
Total Income: $638M
Total Customers: 98.76K
Total Sales: 965.91K
The business has achieved significant revenue, with a high number of transactions and a broad customer base.

2. Geographical Insights
According to the state map, total income shows that the states with the most income are California, Texas, Ohio and Florida, respectively.
Income is not distributed proportionally by state.
Some geographical regions appear to have fewer transactions, suggesting potential for targeted marketing strategies to boost sales.

3.Sales and Customer Segmentation
The income breakdown by category and product highlights that multiple product categories contribute significantly to revenue, with Confections, Poultry, Dairy, and Beverages being key contributors.
The highest grossing products were "Zucchini - Yellow", "Puree - Passion Fruit", "Beef - Inside Round", "Shrimp - 31/40" and "Tia Maria", all grossing over 2.75 million.
Customer spending segmentation shows that 6.55% of customers are high spenders, while 40.84% are low spenders, and remaining 52.61% are medium spenders.

4. Sales Trend and Monthly Performance
The income trend analysis with a 14-day rolling average shows steady revenue with periodic fluctuations.
The monthly income trend indicates that revenue in April ($158.96M) was slightly below the goal (-0.28%), suggesting a potential seasonal dip or the need for marketing adjustments.
March saw the highest monthly income, showing a positive sales peak.

5. Strategic Recommendations
Boost Sales in Low-Performing Regions: Focus on areas with fewer transactions using localized promotions.
Leverage High-Spending Customers: Implement loyalty programs or personalized promotions to maintain engagement.
Address the April Revenue Dip: Identify potential causes (e.g., seasonality, competitor activity) and implement targeted campaigns.
Expand Best-Selling Product Categories: Increase stock and promotions on top-performing products like Confections, Poultry, and Dairy.
