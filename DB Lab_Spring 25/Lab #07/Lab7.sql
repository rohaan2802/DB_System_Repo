create database lab07
go
use lab07
go
--Create Department Table
CREATE TABLE Department (
    dep_id INT PRIMARY KEY,
    dep_name VARCHAR(100) NOT NULL,
	location VARCHAR(100)
);
--Create Employees Table
CREATE TABLE Employees (
    empid INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dep_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
);
--INSERT RECORD
INSERT INTO Department (dep_id, dep_name, location) 
VALUES 
(1, 'HR', 'Islamabad'),
(2, 'Engineering', 'Islamabad'),
(3, 'Finance', 'Karachi'),
(4, 'Marketing', 'Karachi'),
(5, 'Customer Service', 'Lahore'),
(6, 'Maintainence', 'Lahore');
INSERT INTO Employees (empid, emp_name, dep_name, salary) 
VALUES 
(101, 'Alice', 'HR', 55000),
(102, 'Bob', 'Engineering', 70000),
(103, 'Charlie', 'Finance', 60000),
(104, 'David', 'Marketing', 45000),
(105, 'Eve', 'Engineering', 80000);
INSERT INTO Employees (empid, emp_name, dep_name, salary) 
VALUES 
(106, 'Frank', 'Finance', 62000),
(107, 'Grace', 'HR', 53000),
(108, 'Hank', 'Marketing', 47000),
(109, 'Ivy', 'Engineering', 75000),
(110, 'Jack', 'HR', 56000),
(111, 'Kate', 'Finance', 61000),
(112, 'Leo', 'Engineering', 72000),
(113, 'Mia', 'Marketing', 46000),
(114, 'Noah', 'Engineering', 81000),
(115, 'Olivia', 'Finance', 59000);


select * from Department
select * from Employees

--- SUB QUERIES
--- Q1 : FIND an employee whose salary is more than average salary of all employees
--- Q2 : Find  all Employees who work in department located in Islamabad
--- Q3 : Find Department who dont have any employees
--- Q4 : Find employees in each department who earn more than average salary in that department



