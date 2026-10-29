
USE Northwind

--1. Write a query that declares a variable for storing an employee's full name
--   and assigns it the full name of the employee with employee_id 1. Output
--   the full name.

-- Declare a variable to store the full name
DECLARE @FullName NVARCHAR(100);

SELECT @FullName = E.FirstName + ' ' + E.LastName
FROM Employees E
WHERE E.EmployeeID = 1;

PRINT 'Employee Full Name: ' + @FullName;


--2. Declare a variable for the maximum salary allowed in the company, assign it
--   a value of 100000, and print this value.

DECLARE @MAX_SALLARY INT =100000
PRINT 'MAXIMUM_SALLARY ' + CAST(@MAX_SALLARY AS VARCHAR)

--3. Create a query that checks if the HireDate of the employee with
--   EmployeeID = 3 is before '1995-01-01'. If true, print "Long-time
--   employee"; otherwise, print "New employee."

DECLARE @DATE_VAR DATE
SELECT @DATE_VAR= E.HireDate
FROM Employees E
WHERE E.EmployeeID=3
IF @DATE_VAR < '1995-01-01'
    PRINT 'Long-time employee'
ELSE
    PRINT 'New employee'


--4. Write a query that retrieves the Title of the employee with EmployeeID = 4 and
--   uses a CASE statement to output a description based on the title.

DECLARE @Title VARCHAR(50);
DECLARE @Description VARCHAR(100);

SELECT @Title = Title
FROM Employees
WHERE EmployeeID = 4;

SET @Description = 
    CASE @Title
        WHEN 'Manager' THEN 'Oversees team operations'
        WHEN 'Developer' THEN 'Writes and maintains code'
        WHEN 'Analyst' THEN 'Analyzes business data'
        WHEN 'HR' THEN 'Manages employee relations'
        ELSE 'Other role'
    END;

PRINT 'Title: ' + @Title;
PRINT 'Description: ' + @Description;




--5. Write a query that uses a WHILE loop to print the EmployeeIDs of the first
--   5 employees in the Employees table.

DECLARE @Counter INT = 1;
DECLARE @EmpID INT;
DECLARE @Temp TABLE (RowNum INT IDENTITY(1,1), EmployeeID INT);

-- Create a temporary table to store the first 5 EmployeeIDs
-- Insert the first 5 EmployeeIDs (based on your desired order, e.g., by EmployeeID)
INSERT INTO @Temp (EmployeeID)
SELECT TOP 5 E.EmployeeID
FROM Employees E
ORDER BY LastName
-- Use WHILE loop to print each EmployeeID
WHILE @Counter <= 5
BEGIN
    SELECT @EmpID = EmployeeID
    FROM @Temp
    WHERE RowNum = @Counter;

    PRINT 'EmployeeID: ' + CAST(@EmpID AS NVARCHAR(10));

    SET @Counter = @Counter + 1;
END




--6. Create a loop that iterates through employees and use a break condition to
--   exit the loop if an employee's HireDate is after '1990-01-01'. Output the
--   employee's EmployeeID and HireDate.
CREATE TABLE EMP(EmployeeID INT, HireDate DATE);

-- Declare variables for loop control
DECLARE @Counter INT = 1;
DECLARE @EmpID INT;
DECLARE @HireDate DATE;

-- Insert data from Employees table into EMP
INSERT INTO EMP (EmployeeID, HireDate)
SELECT EmployeeID, HireDate
FROM Employees;

-- Loop through employees in EMP table
WHILE @Counter <= (SELECT COUNT(*) FROM EMP)
BEGIN
    -- Get EmployeeID and HireDate for the current employee
    SELECT @EmpID = EmployeeID, @HireDate = HireDate
    FROM EMP
    WHERE EmployeeID = @Counter;  -- Directly use @Counter to match EmployeeID

    -- Check if HireDate is after '1990-01-01'
    IF @HireDate > '1990-01-01'
    BEGIN
        PRINT 'Breaking the loop...';
        PRINT 'EmployeeID: ' + CAST(@EmpID AS VARCHAR(10));
        PRINT 'HireDate: ' + CAST(@HireDate AS VARCHAR(20));
        BREAK;
    END

    -- Increment the counter
    SET @Counter = @Counter + 1;
END




--7. Write a query that declares a variable for storing the number of orders
--   placed by the employee with EmployeeID = 2 and prints this count.

DECLARE @OrderCount INT;

SELECT @OrderCount = COUNT(*)
FROM Orders
WHERE EmployeeID = 2;

PRINT 'Number of orders placed by EmployeeID = 2: ' + CAST(@OrderCount AS VARCHAR(10));


--8. Write a query that retrieves the Country of a customer with CustomerID
--   = 'ALFKI' and uses a CASE statement to categorize the region as 'Europe',
--   'Asia', or 'Other' based on the country.

SELECT 
    Country,
    CASE
        WHEN Country IN ('Germany', 'France', 'Italy', 'Spain', 'United Kingdom') THEN 'Europe'
        WHEN Country IN ('Japan', 'China', 'India', 'South Korea') THEN 'Asia'
        ELSE 'Other'
    END AS Region
FROM Customers
WHERE CustomerID = 'ALFKI';

--9. Write a query that creates a labeled loop to print the ProductIDs of the
--   first 5 products from the Products table, and demonstrates how to
--   structure a labeled block of code.

DECLARE @Counter INT = 1;
DECLARE @ProductID INT;

ProductLoop:

SELECT @ProductID = ProductID
FROM Products
WHERE ProductID = @Counter;

IF @ProductID IS NOT NULL
BEGIN
    PRINT 'ProductID: ' + CAST(@ProductID AS NVARCHAR(10));
END

SET @Counter = @Counter + 1;

IF @Counter <= 5
    GOTO ProductLoop; 


--10.Write a query that uses the above task to demonstrate the use of GOTO by
--   skipping a section of code that prints a message and jumps to a labeled
--   section that prints "This section was reached."

DECLARE @Counter INT = 1;
DECLARE @ProductID INT;

SkipSection:

SELECT @ProductID = ProductID
FROM Products
WHERE ProductID = @Counter;

IF @ProductID IS NOT NULL
    PRINT 'ProductID: ' + CAST(@ProductID AS NVARCHAR(10));

SET @Counter = @Counter + 1;

IF @Counter <= 5
    GOTO SkipSection;

PRINT 'This section was reached, after all product IDs have been printed.';

--11.Write a query that retrieves the number of orders placed in 1997 and
--   categorizes them as 'Low', 'Medium', or 'High' based on the total number of
--   orders using a CASE statement.


DECLARE @OrderCount INT;

SELECT @OrderCount = COUNT(*)
FROM Orders
WHERE YEAR(OrderDate) = 1997;

SELECT 
    @OrderCount AS TotalOrders,
    CASE 
        WHEN @OrderCount < 100 THEN 'Low'
        WHEN @OrderCount BETWEEN 100 AND 300 THEN 'Medium'
        ELSE 'High'
    END AS OrderCategory;
