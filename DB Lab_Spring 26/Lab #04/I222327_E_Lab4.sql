--------------------------------------------------
-- CREATE DATABASE (if not exists)
--------------------------------------------------

IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = 'EmpDeptDB'
)
BEGIN
    CREATE DATABASE EmpDeptDB;
END;
GO

--------------------------------------------------
-- USE DATABASE
--------------------------------------------------

USE EmpDeptDB;
GO


PRINT 'Building demonstration tables. Please wait.';

--------------------------------------------------
-- DROP TABLES
--------------------------------------------------

IF OBJECT_ID('ProjAssign', 'U') IS NOT NULL DROP TABLE ProjAssign;
IF OBJECT_ID('Project', 'U') IS NOT NULL DROP TABLE Project;
IF OBJECT_ID('EMP', 'U') IS NOT NULL DROP TABLE EMP;
IF OBJECT_ID('DEPT', 'U') IS NOT NULL DROP TABLE DEPT;
IF OBJECT_ID('BONUS', 'U') IS NOT NULL DROP TABLE BONUS;
IF OBJECT_ID('SALGRADE', 'U') IS NOT NULL DROP TABLE SALGRADE;
IF OBJECT_ID('DUMMY', 'U') IS NOT NULL DROP TABLE DUMMY;

--------------------------------------------------
-- DEPT
--------------------------------------------------

CREATE TABLE DEPT
(
    DEPTNO INT PRIMARY KEY,
    DNAME  VARCHAR(14),
    LOC    VARCHAR(13)
);

INSERT INTO DEPT VALUES
(10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON'),
(50, 'MAINTENANCE', 'DALLAS');

--------------------------------------------------
-- EMP
--------------------------------------------------

CREATE TABLE EMP
(
    EMPNO   INT PRIMARY KEY,
    ENAME   VARCHAR(10) NOT NULL,
    JOB     VARCHAR(9),
    MGR     INT,
    HIREDATE DATETIME,
    SAL     DECIMAL(7,2) NOT NULL CHECK (SAL >= 0),
    COMM    DECIMAL(7,2),
    DEPTNO  INT,

    CONSTRAINT FK_EMP_DEPT
        FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30),
(7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30),
(7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
(7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10),
(7788,'SCOTT','ANALYST',7566,'1982-12-09 21:39:05',3000,NULL,20),
(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10),
(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30),
(7876,'ADAMS','CLERK',7788,'1983-01-12 09:16:50',1100,NULL,20),
(7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30),
(7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,NULL),
(7934,'MILLER','CLERK',7782,'1982-01-23',1300,NULL,10),
(1122,'SARAH','CLERK',7788,'2019-12-12 10:25:55',1100,NULL,20);

--------------------------------------------------
-- UPDATE
--------------------------------------------------

UPDATE EMP
SET HIREDATE = '1983-01-12 21:05:50'
WHERE EMPNO = 7900;

--------------------------------------------------
-- SELF FK (MANAGER)
--------------------------------------------------

ALTER TABLE EMP
ADD CONSTRAINT FK_EMP_MGR
FOREIGN KEY (MGR) REFERENCES EMP(EMPNO);

--------------------------------------------------
-- BONUS
--------------------------------------------------

CREATE TABLE BONUS
(
    ENAME VARCHAR(10),
    JOB   VARCHAR(9),
    SAL   DECIMAL(7,2),
    COMM  DECIMAL(7,2)
);

--------------------------------------------------
-- SALGRADE
--------------------------------------------------

CREATE TABLE SALGRADE
(
    GRADE INT,
    LOSAL INT,
    HISAL INT
);

INSERT INTO SALGRADE VALUES
(1,700,1200),
(2,1201,1400),
(3,1401,2000),
(4,2001,3000),
(5,3001,9999);

--------------------------------------------------
-- DUMMY
--------------------------------------------------

CREATE TABLE DUMMY
(
    DUMMY INT
);

INSERT INTO DUMMY VALUES (0);

--------------------------------------------------
-- PROJECT
--------------------------------------------------

CREATE TABLE Project
(
    Projno     CHAR(6) PRIMARY KEY,
    ProjName   VARCHAR(30) NOT NULL,
    ProjType   CHAR(1),
    StartDate  DATETIME,
    EndDate    DATETIME,
    ManagerNo  INT NOT NULL,
    HrsRate    DECIMAL(5,2),

    CONSTRAINT FK_Project_Manager
        FOREIGN KEY (ManagerNo) REFERENCES EMP(EMPNO)
);

INSERT INTO Project VALUES
('PM2210','Main Building Construction','C','2001-03-17','2003-03-31',7566,150),
('PM2211','Avenue Road Renovation','R','2001-04-10','2002-04-10',7788,75),
('PM2278','ERP and Software Development','I','2002-11-01','2003-05-01',7788,200);

--------------------------------------------------
-- PROJASSIGN
--------------------------------------------------

CREATE TABLE ProjAssign
(
    Projno     CHAR(6),
    Empno      INT,
    ProjPeriod CHAR(7) NOT NULL,
    NoOfHrs    INT,

    CONSTRAINT PK_ProjAssign
        PRIMARY KEY (Projno, Empno, ProjPeriod),

    CONSTRAINT FK_ProjAssign_Emp
        FOREIGN KEY (Empno) REFERENCES EMP(EMPNO),

    CONSTRAINT FK_ProjAssign_Proj
        FOREIGN KEY (Projno) REFERENCES Project(Projno)
);

INSERT INTO ProjAssign VALUES
('PM2210',7369,'APR2001',20),
('PM2211',7369,'APR2001',5),
('PM2278',7654,'DEC2002',15),
('PM2278',7788,'MAY2003',25),
('PM2211',7788,'DEC2002',12);

--------------------------------------------------
-- DONE
--------------------------------------------------

PRINT 'Demonstration table build is complete.';

SELECT name
FROM sys.tables;


--1) Find all sales people in Department 30 whose salary is greater than or equal to 1500.

SELECT * FROM EMP
WHERE DEPTNO = 30 AND JOB = 'SALESMAN' AND SAL >= 1500;


--2) List information about employees in department 10 who are not manager or clerks?
SELECT * FROM EMP 
WHERE DEPTNO = 10 AND JOB <> 'MANAGER' AND JOB <> 'CLERK';


