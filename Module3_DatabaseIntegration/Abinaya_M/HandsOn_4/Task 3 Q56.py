import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root1234",
    database="college_db"
)

cursor = conn.cursor()

query_count = 0

cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()
query_count += 1

for enrollment in enrollments:
    student_id = enrollment[1]   

    cursor.execute(
        "SELECT first_name, last_name FROM students WHERE student_id = %s",
        (student_id,)
    )
    student = cursor.fetchone()
    query_count += 1

    print(f"Student ID: {student_id}, Name: {student[0]} {student[1]}")

print("Total Queries Executed:", query_count)

cursor.close()
conn.close()
 
"""
OUTPUT:
Student ID: 1, Name: Arjun Mehta
Student ID: 1, Name: Arjun Mehta
Student ID: 2, Name: Priya Suresh
Student ID: 2, Name: Priya Suresh
Student ID: 3, Name: Rohan Verma
Student ID: 5, Name: Vikram Das
Student ID: 5, Name: Vikram Das
Student ID: 6, Name: Kavya Menon
Student ID: 8, Name: Deepika Rao
Student ID: 8, Name: Deepika Rao
Student ID: 3, Name: Rohan Verma
Student ID: 3, Name: Rohan Verma
Student ID: 10, Name: Meenakshy Suji
Total Queries Executed: 14
"""
