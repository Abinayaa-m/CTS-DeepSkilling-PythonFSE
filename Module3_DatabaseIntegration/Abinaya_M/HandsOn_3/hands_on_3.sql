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

-- Task 3
DELIMITER $$
CREATE PROCEDURE sp_enroll_student(IN p_student_id INT,IN p_course_id INT,IN p_enrollment_date DATE)
BEGIN
DECLARE v_count INT;
SELECT COUNT(*) INTO v_count FROM enrollments WHERE student_id=p_student_id AND course_id=p_course_id;
IF v_count>0 THEN
  SELECT 'Student is already been enrolled in this course' AS Message;
ELSE 
  INSERT INTO enrollments(student_id,course_id,enrollment_date)VALUES(p_student_id,p_course_id,p_enrollment_date);
  SELECT 'Enrollment Successful' AS Message;
END IF ;
END$$
DELIMITER ;

SHOW PROCEDURE STATUS
WHERE Db='college_db';

CALL sp_enroll_student(3,2,'2025-01-01');
SELECT *FROM enrollments;


CREATE TABLE department_transfer_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE PROCEDURE sp_transfer_student(IN p_student_id INT, IN p_new_department_id INT)
BEGIN
DECLARE v_old_department_id INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  ROLLBACK;
  SELECT 'Transfer Failed. Transaction Rolled Back.' AS Message;
END;

START TRANSACTION;

SELECT department_id INTO v_old_department_id FROM students
WHERE student_id = p_student_id;

UPDATE students SET department_id = p_new_department_id WHERE student_id = p_student_id;

INSERT INTO department_transfer_log(student_id, old_department_id, new_department_id)VALUES(p_student_id, v_old_department_id, p_new_department_id);
COMMIT;
SELECT 'Student Transfer Successful' AS Message;
END$$
DELIMITER ;

CALL sp_transfer_student(1,2);
SELECT * FROM department_transfer_log;

SELECT student_id, department_id FROM students
WHERE student_id = 1;

CALL sp_transfer_student(1,999);
-- ROLL BACK has happend as there is no department_id as 999 so it throwed a FOREIGN KEY error and hence the exit handler got executed and roll back occured and then exit the procedure 

-- Tested transaction by attempting to transfer a student
-- to a non-existent department (department_id = 999).
-- The foreign key constraint caused an SQL exception.
-- The EXIT HANDLER executed ROLLBACK.
-- The student's original department remained unchanged.
-- This confirms that the transaction successfully rolls back
-- all changes when an error occurs.

SELECT * FROM enrollments;
START TRANSACTION;

INSERT INTO enrollments(student_id, course_id, enrollment_date)VALUES(10, 3, CURDATE());
SAVEPOINT sp1;

INSERT INTO enrollments(student_id, course_id, enrollment_date)VALUES(3, 999, CURDATE());
ROLLBACK TO sp1;
COMMIT;
