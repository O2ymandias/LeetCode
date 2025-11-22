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
