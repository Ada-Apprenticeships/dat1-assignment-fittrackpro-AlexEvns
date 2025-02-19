-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES 
(7, 1, datetime('now'));

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT STRFTIME('%F', check_in_time) AS vist_date,
       STRFTIME('%R', check_in_time) AS check_in_time,
       STRFTIME('%R', check_out_time) AS check_out_time
FROM attendance a 
INNER JOIN members m ON m.member_id = a.member_id AND m.member_id = '5';

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT
  CASE CAST (STRFTIME('%w', check_in_time) AS integer)
  WHEN 0 THEN 'Sunday'
  WHEN 1 THEN 'Monday'
  WHEN 2 THEN 'Tuesday'
  WHEN 3 THEN 'Wednesday'
  WHEN 4 THEN 'Thursday'
  WHEN 5 THEN 'Friday'
  ELSE 'Saturday' END AS weekday,
  COUNT(attendance_id) AS visit_count
FROM attendance
GROUP BY weekday
ORDER BY visit_count DESC LIMIT 1;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
WITH temp_table AS 
(
  SELECT COUNT(attendance_id) AS attendence_count, location_id
  FROM attendance
  GROUP BY STRFTIME('%d', check_in_time)
)

SELECT l.name, t.attendence_count
FROM temp_table t 
INNER JOIN locations l ON l.location_id = t.location_id
GROUP BY l.name
HAVING AVG(t.attendence_count)