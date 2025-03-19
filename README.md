Grocery Sales Analysis and Dashboard

SQL Operations and Data Processing

1. Database and Table Creation

Created the GrocerySales database and structured it with multiple tables, including:

Category (Product categories)

Country and City (Geographical data)

Customers (Customer details)

Employees (Staff information)

Products (Product details with prices)

Sales (Transactional data)

Stores (Store locations)

2. Data Relationships and Joins

Established foreign key relationships:

Customers linked to City (CityID)

City linked to Country (CountryID)

Employees linked to City (CityID)

Sales linked to Customers, Products, and Stores

Used LEFT JOINs to combine information:

Fetching sales data by combining Sales, Customers, and Products

Retrieving customer location data by joining Customers, City, and Country

Linking product categories using Products and Category

3. View Creation - GrocerySalesView

Created a view named GrocerySalesView to simplify Power BI integration. This view:

Aggregates sales, income, and customer information

Joins relevant tables for easier reporting

Filters necessary columns for visualization

Power BI Dashboard Insights

Once the SQL dataset was prepared, GrocerySalesView was imported into Power BI to create an interactive dashboard.

Key Metrics

Total Income: $638M

Total Customers: 98.76K

Total Sales: 965.91K

Geographical Analysis

Used a map visualization to show income distribution by state.

Sales and Customer Segmentation

Category-wise income breakdown (Treemap visualization)

Customer spending segmentation (Pie Chart - Low, Medium, High)

Trend Analysis

Time series chart for daily income and 14-day rolling average

Monthly income trend comparison with goals

Conclusion: Grocery Sales Performance Analysis

1. Overall Business Performance

Total Income: $638M

Total Customers: 98.76K

Total Sales: 965.91K

The business has achieved significant revenue, with a high number of transactions and a broad customer base.

2. Geographical Insights

The highest-income states are California, Texas, Ohio, and Florida.

Income is not proportionally distributed by state.

Some regions have fewer transactions, suggesting potential for targeted marketing strategies to boost sales.

3. Sales and Customer Segmentation

Top Revenue-Generating Categories:

Confections, Poultry, Dairy, and Beverages

Best-Selling Products (each grossing over $2.75M):

Zucchini - Yellow

Puree - Passion Fruit

Beef - Inside Round

Shrimp - 31/40

Tia Maria

Customer Spending Segmentation:

6.55% High Spenders

40.84% Low Spenders

52.61% Medium Spenders

4. Sales Trend and Monthly Performance

The 14-day rolling average shows steady revenue with periodic fluctuations.

April's revenue ($158.96M) was slightly below the goal (-0.28%), indicating a seasonal dip or need for marketing adjustments.

March had the highest monthly income, showing a strong sales peak.

5. Strategic Recommendations

✅ Boost Sales in Low-Performing Regions: Focus on areas with fewer transactions using localized promotions.
✅ Leverage High-Spending Customers: Implement loyalty programs or personalized promotions to maintain engagement.
✅ Address the April Revenue Dip: Identify potential causes (seasonality, competitor activity) and implement targeted campaigns.
✅ Expand Best-Selling Product Categories: Increase stock and promotions on top-performing products like Confections, Poultry, and Dairy.
