-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT *
FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET phone_number = '555-9876', email = 'emily.jones.updated@email.com'
WHERE member_id = 5;


-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*) AS total_no_members
FROM members;


-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
WITH registered_count AS (
  SELECT m.member_id, m.first_name, m.last_name, COUNT(m.member_id) AS number_registered
  FROM members m 
  LEFT JOIN class_attendance ca ON m.member_id = ca.member_id
  WHERE attendance_status = 'Registered'
  GROUP BY m.member_id
)

SELECT member_id, first_name, last_name, number_registered
FROM registered_count
WHERE number_registered = (SELECT MAX(number_registered) FROM registered_count);



-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
WITH registration_count AS (
  SELECT m.member_id,
         m.first_name, 
         m.last_name, 
         COUNT(ca.member_id) AS number_not_registered
  FROM members m
  LEFT JOIN class_attendance ca ON m.member_id = ca.member_id 
  GROUP BY m.member_id
)

SELECT member_id, 
       first_name, 
       last_name, 
       number_not_registered
FROM registration_count c
WHERE number_not_registered = (SELECT MIN(number_not_registered) FROM registration_count);


-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
WITH temp_table AS (
  SELECT m.member_id, 
         COUNT(m.member_id) AS member_reg_count
  FROM members m 
  INNER JOIN class_attendance a ON m.member_id = a.member_id
  WHERE a.attendance_status = 'Attended'
)

SELECT (t.member_reg_count * 1.0 / COUNT(m.member_id)) * 100 AS attend_percent
FROM temp_table t 
RIGHT JOIN members m ON m.member_id = t.member_id

