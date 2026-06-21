USE college_db;

-- Task 1

EXPLAIN FORMAT=JSON
SELECT s.first_name, s.last_name, c.course_name
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
SELECT s.first_name, s.last_name, c.course_name
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

-- Task 2
-- Q51
CREATE INDEX index_enrollment_year
ON students(enrollment_year);

EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e 
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- Q52
CREATE UNIQUE INDEX idx_student_course
ON enrollments(student_id, course_id);

-- Created a composite UNIQUE index on
-- enrollments(student_id, course_id).
-- This ensures that a student cannot be
-- enrolled in the same course more than once.
-- The index also improves lookup performance
-- for queries filtering by student_id and course_id.

-- Q53
CREATE INDEX index_course_code
ON courses(course_code);

-- Q54
EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e 
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- After creating the B-Tree index on students(enrollment_year),
-- the execution plan changed.

-- Baseline Plan:
-- students table -> type = ALL (Full Table Scan)
-- rows examined = 8

-- Optimized Plan:
-- students table -> type = ref
-- key = index_enrollment_year
-- rows examined = 4

-- MySQL now uses the enrollment_year index instead of
-- scanning the entire students table.

-- The query plan improved from a Full Table Scan
-- to an Index Lookup, reducing the number of rows examined
-- and improving query performance.

-- The enrollments and courses tables continue to use
-- indexed lookups (ref and eq_ref respectively).

-- Q55
-- MySQL does not support true partial indexes.

-- In PostgreSQL, the following would be used:
-- CREATE INDEX idx_null_grades
-- ON enrollments(student_id)
-- WHERE grade IS NULL;


