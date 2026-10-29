CREATE DATABASE LAB13
USE LAB13

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    AuthorName VARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);


-- Books
INSERT INTO Books VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 15.99, 10),
(2, '1984', 'George Orwell', 12.50, 5),
(3, 'To Kill a Mockingbird', 'Harper Lee', 14.00, 8),
(4, 'The Catcher in the Rye', 'J.D. Salinger', 13.25, 7),
(5, 'Moby-Dick', 'Herman Melville', 18.00, 3);

-- Customers
INSERT INTO Customers VALUES
(41, 'John', 'Doe', 'john@example.com'),
(42, 'Jane', 'Smith', 'jane@example.com'),
(43, 'Alice', 'Johnson', 'alice@example.com'),
(44, 'Bob', 'Brown', 'bob@example.com'),
(45, 'Emma', 'Davis', 'emma@example.com');

-- Orders
INSERT INTO Orders VALUES
(101, 41, '2025-05-01', 29.99),
(102, 42, '2025-05-02', 14.00),
(103, 43, '2025-05-03', 18.00),
(104, 44, '2025-05-04', 13.25),
(105, 45, '2025-05-05', 30.00);


-- Update Email Address of a Specific Customer Using a Transaction

BEGIN TRANSACTION;

UPDATE Customers
SET Email = 'alice_new@example.com'
WHERE CustomerID = 43;

COMMIT TRANSACTION;


--Customer 43 Orders "The Great Gatsby" Using Savepoint

BEGIN TRANSACTION;

SAVE TRANSACTION before_order;

DECLARE @book_price DECIMAL(10,2);
SELECT @book_price = Price FROM Books WHERE Title = 'The Great Gatsby';

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (106, 43, GETDATE(), @book_price);

COMMIT TRANSACTION;


--Stored Procedure PurchaseBook with Rollback on Error

CREATE PROCEDURE PurchaseBook
    @CustomerID INT,
    @BookID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Stock INT, @Price DECIMAL(10,2), @NewOrderID INT;


        SELECT @Stock = StockQuantity, @Price = Price
        FROM Books
        WHERE BookID = @BookID;

        IF @Stock IS NULL
        BEGIN
            RAISERROR('Book not found.', 16, 1);
        END

        IF @Stock < 1
        BEGIN
            RAISERROR('Insufficient stock for the requested book.', 16, 1);
        END

        SELECT @NewOrderID = ISNULL(MAX(OrderID), 100) + 1 FROM Orders;

        INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
        VALUES (@NewOrderID, @CustomerID, GETDATE(), @Price);

        UPDATE Books
        SET StockQuantity = StockQuantity - 1
        WHERE BookID = @BookID;

        COMMIT TRANSACTION;
        PRINT 'Purchase successful.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


-- Execute the Procedure 

EXEC PurchaseBook @CustomerID = 43, @BookID = 1;