-- 3. List employees who do not have any commission?
SELECT * FROM EMP
WHERE COMM IS NULL OR COMM = 0;

--4) List managers and department number of employees who have A as the second letter of their name?
SELECT ENAME, DEPTNO 
FROM EMP
WHERE JOB = 'MANAGER' OR ENAME LIKE '_A%';


--5) List employees whose commission is greater than 25% of their salary?
SELECT * FROM EMP
WHERE COMM IS NOT NULL AND COMM > (SAL * 0.25);


--6) List sales people in descending order of their commission divided by their salary?
SELECT ENAME, SAL, COMM, (COMM * 1.0 / SAL) AS Comm_Ratio
FROM EMP
WHERE JOB = 'SALESMAN' AND COMM IS NOT NULL AND SAL > 0
ORDER BY (COMM * 1.0 / SAL) DESC;

--7) To count the employees and calculate the average annual salary for each job group in each department?
SELECT DEPTNO,JOB,COUNT(*) AS EmpCount,AVG(SAL * 12.0) AS AvgAnnualSalary
FROM EMP
GROUP BY DEPTNO, JOB;

--8) To list the average annual salary for all job groups with more than two employees.
SELECT JOB,AVG(SAL * 12.0) AS AvgAnnualSalary,COUNT(*) AS EmpCount
FROM EMP
GROUP BY JOB
HAVING COUNT(*) > 2;

--9) To list job groups whose average salary exceeds that of their manager’s salary?

SELECT E.JOB,AVG(E.SAL) AS AvgEmpSalary,M.SAL AS ManagerSalary
FROM EMP E ,EMP M
GROUP BY E.JOB, M.SAL
HAVING AVG(E.SAL) > M.SAL;

