use Northwind

-- Create a stored procedure that accepts a country name as a parameter and returns all customers from that country.

CREATE PROCEDURE GetCustomersByCountry
    @CountryName NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Customers
    WHERE Country = @CountryName;
END;
GO

-- TO RUN THE PROCEDURE

EXEC GetCustomersByCountry 'Germany';


-- Create a stored procedure that takes a minimum order date as a (an optional) parameter and returns all orders placed
-- on or after that date.

CREATE PROCEDURE GetOrdersByMinDate
    @MinOrderDate DATE = NULL
AS
BEGIN
    SELECT *
    FROM Orders
    WHERE @MinOrderDate IS NULL
       OR OrderDate >= @MinOrderDate;
END;
GO

-- TO RUN THE PROCEDURE

EXEC GetOrdersByMinDate '1997-01-01';

-- IF ALL ORDER REQUIRED

EXEC GetOrdersByMinDate;

-- Create a DDL trigger that logs a message into a log table (First create log table with two columns (Event Type, 
-- Event Description). Now whenever a table is created in the Northwind database, an entry should be inserted into the
-- log table capturing the event type and event description.

-- FIRST WE CREATE LOG TABLE

CREATE TABLE DDL_Log
(
    [Event Type] NVARCHAR(100),
    [Event Description] NVARCHAR(500)
);
GO

-- THEN WE CREATE DDL TRIGGER

CREATE TRIGGER trg_TableCreateLog
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    INSERT INTO DDL_Log ([Event Type], [Event Description])
    VALUES
    (
        EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)'),
        'A new table was created in Northwind database.'
    );
END;
GO

-- TO TEST IT

CREATE TABLE TestTable
(
    ID INT
);
GO

SELECT * FROM DDL_Log;

-- Create an AFTER INSERT DML trigger on the Orders table that logs an entry in a custom table whenever a new order is 
-- added. (Do explore Inserted in triggers for this purpose)

-- FIRST WE CREATE CUSTOM LOG TABLE

CREATE TABLE Orders_Insert_Log
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerID NCHAR(5),
    LogMessage NVARCHAR(300),
    LogDate DATETIME
);
GO

-- NOW CREATE TRIGGER

CREATE TRIGGER trg_AfterInsertOrders
ON Orders
AFTER INSERT
AS
BEGIN
    INSERT INTO Orders_Insert_Log
    (
        OrderID,
        CustomerID,
        LogMessage,
        LogDate
    )
    SELECT
        OrderID,
        CustomerID,
        'New order has been inserted into Orders table.',
        GETDATE()
    FROM inserted;
END;
GO

-- HERE INSERTED IS TEMPORARY TABLE WHICH STORES NEWLY INSERTED ROWS IN TRIGGER

-- TO CHECK LOG 

SELECT * FROM Orders_Insert_Log;

-- Create a function that takes an Order ID as a parameter and returns the total amount for that order 
-- (calculated as UnitPrice * Quantity for each item).

-- FORMULA --> UnitPrice * Quantity

CREATE FUNCTION GetOrderTotalAmount
(
    @OrderID INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalAmount MONEY;

    SELECT @TotalAmount = SUM(UnitPrice * Quantity)
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    RETURN @TotalAmount;
END;
GO

-- TO RUN THE FUNCTION

SELECT dbo.GetOrderTotalAmount(10248) AS TotalAmount;
