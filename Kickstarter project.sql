-- Create the database
CREATE DATABASE kickstarter;

-- Use the database
USE kickstarter;

-- Create the category table
CREATE TABLE category (
    id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Create the creator table
CREATE TABLE crowdfunding_creator (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    chosen_currency varchar(15)
);

-- Create the location table
CREATE TABLE locations (
    id INT PRIMARY KEY,
    displayable_name VARCHAR(255),
    name VARCHAR(255),
    state VARCHAR(100),
    country CHAR(2)
);


-- Create the project table
CREATE TABLE projects (
  ProjectID int DEFAULT NULL,
  state text,
  name text,
  country text,
  creator_id int DEFAULT NULL,
  location_id int DEFAULT NULL,
  category_id int DEFAULT NULL,
  created_at int DEFAULT NULL,
  deadline int DEFAULT NULL,
  updated_at int DEFAULT NULL,
  state_changed_at int DEFAULT NULL,
  successful_at text,
  launched_at int DEFAULT NULL,
  goal int DEFAULT NULL,
  pledged int DEFAULT NULL,
  currency text,
  currency_symbol text,
  usd_pledged int DEFAULT NULL,
  static_usd_rate int DEFAULT NULL,
  backers_count int DEFAULT NULL,
  spotlight text,
  staff_pick text,
  blurb text,
  currency_trailing_code text,
  disable_communication text);
  
  
  
  
-- 1.Converted_the_Date_fields(Epoch Time)to_Natural_Time 

select
    ProjectID, 
    FROM_UNIXTIME(created_at) AS created_date, 
    FROM_UNIXTIME(deadline) AS deadline_date, 
    FROM_UNIXTIME(updated_at) AS updated_date, 
    FROM_UNIXTIME(state_changed_at) AS state_changed_date, 
    FROM_UNIXTIME(successful_at) AS successful_date, 
    FROM_UNIXTIME(launched_at) AS launched_date 
FROM projects;


-- 2.Build a Calendar Table
 
WITH DateRange AS (
    SELECT 
        DATE(FROM_UNIXTIME(MIN(created_at))) AS min_date, 
        DATE(FROM_UNIXTIME(MAX(created_at))) AS max_date 
    FROM projects
)
SELECT 
    DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY) AS calendar_date,
    YEAR(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) AS Year,
    MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) AS MonthNo,
    DATE_FORMAT(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY), '%M') AS MonthFullName,
    CASE 
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) IN (7, 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    DATE_FORMAT(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY), '%Y-%b') AS YearMonth,
    DAYOFWEEK(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) AS WeekdayNo,
    DATE_FORMAT(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY), '%W') AS WeekdayName,
    CASE 
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 4 THEN 'FM1'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 5 THEN 'FM2'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 6 THEN 'FM3'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 7 THEN 'FM4'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 8 THEN 'FM5'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 9 THEN 'FM6'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 10 THEN 'FM7'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 11 THEN 'FM8'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 12 THEN 'FM9'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 1 THEN 'FM10'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) = 2 THEN 'FM11'
        ELSE 'FM12'
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) BETWEEN 4 AND 6 THEN 'FQ-1'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) BETWEEN 7 AND 9 THEN 'FQ-2'
        WHEN MONTH(DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY)) BETWEEN 10 AND 12 THEN 'FQ-3'
        ELSE 'FQ-4'
    END AS FinancialQuarter
FROM numbers
WHERE DATE_ADD((SELECT min_date FROM DateRange), INTERVAL n DAY) <= (SELECT max_date FROM DateRange);

-- 3.Build_the_Data_Model 
ALTER TABLE projects 
ADD CONSTRAINT fk_creator FOREIGN KEY (creator_id) REFERENCES creator(id),
ADD CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES location(id),
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(id);


-- 4.Convert the Goal amount into USD using the Static USD Rate 

select (goal*static_usd_rate) as Goal_Amount from projects;



-- 5.Projects Overview KPI :

-- Total Number of Projects based on outcome 
select state,count(*) as Toatl_Number_of_projects
from projects 
group by state;

-- Total Number of Projects based on Locations
select location.city as location,count(*) as Toatl_Number_of_projects
from projects
join location
on projects.location_id=location.id
group by location.city;

-- Total Number of Projects based on  Category
select category.category_name as Category,count(*) as Toatl_Number_of_projects
from projects
join category
on projects.category_id=category.id
group by Category;

-- 6.Total Number of Projects created by Year , Quarter , Month
SELECT 
EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
EXTRACT(QUARTER FROM FROM_UNIXTIME(created_at)) AS Quarter,
EXTRACT(MONTH FROM FROM_UNIXTIME(created_at)) AS Month,
count(*) as Toatl_Number_of_projects
FROM projects
group by Year,Quarter,Month
order by Year,Quarter,Month ;
    




-- 7.Successful Projects

-- Amount Raised
select name as project_name,usd_pledged as Amount_raised
from projects
where state="successful";
 
-- Number of Backers
select name as project_name,backers_count as Number_of_Backers
from projects
where state="successful";

-- Avg NUmber of Days for successful projects
SELECT AVG(DATEDIFF(FROM_UNIXTIME(deadline), FROM_UNIXTIME(created_at))) AS Avg_Number_of_Days
FROM projects
WHERE state = "successful";




-- 8.Top Successful Projects 

-- Based on Number of Backers
select name as project_name,backers_count as Number_of_Backers
from projects
where state='successful'
order by Number_of_Backers desc
limit 10
 ;
 
-- Based on Amount Raised.

select name as project_name,usd_pledged as Amount_raised
from projects
where state="successful"
order by Amount_raised desc
limit 10;



-- Percentage of Successful Projects overall
SELECT 
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_rate
FROM projects;


-- Percentage of Successful Projects  by Category
SELECT category.category_name,COUNT(CASE WHEN projects.state = 'successful' THEN 1 END) * 100.0 / COUNT(*) AS success_rate
FROM projects
join category on
projects.category_id=category.id
group by category.category_name ;

-- Percentage of Successful Projects by Year , Month etc..
SELECT 
    EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
    EXTRACT(MONTH FROM FROM_UNIXTIME(created_at)) AS Month,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_rate
FROM projects
GROUP BY Year, Month
order by year;

-- Percentage of Successful projects by Goal Range ( decide the range as per your need )

SELECT 
    CASE 
        WHEN goal < 1000 THEN 'Low (<$1000)'
        WHEN goal BETWEEN 1000 AND 10000 THEN 'Medium ($1000-$10,000)'
        ELSE 'High (>$10,000)'
    END AS goal_range,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_rate
FROM projects
GROUP BY goal_range;

