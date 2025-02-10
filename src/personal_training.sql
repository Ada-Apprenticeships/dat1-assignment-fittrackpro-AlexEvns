-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT pts.session_id, m.first_name AS member_name, pts.session_date, pts.start_time, pts.end_time
FROM members m 
INNER JOIN personal_training_sessions pts ON m.member_id = pts.member_id 
WHERE pts.staff_id = (SELECT staff_id
                      FROM staff
                      WHERE first_name == 'Ivy' AND  last_name == 'Irwin')