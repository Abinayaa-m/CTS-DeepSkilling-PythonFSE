import mysql.connector
import time

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234",
    database="college_db"
)

cursor = conn.cursor()

start_n1 = time.time()

query_count_n1 = 0

cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()
query_count_n1 += 1

for enrollment in enrollments:
    student_id = enrollment[1]

    cursor.execute(
        "SELECT first_name, last_name FROM students WHERE student_id = %s",
        (student_id,)
    )

    cursor.fetchone()
    query_count_n1 += 1

end_n1 = time.time()

start_join = time.time()

query_count_join = 0

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

cursor.fetchall()
query_count_join += 1

end_join = time.time()

print("===== Comparison =====")

print("N+1 Approach")
print("Queries Executed:", query_count_n1)
print("Execution Time:", end_n1 - start_n1, "seconds")

print()

print("JOIN Approach")
print("Queries Executed:", query_count_join)
print("Execution Time:", end_join - start_join, "seconds")

print()

print("Round Trips Saved:", query_count_n1 - query_count_join)

cursor.close()
conn.close()


"""
OUTPUT:
===== Comparison =====
N+1 Approach
Queries Executed: 14
Execution Time: 0.007006406784057617 seconds

JOIN Approach
Queries Executed: 1
Execution Time: 0.0009953975677490234 seconds

Round Trips Saved: 13
"""



"""
Q59:

In a real application with 10,000 enrollments:

N+1 Approach:
- 1 query to fetch all enrollments.
- 10,000 additional queries to fetch student details.
- Total queries executed = 10,001.

JOIN Approach:
- 1 query retrieves enrollment and student information together.
- Total queries executed = 1.

Difference:
- The N+1 approach issues 10,000 extra queries.

Impact:
- Increased database round-trips.
- Higher network overhead.
- Slower application performance.
- Poor scalability for large datasets.

Therefore, JOIN-based retrieval is preferred in production applications.
"""
