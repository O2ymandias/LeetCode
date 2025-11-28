-- 1934. Confirmation Rate
/*
SELECT
	s.user_id,
	ROUND( AVG(CASE [action] WHEN 'confirmed' THEN 1.0 ELSE 0.0 END), 2) AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY s.user_id
*/

-- 2356. Number of Unique Subjects Taught by Each Teacher
/*
SELECT
	teacher_id,
	COUNT(DISTINCT subject_id) AS cnt 
FROM Teacher
GROUP BY teacher_id
*/

-- 1141. User Activity for the Past 30 Days I
/*
SELECT
	activity_date AS day,
	COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date <= '2019-07-27' 
AND DATEDIFF(DAY, activity_date, '2019-07-27') < 30
GROUP BY activity_date
*/

-- 1251. Average Selling Price
/*
SELECT 
	p.product_id,
	ISNULL(ROUND(SUM(p.price * u.units) * 1.0 / SUM(u.units) * 1.0, 2), 0) AS  average_price
FROM Prices AS p
LEFT JOIN UnitsSold AS u
ON p.product_id = u.product_id
AND u.purchase_date >= p.start_date
AND u.purchase_date <= p.end_date
GROUP BY p.product_id
*/

-- 1075. Project Employees I
/*
SELECT
	p.project_id,
	ROUND(SUM(e.experience_years) * 1.0 / COUNT(*), 2) AS average_years
FROM Employee AS e
INNER JOIN Project AS p
ON e.employee_id = p.employee_id
GROUP BY p.project_id
*/

-- 1633. Percentage of Users Attended a Contest
/*
SELECT 
	contest_id,
	ROUND(SUM(1.0 / TotalUsers * 100) , 2) AS percentage
FROM
( 
	SELECT COUNT(DISTINCT user_id) AS TotalUsers
	FROM Users
) AS t
CROSS JOIN Register
GROUP BY contest_id
ORDER BY
	percentage DESC,
	contest_id ASC
*/

-- 1211. Queries Quality and Percentage
/*
SELECT
	query_name,
	ROUND(
		AVG(rating * 1.0 / position),
		2) AS quality,
	ROUND(
		AVG(CASE WHEN rating < 3 THEN 1.0 ELSE 0.0 END) * 100,
		2) AS poor_query_percentage
FROM Queries
GROUP BY query_name
*/

-- 1070. Product Sales Analysis III
/*
SELECT
	product_id,
	first_year,
	quantity,
	price
FROM (
	SELECT
		*,
		MIN(year) OVER(PARTITION BY product_id) AS first_year
	FROM Sales
) AS t
WHERE year = first_year
*/

-- 1174. Immediate Food Delivery II
/*
SELECT
	ROUND(
		SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 END)
		/ CAST(COUNT(*) AS FLOAT)
		* 100,
		2) AS immediate_percentage
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(
			PARTITION BY customer_id
			ORDER BY order_date
			) AS [Rank]
	FROM Delivery
) AS t
WHERE [Rank] = 1
*/

-- 550. Game Play Analysis IV
/*
SELECT
	ROUND(COUNT(date_diff) / CAST(COUNT(DISTINCT player_id) AS FLOAT), 2) AS fraction
FROM (
	SELECT
		player_id,
		CASE 
            WHEN 
                DATEDIFF(
                    DAY,
                    event_date,
                    LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date)
                ) = 1
                AND ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) = 1
			THEN 1
        END AS [date_diff]
	FROM Activity
) AS t
*/

-- 596. Classes With at Least 5 Students
/*
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(class) >= 5 
*/