--10) To find the review dates of employees hired in the last 90 days where review take place one year after hire date?
SELECT ENAME,HIREDATE,DATEADD(YEAR, 1, HIREDATE) AS ReviewDate
FROM EMP
WHERE HIREDATE >= DATEADD(DAY, -90, GETDATE());

--11) Write SQL to create view on some table.
CREATE VIEW vw_Dep10Employees AS SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 10;

SELECT * FROM vw_Dep10Employees

--12) Display list of jobs, number of employees of each job from departments 10 and 20. List only records if number of employees in each job are more than 1.
SELECT JOB,COUNT(*) AS EmpCount
FROM EMP
WHERE DEPTNO IN (10, 20)
GROUP BY JOB
HAVING COUNT(*) > 1;

--13) Display the following output with same column names, start date means hiredate of an employee.
SELECT EMPNO AS [Employee No],ENAME AS [Emp. Name],
CONVERT(VARCHAR(10), HIREDATE, 103) AS [Start Date]   -- 103 = dd/mm/yyyy
FROM EMP
ORDER BY HIREDATE DESC;

--14) Write down sample SQL statements for all functions given in manual.

-- STRING FUNCTIONS

SELECT LEN(ENAME) AS NameLength FROM EMP;

SELECT UPPER(ENAME) AS UpperName FROM EMP;

SELECT LOWER(ENAME) AS LowerName FROM EMP;

SELECT LEFT(ENAME, 2) AS First2Chars FROM EMP;

SELECT RIGHT(ENAME, 2) AS Last2Chars FROM EMP;

SELECT SUBSTRING(ENAME, 2, 3) AS PartOfName FROM EMP;

SELECT REPLACE(ENAME, 'A', '@') AS ReplacedName FROM EMP;

SELECT LTRIM('   HELLO') AS LTrimExample;

SELECT RTRIM('HELLO   ') AS RTrimExample;


-- NUMERIC FUNCTIONS


SELECT ABS(-10) AS AbsValue;

SELECT CEILING(12.3) AS CeilValue;

SELECT FLOOR(12.9) AS FloorValue;

SELECT ROUND(123.456, 2) AS RoundedValue;


-- DTAE FUNCTIONS


SELECT GETDATE() AS Today;

SELECT DATEADD(YEAR, 1, HIREDATE) AS NextYear FROM EMP;

SELECT DATEDIFF(YEAR, HIREDATE, GETDATE()) AS ExperienceYears FROM EMP;

SELECT DATENAME(MONTH, HIREDATE) AS HireMonthName FROM EMP;

SELECT MONTH(HIREDATE) AS HireMonthNumber FROM EMP;

-- NULL HANDLING

SELECT ISNULL(COMM, 0) AS Commission FROM EMP;


-- AGGREGATE FUNCTIONS (Grouping)

SELECT COUNT(*) AS TotalEmployees FROM EMP;

SELECT AVG(SAL) AS AvgSalary FROM EMP;

SELECT MAX(SAL) AS MaxSalary FROM EMP;

SELECT MIN(SAL) AS MinSalary FROM EMP;

SELECT SUM(SAL) AS TotalSalary FROM EMP;


--15) List the employees who are working for either department 10 or 20 as clerk or analyst with a salary
--    is either three or four digits with an experience greater than 8 years but does not belong to month
--    of march, April, September and working for manager and manager number is not ending with 88 and 56.

SELECT EMPNO, ENAME, JOB, SAL, HIREDATE, MGR, DEPTNO
FROM EMP
WHERE DEPTNO IN (10, 20) AND JOB IN ('CLERK', 'ANALYST') AND SAL BETWEEN 100 AND 9999 
AND DATEDIFF(YEAR, HIREDATE, GETDATE()) > 8 AND MONTH(HIREDATE) NOT IN (3, 4, 9) AND MGR IS NOT NULL 
AND CAST(MGR AS VARCHAR(20)) NOT LIKE '%88' AND CAST(MGR AS VARCHAR(20)) NOT LIKE '%56';
