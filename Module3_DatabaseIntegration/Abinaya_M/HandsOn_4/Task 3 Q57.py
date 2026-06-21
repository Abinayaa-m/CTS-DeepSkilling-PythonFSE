import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234",
    database="college_db"
)

cursor = conn.cursor()

query_count = 0

cursor.execute("""
SELECT e.enrollment_id,
       e.student_id,
       e.course_id,
       e.grade,
       s.first_name,
       s.last_name
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
""")

results = cursor.fetchall()
query_count += 1

for row in results:
    print(
        f"Enrollment ID: {row[0]}, "
        f"Student ID: {row[1]}, "
        f"Course ID: {row[2]}, "
        f"Grade: {row[3]}, "
        f"Name: {row[4]} {row[5]}"
    )

print("Total Queries Executed:", query_count)
cursor.close()
conn.close()

"""
OUTPUT:
Enrollment ID: 1, Student ID: 1, Course ID: 1, Grade: A, Name: Arjun Mehta
Enrollment ID: 2, Student ID: 1, Course ID: 2, Grade: B, Name: Arjun Mehta
Enrollment ID: 3, Student ID: 2, Course ID: 1, Grade: B, Name: Priya Suresh
Enrollment ID: 4, Student ID: 2, Course ID: 3, Grade: A, Name: Priya Suresh
Enrollment ID: 5, Student ID: 3, Course ID: 4, Grade: A, Name: Rohan Verma
Enrollment ID: 7, Student ID: 5, Course ID: 1, Grade: B, Name: Vikram Das
Enrollment ID: 8, Student ID: 5, Course ID: 2, Grade: A, Name: Vikram Das
Enrollment ID: 9, Student ID: 6, Course ID: 4, Grade: B, Name: Kavya Menon
Enrollment ID: 11, Student ID: 8, Course ID: 1, Grade: A, Name: Deepika Rao
Enrollment ID: 12, Student ID: 8, Course ID: 3, Grade: B, Name: Deepika Rao
Enrollment ID: 13, Student ID: 3, Course ID: 2, Grade: None, Name: Rohan Verma
Enrollment ID: 14, Student ID: 3, Course ID: 3, Grade: None, Name: Rohan Verma
Enrollment ID: 16, Student ID: 10, Course ID: 3, Grade: None, Name: Meenakshy Suji
Total Queries Executed: 1
"""
