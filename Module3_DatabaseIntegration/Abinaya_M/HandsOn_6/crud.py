"""
Task 3(Q90): N+1 Problem Analysis

Without joinedload():
---------------------
1 query fetched enrollments.
Additional queries were executed for each student
and course record accessed through relationships.
This resulted in the N+1 query problem.

With joinedload():
------------------
Enrollment, Student, and Course data were loaded
together using LEFT OUTER JOIN.

Only one SQL query was executed.

Result:
- Same output
- Fewer database round trips
- Better performance
"""
from sqlalchemy.orm import sessionmaker, joinedload
from models import (engine, Department, Student, Course, Enrollment)

Session = sessionmaker(bind=engine)
session = Session()
print("Session opened successfully")

dept1 = Department(dept_name="Computer Science", head_of_dept="Dr. Kumar", budget=500000)
dept2 = Department(dept_name="Information Technology", head_of_dept="Dr. Priya",budget=400000)
dept3 = Department(dept_name="Electronics", head_of_dept="Dr. Ravi",budget=450000)

session.add_all([dept1, dept2, dept3])
session.commit()

student1 = Student(first_name="Arjun", last_name="Mehta", email="arjun@gmail.com", department_id=dept1.department_id, enrollment_year=2022)
student2 = Student(first_name="Priya", last_name="Suresh", email="priya@gmail.com", department_id=dept1.department_id, enrollment_year=2022)
student3 = Student(first_name="Rohan", last_name="Verma", email="rohan@gmail.com", department_id=dept2.department_id, enrollment_year=2023)
student4 = Student(first_name="Kavya", last_name="Menon", email="kavya@gmail.com", department_id=dept2.department_id, enrollment_year=2023)
student5 = Student(first_name="Vikram", last_name="Das", email="vikram@gmail.com", department_id=dept3.department_id, enrollment_year=2022)

session.add_all([student1, student2, student3, student4, student5])
session.commit()

course1 = Course(course_name="Database Management Systems", course_code="CS101", credits=4,department_id=1)
course2 = Course(course_name="Data Structures", course_code="CS102", credits=3, department_id=1)
course3 = Course(course_name="Operating Systems", course_code="CS103", credits=4, department_id=1)

session.add_all([course1, course2, course3])
session.commit()

enroll1 = Enrollment(student_id=1, course_id=1, grade="A")
enroll2 = Enrollment(student_id=1, course_id=2, grade="B")
enroll3 = Enrollment(student_id=2, course_id=1, grade="A")
enroll4 = Enrollment(student_id=3, course_id=3, grade="B")

session.add_all([enroll1, enroll2, enroll3, enroll4])
session.commit()


students = (session.query(Student).join(Department).filter(Department.dept_name == "Computer Science").all())
for student in students:
    print(
        student.student_id,
        student.first_name,
        student.last_name
    )
    

enrollments = session.query(Enrollment).all()
for enrollment in enrollments:

    print(
        enrollment.student.first_name,
        enrollment.student.last_name,
        "->",
        enrollment.course.course_name
    )

student = (session.query(Student).filter(Student.email == "arjun@gmail.com").first())
student.enrollment_year = 2024
session.commit()
print("Student updated successfully")

enrollments= (session.query(Enrollment).filter(Enrollment.enrollment_id == 1).first())
session.delete(enrollments)
session.commit()
print("Enrollment deleted successfully")

enrollments = session.query(Enrollment).all()
for enrollment in enrollments:
    print(enrollment.enrollment_id)

enrollment = (
    session.query(Enrollment)
    .filter(Enrollment.enrollment_id == 1)
    .first()
)

print(enrollment)


#Q87
# N+1 Problem Observed
# 1 query fetched enrollments
# Additional queries fetched students and courses
# Total queries increased with number of enrollments

#Q88
enrollments = (session.query(Enrollment).options(joinedload(Enrollment.student),joinedload(Enrollment.course)).all())

#Q89
# Query Count After joinedload()

# SQLAlchemy executed only 1 SQL query.
# The query used LEFT OUTER JOIN to fetch:
# 1. Enrollment data
# 2. Student data
# 3. Course data
# Therefore the N+1 problem was eliminated.

#Q90
# Django ORM equivalent of SQLAlchemy joinedload()
"""
enrollments = Enrollment.objects.select_related(
    'student',
    'course'
).all()
"""