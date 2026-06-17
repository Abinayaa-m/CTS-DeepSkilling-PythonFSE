-- TASK 1: Create the Database and Tables

CREATE DATABASE college_db;
USE college_db;
CREATE TABLE departments(
department_id INT PRIMARY KEY AUTO_INCREMENT,
dept_name VARCHAR(100) NOT NULL,
hod_name VARCHAR(100),
budget DECIMAL(12,2)
);
CREATE TABLE students(
student_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
date_of_birth DATE,
department_id INT,
CONSTRAINT FK_deptid FOREIGN KEY(department_id) REFERENCES departments(department_id),
enrollment_year INT
);

CREATE TABLE courses(
course_id INT PRIMARY KEY AUTO_INCREMENT,
course_name VARCHAR(150) NOT NULL,
course_code VARCHAR(20),
credits INT,
department_id INT,
CONSTRAINT FK_deptidcourse FOREIGN KEY(department_id) REFERENCES departments(department_id)
);

CREATE TABLE enrollments(
enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
student_id INT,
CONSTRAINT FK_stuidenrol FOREIGN KEY(student_id) REFERENCES students(student_id),
course_id INT,
CONSTRAINT FK_couridenrol FOREIGN KEY(course_id) REFERENCES courses(course_id),
enrollment_date DATE,
grade CHAR(2)
);
CREATE TABLE professors(
professor_id INT PRIMARY KEY AUTO_INCREMENT,
prof_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
department_id INT,
CONSTRAINT FK_deptidprof FOREIGN KEY(department_id) REFERENCES departments(department_id),
salary DECIMAL(10,2)
);
SHOW TABLES;
DESCRIBE students;
DESCRIBE courses;
DESCRIBE departments;
DESCRIBE enrollments;
DESCRIBE professors;

INSERT INTO departments (dept_name, hod_name, budget) VALUES
  ('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
  ('Electronics', 'Dr. Priya Nair', 620000.00),
  ('Mechanical', 'Dr. Suresh Iyer', 540000.00),
  ('Civil', 'Dr. Ananya Sharma', 430000.00);
  
INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, 
enrollment_year) VALUES
  ('Arjun',  'Mehta',    'arjun.mehta@college.edu',    '2003-04-12', 1, 2022),
  ('Priya',  'Suresh',   'priya.suresh@college.edu',   '2003-07-25', 1, 2022),
  ('Rohan',  'Verma',    'rohan.verma@college.edu',    '2002-11-08', 2, 2021),
  ('Sneha',  'Patel',    'sneha.patel@college.edu',    '2004-01-30', 3, 2023),
  ('Vikram', 'Das',      'vikram.das@college.edu',     '2003-09-14', 1, 2022),
  ('Kavya',  'Menon',    'kavya.menon@college.edu',    '2002-05-17', 2, 2021),
  ('Aditya', 'Singh',    'aditya.singh@college.edu',   '2004-03-22', 4, 2023),
  ('Deepika','Rao',      'deepika.rao@college.edu',    '2003-08-09', 1, 2022);

INSERT INTO courses (course_name, course_code, credits, department_id) VALUES
  ('Data Structures & Algorithms', 'CS101', 4, 1),
  ('Database Management Systems',  'CS102', 3, 1),
  ('Object Oriented Programming',  'CS103', 4, 1),
  ('Circuit Theory',               'EC101', 3, 2),
  ('Thermodynamics',               'ME101', 3, 3);
  
  INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
  (1, 1, '2022-07-01', 'A'), (1, 2, '2022-07-01', 'B'),
  (2, 1, '2022-07-01', 'B'), (2, 3, '2022-07-01', 'A'),
  (3, 4, '2021-07-01', 'A'), (4, 5, '2023-07-01', NULL),
  (5, 1, '2022-07-01', 'C'), (5, 2, '2022-07-01', 'A'),
  (6, 4, '2021-07-01', 'B'), (7, 5, '2023-07-01', NULL),
  (8, 1, '2022-07-01', 'A'), (8, 3, '2022-07-01', 'B');
  
  INSERT INTO professors (prof_name, email, department_id, salary) VALUES
  ('Dr. Anand Krishnan',  'anand.k@college.edu',   1, 95000.00),
  ('Dr. Meena Pillai',    'meena.p@college.edu',   1, 88000.00),
  ('Dr. Sunil Rajan',     'sunil.r@college.edu',   2, 82000.00),
  ('Dr. Latha Gopal',     'latha.g@college.edu',   3, 79000.00),
  ('Dr. Kartik Bose',     'kartik.b@college.edu',  4, 76000.00);
  
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM departments;
SELECT * FROM enrollments;
SELECT * FROM professors;

-- TASK 2 : NORMALIZATION ANALYSIS

-- 1NF:
-- All tables satisfy First Normal Form.
-- Every column contains atomic (single) values.
-- No column stores multiple values in one field.

-- 2NF:
-- All tables satisfy Second Normal Form.
-- In the enrollments table, grade and enrollment_date
-- depend on the complete student-course relationship.
-- They do not depend only on student_id or only on course_id.
-- Therefore no partial dependency exists.

-- 3NF:
-- All tables satisfy Third Normal Form.
-- No transitive dependencies exist.
-- The students table stores only department_id.
-- Department details such as dept_name are stored
-- separately in the departments table.
-- Storing dept_name inside students would violate 3NF.

-- Enrollments Table Analysis:
-- grade and enrollment_date depend directly on the
-- enrollment record.
-- They do not depend on any other non-key column.
-- Therefore the enrollments table satisfies 3NF.

-- TASK 3: Alter and Extend the Schema

ALTER TABLE students
ADD COLUMN phone_number VARCHAR(15);
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'college_db'
AND table_name = 'students';

ALTER TABLE courses
ADD COLUMN max_seats INT DEFAULT 60;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'college_db'
AND table_name = 'courses';

ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (
grade IN ('A','B','C','D','F')
OR grade IS NULL
);

ALTER TABLE departments
CHANGE COLUMN hod_name head_of_dept VARCHAR(100);
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'college_db'
AND table_name = 'departments';

ALTER TABLE students
DROP COLUMN phone_number;
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'college_db'
AND table_name = 'students';



