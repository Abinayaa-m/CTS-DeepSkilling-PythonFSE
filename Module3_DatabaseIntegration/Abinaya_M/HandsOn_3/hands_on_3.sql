-- Task 1
USE college_db;

SELECT student_id, COUNT(*) AS total_courses
FROM enrollments
GROUP BY student_id
HAVING COUNT(*) >
(
  SELECT AVG(total_courses)
  FROM
  (
	 SELECT COUNT(*) AS total_courses
	 FROM enrollments
	 GROUP BY student_id
  ) t
);

SELECT c.course_id,c.course_name
FROM courses c
WHERE NOT EXISTS
(
    SELECT *
    FROM enrollments e
    WHERE c.course_id = e.course_id
    AND e.grade <> 'A'
);

SELECT d.dept_name, p1.prof_name, p1.salary
FROM professors p1
INNER JOIN departments AS d
ON d.department_id=p1.department_id
WHERE p1.salary =
(
    SELECT MAX(p2.salary)
    FROM professors p2
    WHERE p2.department_id = p1.department_id
);

SELECT d.dept_name,dept_avg.avg_salary
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM professors
    GROUP BY department_id
) dept_avg
JOIN departments AS d
ON dept_avg.department_id = d.department_id
WHERE dept_avg.avg_salary > 85000;

-- Task 2
CREATE VIEW vw_student_enrollment_summary AS
SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name, d.dept_name, COUNT(e.course_id) AS total_courses,
AVG(
	CASE
		WHEN e.grade = 'A' THEN 4
		WHEN e.grade = 'B' THEN 3
		WHEN e.grade = 'C' THEN 2
		WHEN e.grade = 'D' THEN 1
		WHEN e.grade = 'F' THEN 0
	END
) AS GPA
FROM students s
JOIN departments d
ON s.department_id = d.department_id
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name, d.dept_name;

SELECT * FROM vw_student_enrollment_summary;


CREATE VIEW vw_course_stats AS
SELECT c.course_name, c.course_code,COUNT(e.student_id) AS tot_enrollments,
AVG(
	CASE
		WHEN e.grade = 'A' THEN 4
		WHEN e.grade = 'B' THEN 3
		WHEN e.grade = 'C' THEN 2
		WHEN e.grade = 'D' THEN 1
		WHEN e.grade = 'F' THEN 0
	END
) AS avg_gpa
FROM courses AS c
INNER JOIN enrollments AS e
ON c.course_id=e.course_id
GROUP BY c.course_id, c.course_name, c.course_code;

SELECT * FROM vw_course_stats;

-- Query vw_student_enrollment_summary to find students with GPA above 3.0

SELECT student_id, student_name FROM vw_student_enrollment_summary WHERE GPA > 3.0;

UPDATE vw_student_enrollment_summary
SET GPA = 4.0
WHERE student_id=1;
-- ERROR GOT(Error Code: 1288. The target table vw_student_enrollment_summary of the UPDATE is not updatable)

-- Attempted to update vw_student_enrollment_summary.
-- The update failed because the view is based on multiple tables.
-- The view contains JOINs, GROUP BY, COUNT(), and AVG().
-- GPA and total_courses are derived values, not actual stored columns.
-- MySQL cannot determine which underlying table rows should be modified.
-- Therefore, the view is generally not updatable.

DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;

CREATE VIEW vw_student_enrollment_summary
AS
SELECT * FROM students WHERE enrollment_year=2022
WITH CHECK OPTION;

SELECT * FROM vw_student_enrollment_summary;

UPDATE vw_student_enrollment_summary SET enrollment_year=2023 WHERE student_id=1;
-- ERROR GOT because the update data enrollment_year=2023 failed the condition given by WHERE clause in the view created


