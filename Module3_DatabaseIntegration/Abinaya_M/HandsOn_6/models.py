from sqlalchemy import (
    DECIMAL,
    Column,
    Date,
    Integer,
    String,
    ForeignKey,
    create_engine
)

from sqlalchemy.orm import (
    declarative_base,
    relationship
)

from dotenv import load_dotenv
import os
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

Base = declarative_base()

engine = create_engine(
    f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}",
    echo=True
)

class Department(Base):
    __tablename__ = "departments"

    department_id = Column(Integer, primary_key=True, autoincrement=True)
    dept_name = Column(String(100), nullable=False)
    head_of_dept = Column(String(100))
    budget = Column(DECIMAL(12,2))

class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    date_of_birth = Column(Date)
    department_id = Column(Integer, ForeignKey("departments.department_id"))
    enrollment_year = Column(Integer)
    department = relationship("Department")

class Course(Base):
    __tablename__ = "courses"

    course_id = Column(Integer, primary_key=True, autoincrement=True)
    course_name = Column(String(150), nullable=False)
    course_code = Column(String(20))
    credits = Column(Integer)
    department_id = Column(Integer,ForeignKey("departments.department_id"))

class Enrollment(Base):
    __tablename__ = "enrollments"

    enrollment_id = Column(Integer, primary_key=True, autoincrement=True)
    student_id = Column(Integer, ForeignKey("students.student_id"))
    course_id = Column(Integer,ForeignKey("courses.course_id"))
    enrollment_date = Column(Date)
    grade = Column(String(2))
    student = relationship("Student")
    course = relationship("Course")

class Professor(Base):
    __tablename__ = "professors"

    professor_id = Column(Integer, primary_key=True, autoincrement=True)
    prof_name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True)
    department_id = Column(Integer, ForeignKey("departments.department_id"))
    salary = Column(DECIMAL(10,2))

if __name__ == "__main__":
    Base.metadata.create_all(engine)
    print("Tables created successfully")

# Base.metadata.create_all(engine) automatically
# creates all tables defined by ORM model classes.
# Verified in MySQL Workbench using SHOW TABLES.