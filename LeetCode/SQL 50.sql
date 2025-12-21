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

-- 1729. Find Followers Count
/*
SELECT 
	user_id,
	COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id 
*/

-- 619. Biggest Single Number
/*
SELECT TOP(1) CASE WHEN COUNT(num) = 1 THEN num ELSE NULL END AS num
FROM MyNumbers
GROUP BY num
ORDER BY num DESC
*/

-- 1045. Customers Who Bought All Products
/*
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)
*/

-- 1731. The Number of Employees Which Report to Each Employee
/*
SELECT
	m.employee_id,
	m.name,
	COUNT(*) AS reports_count,
	ROUND(AVG(CAST(e.age AS FLOAT)), 0) AS average_age
FROM Employees AS e
INNER JOIN Employees AS m
ON m.employee_id = e.reports_to
GROUP BY m.employee_id, m.name
ORDER BY m.employee_id
*/

-- 1789. Primary Department for Each Employee
/*
SELECT
	employee_id,
	department_id
FROM (
	SELECT
		employee_id,
		department_id,
		CASE 
			WHEN COUNT(*) OVER(PARTITION BY employee_id) = 1 THEN 'Y'
			ELSE primary_flag
		END AS modified_primary_flag
	FROM Employee
) AS t
WHERE modified_primary_flag = 'Y'
*/

-- 610. Triangle Judgement
/*
SELECT
	*,
	CASE
		WHEN x + y > z
		AND x + z > y
		AND y + z > x
		THEN 'Yes'
		ELSE 'No'
	END AS triangle 
FROM Triangle
*/

-- 180. Consecutive Numbers
/*
SELECT DISTINCT num AS ConsecutiveNums
FROM (
	SELECT
		*,
		CASE
			WHEN id - LAG(id) OVER(PARTITION BY num ORDER BY num) = 1
			AND LAG(id) OVER(PARTITION BY num ORDER BY num) - LAG(id, 2) OVER(PARTITION BY num ORDER BY num) = 1
			THEN 1
			ELSE 0
		END AS isConsecutive
	FROM Logs
) AS t
WHERE isConsecutive = 1
*/

-- 1164. Product Price at a Given Date
/*
DECLARE @targetDate DATE;
DECLARE @initialPrice INT;

SET @targetDate = '2019-08-16';
SET @initialPrice = 10;

WITH CTE_lastPrices AS (
	SELECT DISTINCT
		product_id,
		LAST_VALUE(new_price) OVER(
			PARTITION BY product_id
			ORDER BY change_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
		) AS last_price
	FROM Products
	WHERE change_date <= @targetDate
)
SELECT DISTINCT
	p.product_id,
	ISNULL(lp.last_price, @initialPrice) AS price
FROM Products AS p
LEFT JOIN CTE_lastPrices as lp
ON p.product_id = lp.product_id
*/

-- 1204. Last Person to Fit in the Bus
/*
DECLARE @weightLimit INT;
SET @weightLimit = 1000

SELECT TOP(1) person_name
FROM (
	SELECT
		person_name,
		SUM(weight) OVER(
			ORDER BY turn
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS TotalWeight
	FROM Queue
) AS temp
WHERE TotalWeight <= @weightLimit
ORDER BY TotalWeight DESC
*/

-- 1907. Count Salary Categories
/*
WITH CTE_CategorizedAccounts AS (
	SELECT
		*,
		CASE
			WHEN income < 20000 THEN 'Low Salary'
			WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
			ELSE 'High Salary'
		END AS category 
	FROM Accounts
	UNION ALL
	SELECT NULL, NULL, 'Low Salary'
	UNION ALL 
	SELECT NULL, NULL, 'Average Salary'
	UNION ALL
	SELECT NULL, NULL, 'High Salary'
)
SELECT
	category,
	COUNT(account_id) AS accounts_count
FROM CTE_CategorizedAccounts
GROUP BY category
*/

-- 1978. Employees Whose Manager Left the Company
/*
DECLARE @limitSalary INT;
SET @limitSalary = 30000;

SELECT emp.employee_id
FROM Employees AS emp
WHERE salary < @limitSalary
AND emp.manager_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM Employees AS checkEmp
	WHERE emp.manager_id = checkEmp.employee_id
)
ORDER BY employee_id
*/

