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

-- 1. Higher 10 earners of the company

SELECT TOP 10 *
FROM EMP
ORDER BY SAL DESC;

--2. Job groups whose average salary is greater than managers average

SELECT JOB, AVG(SAL) AS AvgSalary
FROM EMP
GROUP BY JOB
HAVING AVG(SAL) > ( SELECT AVG(SAL) FROM EMP WHERE JOB = 'MANAGER' );

--3. Employee number, name, project name and amount earned

SELECT E.EMPNO, E.ENAME, P.ProjName, (PA.NoOfHrs * P.HrsRate) AS AmountEarned
FROM EMP E
INNER JOIN ProjAssign PA ON E.EMPNO = PA.Empno
INNER JOIN Project P ON PA.Projno = P.Projno;

--4. Jobs and number of employees (Accounting & Research only)

SELECT E.JOB, COUNT(*) AS TotalEmployees
FROM EMP E
INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME IN ('ACCOUNTING','RESEARCH')
GROUP BY E.JOB
HAVING COUNT(*) > 1;

--5. Employee details with project salary

SELECT E.EMPNO, E.ENAME, E.SAL, P.ProjName, PA.ProjPeriod, PA.NoOfHrs, (PA.NoOfHrs * P.HrsRate) AS ProjectSalary
FROM EMP E
INNER JOIN ProjAssign PA ON E.EMPNO = PA.Empno
INNER JOIN Project P ON PA.Projno = P.Projno;

--6. Same job as JONES or salary more than ADAMS

SELECT *
FROM EMP
WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME = 'JONES') OR SAL > (SELECT SAL FROM EMP WHERE ENAME = 'ADAMS');

--7. Lowest paid employee in Sales department

SELECT E.*
FROM EMP E
INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE D.DNAME = 'SALES' AND E.SAL = (SELECT MIN(E2.SAL) FROM EMP E2 INNER JOIN DEPT D2 ON E2.DEPTNO = D2.DEPTNO
WHERE D2.DNAME = 'SALES'
);

--8. Average salary for each job excluding Manager

SELECT JOB, AVG(SAL) AS Avg_Salary
FROM EMP
WHERE JOB <> 'MANAGER'
GROUP BY JOB;

--9. Job and maximum salary >= 4000

SELECT JOB, MAX(SAL) AS MaxSalary
FROM EMP
GROUP BY JOB
HAVING MAX(SAL) >= 4000;

--10. Employee records where same job appears at least 3 times

SELECT *
FROM EMP
WHERE JOB IN ( SELECT JOB FROM EMP GROUP BY JOB HAVING COUNT(*) >= 3 );

--11. Number of jobs available

SELECT COUNT(DISTINCT JOB) AS TotalJobs
FROM EMP;

--12. Manager ID and lowest paid employee salary under that manager

SELECT MGR, MIN(SAL) AS LowestSalary
FROM EMP
WHERE MGR IS NOT NULL
GROUP BY MGR;

--13. Hire date formats

SELECT ENAME,
FORMAT(HIREDATE, 'MMMM d, yyyy') AS Format1,
FORMAT(HIREDATE, 'MMM dd, yyyy') AS Format2,
FORMAT(HIREDATE, 'd/M/yyyy') AS Format3
FROM EMP;

--14. Employees earning more than department average

SELECT *
FROM EMP E
WHERE SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO = E.DEPTNO);

--15. Joined in month whose second letter is 'a'

SELECT *
FROM EMP
WHERE DATENAME(MONTH, HIREDATE) LIKE '_a%';

--16. Maximum salary of Salesman

SELECT MAX(SAL) AS MaxSalesmanSalary
FROM EMP
WHERE JOB = 'SALESMAN';

--17. Number of employees with same job

SELECT JOB, COUNT(*) AS TotalEmployees
FROM EMP
GROUP BY JOB;

--18. Employees earning more than their manager

SELECT E.EMPNO, E.ENAME, E.SAL, M.ENAME AS Manager_Name, M.SAL AS Manager_Salary
FROM EMP E
INNER JOIN EMP M ON E.MGR = M.EMPNO
WHERE E.SAL > M.SAL;

--19. Display all departments and their employees

SELECT D.DEPTNO, D.DNAME, E.ENAME
FROM DEPT D
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO;

--20. Display all employees and any projects they work on

SELECT E.EMPNO, E.ENAME, P.ProjName
FROM EMP E
LEFT JOIN ProjAssign PA ON E.EMPNO = PA.Empno
LEFT JOIN Project P ON PA.Projno = P.Projno;

