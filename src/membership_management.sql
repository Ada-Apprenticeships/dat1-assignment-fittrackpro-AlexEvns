-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT m.member_id, m.first_name, m.last_name, ms.type, m.join_date
FROM members m 
INNER JOIN memberships ms ON m.member_id = ms.member_id;

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

--Create a temporary table to make it easier to join together the three tables needed
WITH temp_table AS (
  SELECT m.member_id, ms.type
  FROM members m 
  LEFT JOIN memberships ms ON m.member_id = ms.member_id
)

SELECT t.type, ROUND(AVG((JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 * 60)) AS avg_visit_duration_minutes
FROM temp_table t
INNER JOIN attendance a ON t.member_id = a.member_id
GROUP BY t.type;
 


-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT m.member_id, m.first_name, m.last_name, m.email, ms.end_date
FROM members m 
INNER JOIN memberships ms ON m.member_id = ms.member_id
WHERE ms.end_date BETWEEN datetime('now', 'localtime') AND datetime('now', '365 days')