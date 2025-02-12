-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
SELECT equipment_id, name, next_maintenance_date
FROM equipment
WHERE next_maintenance_date BETWEEN datetime('now', 'localtime') AND datetime('now', '30 days');
-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
SELECT type AS equipment_type, COUNT(equipment_id) AS count
FROM equipment
GROUP BY equipment_type;

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)
SELECT type as equipment_type, (JULIANDAY(CURRENT_DATE) - JULIANDAY(purchase_date)) AS avg_age_days
FROM equipment
GROUP BY equipment_type
HAVING AVG(avg_age_days);