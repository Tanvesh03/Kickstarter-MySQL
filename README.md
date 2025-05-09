📊 Kickstarter SQL Analysis
This project analyzes Kickstarter crowdfunding data using SQL. It focuses on data modeling, date conversion, calendar generation, and extracting valuable KPIs and trends to understand the success factors behind crowdfunding projects.

🗂️ Dataset Structure
The project uses the following tables:
category: Contains project category information.
crowdfunding_creator: Information about project creators.
locations: Geographical information (city, state, country).
projects: Contains detailed information about Kickstarter projects.

🧱 SQL Components
1. Database & Table Creation
Created the kickstarter database.
Defined schema for category, crowdfunding_creator, locations, and projects tables.
2. Date Conversion
Converted epoch timestamps (created_at, deadline, etc.) to readable date formats using FROM_UNIXTIME().
3. Calendar Table
Built a dynamic calendar table using a numbers table and SQL date functions.
Extracted useful date dimensions: Year, Month, Quarter, Financial Month/Quarter, Weekday, etc.
4. Data Modeling
Established foreign key relationships between projects and supporting tables (category, creator, location).
5. Currency Conversion
Calculated project goals in USD using static_usd_rate.

📈 KPI Dashboards and Insights
🔹 Project Overview
Total projects grouped by:
State (e.g., successful, failed)
Location (city)
Category

🔹 Time-based Trends
Number of projects created by:
Year
Quarter
Month

🔹 Successful Projects Analysis
Listed:
Amount raised (USD)
Number of backers
Average campaign duration

🔹 Top Performing Projects
Top 10 successful projects by:
Backers
Amount Raised

🔹 Success Rate Analysis
Overall success percentage
Success rates by:
Category
Year & Month
Goal Ranges (Low, Medium, High)