-- 626. Exchange Seats
/*
SELECT
	id,
	CASE
		WHEN id % 2 = 0 THEN LAG(student) OVER(ORDER BY id)
		ELSE ISNULL(LEAD(student) OVER(ORDER BY id), student)
	END AS student
FROM Seat
ORDER BY id
*/

-- 1341. Movie Rating
/*
WITH CTE_top_user AS (
	SELECT TOP(1) u.name
	FROM Users AS u
	LEFT JOIN MovieRating AS mr
		ON u.user_id = mr.user_id
	GROUP BY u.name
	ORDER BY 
		COUNT(*) DESC,
		name ASC
),
CTE_top_movie AS (
	SELECT TOP(1) m.title
	FROM Movies AS m
	LEFT JOIN MovieRating AS mr
		ON m.movie_id = mr.movie_id
	WHERE MONTH(created_at) = 2
	AND YEAR(created_at) = 2020
	GROUP BY m.title
	ORDER BY 
		AVG(CAST(rating AS FLOAT)) DESC,
		m.title ASC	
)
SELECT name AS results
FROM CTE_top_user
UNION ALL
SELECT title
FROM CTE_top_movie
*/

-- 1321. Restaurant Growth
/*
WITH CTE_AmountPerDay AS (
	SELECT
		visited_on,
		CAST(SUM(amount) AS FLOAT) AS AmountPerDay
	FROM Customer
	GROUP BY visited_on
),
CTE_Window7 AS (
	SELECT
		visited_on,

		SUM(AmountPerDay) OVER (
			ORDER BY visited_on
			ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
		) AS amount,

		ROUND (
			AVG(AmountPerDay) OVER (
				ORDER BY visited_on
				ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
			), 2
		) AS average_amount,

		LAG(visited_on, 6) OVER(
			ORDER BY visited_on
		) AS Window7

	FROM CTE_AmountPerDay
)
SELECT
	visited_on,
	amount,
	average_amount
FROM CTE_Window7
WHERE Window7 IS NOT NULL
ORDER BY visited_on
*/

-- 602. Friend Requests II: Who Has the Most Friends
/*
WITH CTE_friends AS (
	SELECT requester_id AS id
	FROM RequestAccepted
	UNION ALL
	SELECT accepter_id 
	FROM RequestAccepted
)
SELECT TOP 1
	id,
	COUNT(*) AS num
FROM CTE_friends
GROUP BY id
ORDER BY num DESC
*/

-- 585. Investments in 2016
/*
SELECT ROUND (SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance 
WHERE pid IN (
	SELECT DISTINCT i1.pid
	FROM Insurance AS i1
	JOIN Insurance AS i2
		ON i1.pid != i2.pid
		AND i1.tiv_2015 = i2.tiv_2015
)
AND pid NOT IN (
	SELECT i1.pid
	FROM Insurance AS i1
	JOIN Insurance AS i2
		ON i1.pid != i2.pid
		AND i1.lat = i2.lat
		AND i1.lon = i2.lon
)

-- OR

SELECT ROUND (SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance AS i
WHERE tiv_2015 IN (
	SELECT
		tiv_2015
	FROM Insurance
	GROUP BY tiv_2015
	HAVING COUNT(*) > 1
)
AND NOT EXISTS (
	SELECT 1
	FROM Insurance AS ck
	WHERE i.pid != ck.pid
	AND i.lat = ck.lat
	AND i.lon = ck.lon
)
*/

-- 1667. Fix Names in a Table
/*
SELECT
	user_id,
	CONCAT(
		SUBSTRING(UPPER(name), 1, 1),
		SUBSTRING(LOWER(name), 2, LEN(name))
	) AS name
FROM Users
ORDER BY user_id
*/

-- 1527. Patients With a Condition
/*
SELECT *
FROM Patients
WHERE conditions LIKE '% DIAB1%'
OR conditions LIKE 'DIAB1%'
*/

-- 196. Delete Duplicate Emails
/*
WITH CTE_Duplicates AS (
	SELECT 
		id,
		ROW_NUMBER() OVER(
			PARTITION BY Email
			ORDER BY id
		) AS RN
	FROM Person AS p
	WHERE EXISTS (
		SELECT 1
		FROM Person AS ck
		WHERE p.Id != ck.Id
		AND p.Email = ck.Email
	)
),
CTE_ShouldRemove AS (
	SELECT id
	FROM CTE_Duplicates
	WHERE RN != 1
)
DELETE FROM Person
WHERE Id IN (SELECT * FROM CTE_ShouldRemove)
*/