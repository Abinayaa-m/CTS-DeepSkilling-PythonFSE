# Student Course Registration System

## Hands-On 1: Schema Design & Core SQL (DDL and Normalisation)

---


## Database Used

MySQL

---

## Tasks Completed

### Task 1: Create the Database and Tables

Created a database named:

```sql
college_db
```

Created the following tables:

1. departments
2. students
3. courses
4. enrollments
5. professors

Implemented:

* PRIMARY KEY constraints
* FOREIGN KEY constraints
* UNIQUE constraints
* NOT NULL constraints
* AUTO_INCREMENT columns

Established relationships:

* students → departments
* courses → departments
* enrollments → students
* enrollments → courses
* professors → departments

---

### Task 2: Verify Normalisation

#### First Normal Form (1NF)

* All columns contain atomic values.
* No repeating groups or multivalued attributes exist.
* Example violation: storing multiple phone numbers in a single column.

#### Second Normal Form (2NF)

* All non-key attributes depend on the entire primary key.
* In the enrollments table, grade and enrollment_date depend on the complete enrollment relationship between student and course.
* No partial dependency exists.

#### Third Normal Form (3NF)

* No transitive dependencies exist.
* Department information is stored in the departments table.
* Students reference departments through department_id.
* This prevents redundancy and maintains normalization.

---

### Task 3: Alter and Extend the Schema

Performed schema modifications using ALTER TABLE:

* Added phone_number column to students
* Added max_seats column to courses
* Added CHECK constraint for grade validation
* Renamed hod_name to head_of_dept
* Dropped phone_number column to simulate schema rollback


## Concepts Practiced

* CREATE DATABASE
* CREATE TABLE
* ALTER TABLE
* DROP COLUMN
* CHANGE COLUMN
* PRIMARY KEY
* FOREIGN KEY
* UNIQUE
* NOT NULL
* CHECK Constraint
* DEFAULT Constraint
* AUTO_INCREMENT
* Database Normalization


---



