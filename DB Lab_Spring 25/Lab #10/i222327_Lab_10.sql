
--Create a stored procedure that accepts a country name as a parameter and returns 1
--if at least one customer exists from that country, otherwise returns 0.

CREATE PROCEDURE Check_Customer_Count @County_Name_Var VARCHAR(50)
AS
BEGIN

IF EXISTS (SELECT * FROM Customers WHERE Country=@County_Name_Var )
RETURN 1
ELSE
RETURN 0

END


DECLARE @RES INT
EXEC @RES=Check_Customer_Count @County_Name_Var='Germany'

IF @RES=1
PRINT 'Customer Exists: ' + CAST(@Res AS VARCHAR);
ELSE
PRINT 'Customer Not Exists: '


--Create a stored procedure that generates accepts start and end dates as optional parameters
--and returns a summary of total orders and number of unique customers. Use output
--parameters to return number of orders and customers. Also handle invalid dates i.e., start
--date after end date (for invalid dates, the stored procedure only displays an error message)


CREATE PROCEDURE Order_Summary @StartDate DATE = NULL, @EndDate DATE = NULL, @TotalOrders INT OUTPUT, @UniqueCustomers INT OUTPUT
AS
BEGIN

    IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate > @EndDate
    BEGIN
        PRINT 'Error: Start date cannot be after end date.';
        RETURN;
    END

    SET @TotalOrders = 0;
    SET @UniqueCustomers = 0;

    SELECT @TotalOrders = COUNT(*), @UniqueCustomers = COUNT(DISTINCT CustomerID)
    FROM Orders
    WHERE
        (@StartDate IS NULL OR OrderDate >= @StartDate)
        AND (@EndDate IS NULL OR OrderDate <= @EndDate);
END;



DECLARE @Orders INT, @Customers INT

EXEC Order_Summary @StartDate = '1996-07-04', @EndDate = '1996-08-01', @TotalOrders = @Orders OUTPUT, @UniqueCustomers = @Customers OUTPUT

PRINT ' Total Orders: ' + CAST(@Orders AS VARCHAR);
PRINT ' Unique Customers: ' + CAST(@Customers AS VARCHAR);



--Create a DDL trigger that prevents ALTER and DROP TABLE operations on database
--and instead shows a message like "Table deletion is not allowed in this database.

CREATE TRIGGER Prevent_Alter_Drop_Table2
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    PRINT 'Table deletion or alteration is not allowed in this database.'
	ROLLBACK
END;

CREATE TABLE TEMP
(
TEMP INT IDENTITY PRIMARY KEY,
TEMP1 VARCHAR 
)

DROP TRIGGER Prevent_Alter_Drop_Table2 ON DATABASE

DROP TABLE TEMP

--Create a trigger that whenever a customer is deleted from the Employees table, log the
--deleted row's data into a table DeletedEmployeeLog with columns (EmployeeID, Full Name,
--BirthDate, HireDate and DeletedDate).


CREATE TABLE DeletedEmployeeLog (
    EmployeeID INT,
    FullName NVARCHAR(200),
    BirthDate DATE,
    HireDate DATE,
    DeletedDate DATETIME DEFAULT GETDATE()
)


CREATE TRIGGER trg_LogDeletedEmployee
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedEmployeeLog (EmployeeID, FullName, BirthDate, HireDate, DeletedDate)
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS FullName,
        BirthDate,
        HireDate,
        GETDATE()
    FROM deleted;
END;

-- Delete an employee
DELETE FROM Employees WHERE EmployeeID = 101;

-- Check the log
SELECT * FROM DeletedEmployeeLog;


--Create a trigger that tracks when the QuantityPerUnit of any product is changed and displays
--the old and new value to user.


CREATE TRIGGER Track_Quantity
ON Products
AFTER UPDATE
AS
BEGIN
    -- Display changes for only those rows where QuantityPerUnit was modified
    SELECT 
        d.ProductID,
        d.QuantityPerUnit AS OldQuantityPerUnit,
        i.QuantityPerUnit AS NewQuantityPerUnit
    FROM deleted d
    INNER JOIN inserted i ON d.ProductID = i.ProductID
    WHERE ISNULL(d.QuantityPerUnit, '') <> ISNULL(i.QuantityPerUnit, '');
END;
	

	-- Update a product
UPDATE Products
SET QuantityPerUnit = '24 bottles per case'
WHERE ProductID = 5;


--Create a trigger that automatically deletes all orders of a customer if the customer is deleted
--from the Customers table.

CREATE TRIGGER Delete_Customer
ON Customers
AFTER DELETE
AS
BEGIN
    DELETE FROM Orders
    WHERE CustomerID IN (SELECT CustomerID FROM deleted);
END;


-- Delete a customer
DELETE FROM Customers WHERE CustomerID = 'ALFKI'

select * from Customers


--Create a function that takes an Order ID as a parameter and returns the total amount for that
--order (calculated as UnitPrice * Quantity for each item).

CREATE FUNCTION Order_Total (@OrderID INT)
RETURNS int
AS
BEGIN
    DECLARE @Total int;

    SELECT @Total = SUM(UnitPrice * Quantity)
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;


SELECT dbo.Order_Total(10248) AS TotalAmount;



 


