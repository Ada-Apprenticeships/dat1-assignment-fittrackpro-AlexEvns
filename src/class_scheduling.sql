-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- Class Scheduling Queries


-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT c.class_id, c.name AS class_name, s.first_name||' '||s.last_name AS instructor_name
FROM classes c 
LEFT JOIN class_schedule cs, staff s ON s.staff_id = cs.staff_id AND cs.class_id = c.class_id;



-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT c.class_id,
       c.name,
       STRFTIME('%R', cs.start_time) AS start_time,
       STRFTIME('%R', cs.end_time) AS end_time,
      (c.capacity - COUNT(ca.attendance_status)) AS avaliable_spots
FROM classes c 
INNER JOIN class_schedule cs, class_attendance ca ON c.class_id = cs.class_id
                                                  AND cs.schedule_id = ca.schedule_id 
WHERE DATE(cs.start_time) = '2025-02-01' AND ca.attendance_status = 'Registered'
GROUP BY c.class_id;


-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (
(
    SELECT schedule_id
    FROM class_schedule
    WHERE class_id = 3
    AND start_time LIKE '2025-02-01%'
),
11,'Registered');


-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance
WHERE member_id = 2 
AND schedule_id = 7;


-- 5. List top 3 most popular classes
-- TODO: Write a query to list top 3 most popular classes
SELECT c.class_id,
       c.name,
       COUNT(ca.attendance_status) AS registration_count
FROM classes c 
INNER JOIN class_schedule cs, class_attendance ca ON c.class_id = cs.class_id
                                                  AND cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status == 'Registered'
GROUP BY c.class_id LIMIT 3;


-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT ROUND(AVG(class_count), 1.0) AS average_classes_per_member
FROM (
    SELECT member_id, COUNT(schedule_id) AS class_count
    FROM class_attendance
    GROUP BY member_id
) 