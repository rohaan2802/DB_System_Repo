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
