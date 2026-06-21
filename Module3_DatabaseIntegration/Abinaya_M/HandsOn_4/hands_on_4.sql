USE college_db;

-- Task 1

EXPLAIN FORMAT=JSON
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- Q 48: Baseline Performance Analysis

-- EXPLAIN FORMAT=JSON was executed on the query joining
-- students, enrollments, and courses.

-- The query filters students based on enrollment_year = 2022.

-- The execution plan shows nested-loop joins.

-- MySQL uses PRIMARY KEY indexes while joining
-- enrollments with students and courses.

-- Access type 'eq_ref' indicates efficient primary-key lookups.

-- This output serves as the baseline query plan
-- before additional indexes are created for optimization.

EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- Q49

-- The EXPLAIN output shows a Full Table Scan on the students table.
-- This is indicated by type = ALL.

-- MySQL scans all rows in the students table because
-- there is no index on enrollment_year, which is used
-- in the WHERE clause.

-- The enrollments table uses an index lookup
-- (type = ref).

-- The courses table uses a primary key lookup
-- (type = eq_ref).

-- Therefore, the students table is the only table
-- performing a Full Table Scan.


-- Q50
-- Rows examined (estimated by MySQL):

-- students (s): 8 rows
-- enrollments (e): 1 row
-- courses (c): 1 row

-- The students table has the highest number of rows examined
-- because MySQL performs a Full Table Scan (type = ALL).

-- The enrollments table uses an indexed lookup (type = ref).

-- The courses table uses a primary key lookup (type = eq_ref).

-- These values serve as the baseline measurements before
-- additional indexes are created.

