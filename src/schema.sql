-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );


--DROP TABLES - Helps with testing
DROP TABLE IF EXISTS locations
DROP TABLE IF EXISTS members
DROP TABLE IF EXISTS staff
DROP TABLE IF EXISTS equipment
DROP TABLE IF EXISTS classes
DROP TABLE IF EXISTS class_schedule
DROP TABLE IF EXISTS memberships
DROP TABLE IF EXISTS attendance
DROP TABLE IF EXISTS class_attendance
DROP TABLE IF EXISTS payments
DROP TABLE IF EXISTS personal_training_sessions
DROP TABLE IF EXISTS member_health_metrics
DROP TABLE IF EXISTS equipment_maintenance_log


-- TODO: Create the following tables:
-- 1. locations
CREATE TABLE locations(
  location_id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(15) CHECK(length(phone_number == 8)), --VARCHAR chosen due to phone number inputs containing a '-'
  email VARCHAR(255) CHECK(email LIKE '%@%'),
  opening_hours VARCHAR(15), --Chosen VARCHAR as any date related datatype would not fit the input format
);

-- 2. members
CREATE TABLE members(
  member_id INTEGER PRIMARY KEY NOT NULL,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  email VARCHAR(255) CHECK(email LIKE '%@%'), --Checks to see if it is a valid email format
  phone_number VARCHAR(255) CHECK(length(phone_number == 8)), 
  date_of_birth DATE CHECK(date_of_birth < join_date), 
  join_date DATE CHECK(join_date > date_of_birth),
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(255) CHECK(length(emergency_contact_phone) == 8) -- VARCHAR chosen as phone numbers contain a '-' and would not be excepted by an INTEGER data type
);

-- 3. staff
CREATE TABLE staff(
  staff_id INTEGER PRIMARY KEY NOT NULL,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  email VARCHAR(255) CHECK(email LIKE '%@%'),
  phone_number VARCHAR(255) CHECK(length(phone_number) == 8),
  position VARCHAR(255) CHECK(position == 'Trainer'
                        OR position == 'Manager' 
                        OR position == 'Receptionist'
                        OR position == 'Maintenance'),
  hire_date DATE,
  location_id INTEGER,
  FOREIGN KEY(location_id) REFERENCES locations(location_id) --NOTE: Look into ON DELETE CASCADE
);

-- 4. equipment
CREATE TABLE equipment(
  equipment_id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255),
  type VARCHAR(255),
  purchase_date DATE,
  last_maintenance_date DATE,
  next_maintenance_date DATE,
  location_id INTEGER,
  FOREIGN KEY(location_id) REFERENCES locations(location_id) -- NOTE: Look into ON DELETE CASCADE
);

-- 5. classes
CREATE TABLE classes(
  class_id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255),
  description VARCHAR(255),
  capacity INTEGER,
  duration INTEGER,
  FOREIGN KEY(location_id) REFERENCES locations(location_id) -- NOTE: Look into ON DELETE CASCADE
);

-- 6. class_schedule
CREATE TABLE class_schedule(
  schedule_id INTEGER PRIMARY KEY NOT NULL,
  class_id INTEGER,
  staff_id INTEGER,
  start_time DATETIME,
  end_time DATETIME,
  FOREIGN KEY(class_id) REFERENCES classes(class_id), --NOTE: Look into ON DELETE CASCADE
  FOREIGN KEY(staff_id) REFERENCES staff(staff_id) --NOTE: Look into ON DELETE CASCADE
);

-- 7. memberships
CREATE TABLE memberships(
  membership_id INTEGER PRIMARY KEY NOT NULL,
  member_id INTEGER,
  type VARCHAR(30),
  start_date DATE,
  end_date DATE,
  status VARCHAR(30)
  FOREIGN KEY member_id REFERENCES members(member_id) --NOTE: Look into ON DELETE CASCADE
);

-- 8. attendance
CREATE TABLE attendance(
  attendance_id INTEGER PRIMARY KEY NOT NULL,
  member_id INTEGER,
  location_id INTEGER,
  check_in_time DATETIME,
  check_out_time DATETIME,
  FOREIGN KEY(member_id) REFERENCES members(member_id), --NOTE: Look into ON DELETE CASCADE
  FOREIGN KEY(location_id) REFERENCES locations(location_id) --NOTE: Look into ON DELETE CASCADE
);

-- 9. class_attendance
CREATE TABLE class_attendance(
  class_attendance_id INTEGER PRIMARY KEY NOT NULL,
  schedule_id INTEGER,
  member_id INTEGER,
  attendance_status VARCHAR(50),
  FOREIGN KEY(schedule_id) REFERENCES class_schedule(schedule_id), --NOTE: Look into ON DELETE CASCADE
  FOREIGN KEY(member_id) REFERENCES members(member_id) --NOTE: Look into ON DELETE CASCADE
);

-- 10. payments
CREATE TABLE payments(
  payment_id INTEGER PRIMARY KEY NOT NULL,
  member_id INTEGER,
  amount FLOAT,
  payment_date DATETIME,
  payment_method VARCHAR(255),
  payment_type VARCHAR(255),
  FOREIGN KEY(member_id) REFERENCES members(member_id) --NOTE: Look into ON DELETE CASCADE
);

-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions(
  session_id INTEGER PRIMARY KEY NOT NULL,
  member_id INTEGER,
  staff_id INTEGER,
  session_date DATE,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  notes TEXT,
  FOREIGN KEY(member_id) REFERENCES members(member_id), --NOTE: Look into ON DELETE CASCADE
  FOREIGN KEY(staff_id) REFERENCES staff(staff_id) --NOTE: Look into ON DELETE CASCADE
);

-- 12. member_health_metrics
CREATE TABLE member_health_metrics(
  metric_id INTEGER PRIMARY KEY NOT NULL,
  member_id INTEGER,
  measurement_date DATE,
  weight FLOAT,
  body_fat_percentage FLOAT,
  muscle_mass FLOAT,
  bmi FLOAT,
  FOREIGN KEY(member_id) REFERENCES members(member_id) --NOTE: Look into ON DELETE CASCADE
);

-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log(
  log_id INTEGER PRIMARY KEY NOT NULL,
  equipment_id INTEGER,
  maintenance_date DATE,
  description TEXT,
  staff_id INTEGER,
  FOREIGN KEY(staff_id) REFERENCES staff(staff_id) --NOTE: Look into ON DELETE CASCADE
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal