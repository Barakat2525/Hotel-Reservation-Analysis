--Data Importing done and tried to view the data 
SELECT * FROM [dbo].[hotel_bookings$]
--DATA EXPLORATION
--Having a data overvie by checkking the data for missing values, the data types has been displaed y the sside of the data
SELECT
    SUM(CASE WHEN [dbo].[hotel_bookings$].hotel IS NULL THEN 1 ELSE 0 END) AS hotel_missing,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[lead_time] IS NULL THEN 1 ELSE 0 END) AS lead_time_missing,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[arrival_date_year] IS NULL THEN 1 ELSE 0 END) AS date_missing,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[arrival_date_month] IS NULL THEN 1 ELSE 0 END) AS month_missing,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[adults] IS NULL THEN 1 ELSE 0 END) AS adult_missing_value,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[children] IS NULL THEN 1 ELSE 0 END) AS children_missing_value,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[babies] IS NULL THEN 1 ELSE 0 END) AS babies_missing_value,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[agent] IS NULL THEN 1 ELSE 0 END) AS agent_missing_value,
	SUM(CASE WHEN [dbo].[hotel_bookings$].[company] IS NULL THEN 1 ELSE 0 END) AS company_missing_value
FROM
    [dbo].[hotel_bookings$];
--Only children has missing values
--Generating descriptive statistics for numerical columns 
	SELECT
	COUNT(lead_time) AS count_lead_time, 
    AVG(lead_time) AS mean_lead_time,
    --PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY lead_time) OVER () AS median_lead_time,
    MIN(lead_time) AS min_lead_time,
    MAX(lead_time) AS max_lead_time,
    AVG(stays_in_weekend_nights) AS mean_weekend_nights,
    --PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY stays_in_weekend_nights) OVER () AS median_weekend_nights,
    MIN(stays_in_weekend_nights) AS min_weekend_nights,
    MAX(stays_in_weekend_nights) AS max_weekend_nights,
    AVG(stays_in_week_nights) AS mean_week_nights,
    --PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY stays_in_week_nights) OVER () AS median_week_nights,
    MIN(stays_in_week_nights) AS min_week_nights,
    MAX(stays_in_week_nights) AS max_week_nights
	FROM
    [dbo].[hotel_bookings$];
--Checking for the distribution of the data
	SELECT
    hotel,
    COUNT(*) AS count_per_hotel_type --there are only 2 types of hotel here
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    hotel;
-- Explore distribution of 'meal'
SELECT
    meal,
    COUNT(*) AS count_per_meal --There are 4 types of meal
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    meal;

-- Explore distribution of 'country'
SELECT
    country,
    COUNT(*) AS count_per_country --There are 8 typess of countries
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    country;

-- Explore distribution of 'market_segment'
SELECT
    market_segment,
    COUNT(*) AS count_per_market_segment -- The market is segmented into 8
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    market_segment;
-- Trying to get the cancelation rate and the reason for cancellation, 1 means there was cancellation and no means no
--There is an high cancellation rate of 63%
--
	SELECT
    is_canceled,
    COUNT(*) AS cancellation_count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[hotel_bookings$]) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    is_canceled;

--Cancelation rate by arrival month, trying to analyze how cancellation rates change over time 
	SELECT
    arrival_date_month,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate 
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    arrival_date_month 
ORDER BY
	cancellation_rate DESC;
--Cancellation rate by customer, there are 4 types of customers, the Group customers has the least which is resonable as group dealss with group of people and Transient has the highest
SELECT
    customer_type,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    customer_type
ORDER BY cancellation_rate DESC;	
--Time based analysis by 
SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
	WHERE arrival_date_year = 2016
GROUP BY
    arrival_date_year, arrival_date_month
ORDER BY
    total_reservations DESC, cancellation_rate DESC;

	SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
	WHERE arrival_date_year = 2017
GROUP BY
    arrival_date_year, arrival_date_month
ORDER BY
    total_reservations DESC, cancellation_rate DESC;

	SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
	WHERE arrival_date_year = 2015
GROUP BY
    arrival_date_year, arrival_date_month
ORDER BY
    total_reservations DESC, cancellation_rate DESC;
	--
