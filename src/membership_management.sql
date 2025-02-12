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
INNER JOIN memberships ms ON m.member_id = ms.member_id

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year