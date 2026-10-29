--CREATE DATABASE SchoolManagement.   --Create the Database:
--USE SchoolManagement.

-- Create Tables:

--Students Table:

CREATE TABLE Students
(
Stu_Id INT IDENTITY(1,100) PRIMARY KEY,
Stu_Name VARCHAR(50) NOT NULL,
Stu_Gender VARCHAR(50) CHECK(Stu_Gender IN('MALE','FEMALE')),
Stu_Date_Of_Birth DATE NOT NULL,
Stu_Email VARCHAR(50) NOT NULL,
Stu_Phone VARCHAR(11) NOT NULL,
Stu_City VARCHAR(11) NOT NULL
);

-- Courses Table:
CREATE TABLE Courses
(
Course_Id INT IDENTITY(1,1001) PRIMARY KEY,
Course_Name VARCHAR(50) NOT NULL,
Course_Description VARCHAR(255) NOT NULL,
Credit_Hours INT CHECK(Credit_Hours > 0),
Department VARCHAR(50) NOT NULL
);

--Instructors Table:
CREATE TABLE Instructors
(
Ins_Id INT IDENTITY(1,1) PRIMARY KEY,
Ins_Name VARCHAR(50) NOT NULL,
Ins_Email VARCHAR(50) NOT NULL,
Ins_Phone VARCHAR(11) NOT NULL,
Ins_City VARCHAR(20) NOT NULL DEFAULT 'Unknown',
Ins_Specialization VARCHAR(55) NOT NULL,
Ins_Hire_Date DATE NOT NULL,
Ins_Sallary INT CHECK(Ins_Sallary > 0)
);

--Enrollments Table:
CREATE TABLE Enrollments
(
Course_Id INT,
Stu_Id INT,
PRIMARY KEY (Course_Id,Stu_id),
FOREIGN KEY(Course_Id) REFERENCES Courses(Course_Id),
FOREIGN KEY(Stu_id) REFERENCES Students(Stu_Id)
);

--Departments Table:
CREATE TABLE Departments
(
Dep_Id INT IDENTITY(1,1) PRIMARY KEY,
Dep_Name VARCHAR(50),
HOD_NAME VARCHAR(50),
Office_Phone VARCHAR(11)
);
--Constraints have applied

--Modify Tables:
ALTER TABLE Students DROP COLUMN Stu_Email
ALTER TABLE Students ADD Stu_Email VARCHAR(50)
ALTER TABLE Instructors DROP CONSTRAINT CK__Instructo__Ins_S__5BE2A6F2
ALTER TABLE Instructors ALTER COLUMN Ins_Sallary DECIMAL(10,2)