--CUSTOMER SEGMMENTATION 
--Exploring how customer types affect cancellation
SELECT
    customer_type,
    COUNT(*) AS total_reservations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_reservations,
    CAST(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS cancellation_rate
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    customer_type;
--Analyze Distribution of total_of_special_requests for Different Customer Segments, contract customers makes more  special request
SELECT
    customer_type,
    AVG(total_of_special_requests) AS average_special_requests,
    MIN(total_of_special_requests) AS min_special_requests,
    MAX(total_of_special_requests) AS max_special_requests
FROM
    [dbo].[hotel_bookings$]
GROUP BY
    customer_type;

--SQL ANALYSIS
--Calculate if revenue is ggrowing yearly
--Revenue =(stays_in_weekend_nights + stays_in_week_nights) * adr (CEILING was included to round up the revenue)
--There was an increaase in revenue generated from 2015 to 2016 but a decrease by 2017, this can be due to the high cancellation rate in 2017
SELECT CEILING(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr)) AS Revenue,
       arrival_date_year
FROM dbo.hotel_bookings$
WHERE reservation_status NOT LIKE 'canceled' 
GROUP BY arrival_date_year
ORDER BY arrival_date_year;
--Calculating the number of people visiting the hotel and yearly.(adults, babies and children)
--The reduction in the revenue can also be assoicited with the number of visitors that visited
--Threre was an increase in visitors from 2015- 2016 and a reduction in 2017 
 SELECT SUM(adults + babies + children) AS Visitors, 
       arrival_date_year
FROM dbo.hotel_bookings$
WHERE reservation_status NOT LIKE 'canceled'
GROUP BY arrival_date_year
ORDER BY arrival_date_year;
--Calculating if there is an increase in demand for parking space yearly
--This simplifies an increase in from 2015 - 2016 and a decrease in 2017 , 
--this can be as a result of the decrease in the number of guest that visited the hotel   
SELECT SUM([required_car_parking_spaces]) AS Parking_Space, [arrival_date_year],[hotel]
FROM [dbo].[hotel_bookings$]
WHERE reservation_status NOT LIKE 'canceled'
GROUP BY arrival_date_year, hotel
ORDER BY arrival_date_year;
--Investigating more on the causes of an increase in cancellation rate 
--Cancellaton Rate by Lead time
--The cancellation rate increases as lead time increases, 
--it suggests that customers are more likely to cancel reservations when they are made well in advance,
--which could be due to changing plans, unforeseen circumstances, or other factors.
SELECT lead_time, CEILING(AVG(is_canceled)) AS cancellation_rate, arrival_date_year
FROM [dbo].[hotel_bookings$]
GROUP BY lead_time, arrival_date_year
ORDER BY lead_time;
--Cancellation Rate by Deposit Type
--As expected the Refundable deposit has the least cancellation rate, this suggests that customers are less likely to cancel when they can get their deposit back.
--The Non-Refund has the highest cancellation rate of 1, this might indicate a dissatisfaction in the service rendered by the hotel or unforseen circumstances    
--There is a a higher cancelation rate with City Hotel.   
SELECT deposit_type, AVG(is_canceled) AS cancellation_rate, hotel
FROM [dbo].[hotel_bookings$]
GROUP BY deposit_type, hotel
ORDER BY  cancellation_rate;
--Cancellation Rate by Room Type
--Trying to see the room type wiith the higghest cancellation rate 
--The H room type has the higghest cancellation rate, this could be due to the amenties provided during the stay of a visitor
SELECT reserved_room_type, AVG(is_canceled) AS cancellation_rate
FROM [dbo].[hotel_bookings$]
GROUP BY reserved_room_type
ORDER BY reserved_room_type DESC;
--Cancellation Rate by Customer Type
--This indicate the transient type has the highest cancellation rate of 0.4, while the group has the least of 0.1,
--which is reasonable as the transient customer is like an indivual unlike the group that involves diffent people  
SELECT customer_type, AVG(is_canceled) AS cancellation_rate
FROM [dbo].[hotel_bookings$]
GROUP BY customer_type
ORDER BY cancellation_rate DESC;  
--Cancellation Rate by Market Segment
--Here the market segment with the least cancellation rate can be offfered discount so as to work harder to bring in more customers to enerate revenue
SELECT market_segment, AVG(is_canceled) AS cancellation_rate
FROM [dbo].[hotel_bookings$]
GROUP BY market_segment
ORDER BY cancellation_rate DESC;
--revenue by market segment
--The Online TA generate the highest revenue, discount can also be given to these agents to bring in more customers  
SELECT CEILING(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr)) AS Revenue,
       market_segment
FROM dbo.hotel_bookings$
WHERE reservation_status NOT LIKE 'canceled' 
GROUP BY market_segment
ORDER BY Revenue DESC;



