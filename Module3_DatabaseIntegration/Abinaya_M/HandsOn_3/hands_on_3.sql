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
JOIN departments d
ON dept_avg.department_id = d.department_id
WHERE dept_avg.avg_salary > 85000;


