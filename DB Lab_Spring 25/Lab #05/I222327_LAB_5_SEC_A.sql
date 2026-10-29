CREATE DATABASE LibraryManagementSystem -- CREATING A DATABASE LAB_5
USE LibraryManagementSystem -- USE THE DATABASE LAB_5

-- BOOKS TABLES
CREATE TABLE Books 
(
    Book_Id INT IDENTITY(1001,2) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price>0) NOT NULL,
    Quantity INT CHECK (Quantity>=0) NOT NULL
);

-- USERS TABLE
CREATE TABLE Users 
(
    User_Id INT IDENTITY(5010,1) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    City VARCHAR(100) DEFAULT NULL,
    Membership_status VARCHAR(20) CHECK (Membership_status IN ('ACTIVE','INACTIVE'))
);

-- TRANSACTIONS TABLE
CREATE TABLE Transactions 
(
    Transaction_Id INT IDENTITY(2001,1) PRIMARY KEY,
    Book_Id INT NOT NULL,
    Borrower_Id INT NOT NULL,
    Borrow_Date DATE NOT NULL,
    Return_Date DATE DEFAULT NULL,
    Status VARCHAR(20) NOT NULL CHECK(Status IN ('BORROWED', 'RETURNED', 'OVERDUE')),
    FOREIGN KEY (Book_Id) REFERENCES Books(Book_Id),
    FOREIGN KEY (Borrower_Id) REFERENCES Users(User_Id)
);

--INSERT DATA INTO BOOKS TABLE

INSERT INTO Books (Title, Author, Category, Price, Quantity)
VALUES 
('Harry Potter', 'J.K. Rowling', 'Fiction', 899.99, 5),
('Data Science 101', 'John Smith', 'Education', 49.99, 12),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 599.99, 2),
('Machine Learning Basics', 'Andrew Ng', 'Education', 799.99, 7),
('The Catcher in the Rye', 'J.D. Salinger', 'Classic', 499.99, 4),
('Python Programming', 'Guido van Rossum', 'Education', 299.99, 10),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 399.99, 6),
('Deep Learning AI', 'Ian Goodfellow', 'Education', 899.99, 3),
('1984', 'George Orwell', 'Fiction', 450.00, 8),
('Clean Code', 'Robert C. Martin', 'Education', 699.99, 5);

--INSERT DATA INTO USERS TABLE

INSERT INTO Users (Name, Email, City, Membership_status)
VALUES 
('Alice Brown', 'alice.brown@gmail.com', 'New York', 'ACTIVE'),
('Bob Green', 'bob.green@nu.edu.pk', 'Chicago', 'ACTIVE'),
('Charlie Lee', 'charlie.lee@yahoo.com', NULL, 'INACTIVE'),
('David Smith', 'david.smith@gmail.com', 'San Francisco', 'ACTIVE'),
('Eva Adams', 'eva.adams@gmail.com', 'Los Angeles', 'ACTIVE'),
('Frank White', 'frank.white@nu.edu.pk', 'Houston', 'INACTIVE'),
('Grace Kelly', 'grace.kelly@gmail.com', 'Boston', 'ACTIVE'),
('Henry Ford', 'henry.ford@yahoo.com', NULL, 'INACTIVE'),
('Isabella Stone', 'isabella.stone@gmail.com', 'Seattle', 'ACTIVE'),
('Jack Black', 'jack.black@gmail.com', 'Miami', 'ACTIVE');

--INSERT DATA INTO TRANSACTIONS TABLE
INSERT INTO Transactions (Book_Id, Borrower_Id, Borrow_Date, Return_Date, Status)
VALUES 
(1001, 5010, '2025-01-10', '2025-02-10', 'RETURNED'),
(1003, 5011, '2024-12-22', NULL, 'OVERDUE'),
(1005, 5010, '2025-02-15', NULL, 'BORROWED'),
(1007, 5012, '2025-01-05', '2025-01-20', 'RETURNED'),
(1009, 5013, '2025-02-01', NULL, 'BORROWED'),
(1011, 5014, '2025-02-10', NULL, 'BORROWED'),
(1013, 5015, '2025-01-25', '2025-02-05', 'RETURNED'),
(1015, 5016, '2025-02-05', NULL, 'OVERDUE'),
(1017, 5017, '2025-01-20', '2025-02-01', 'RETURNED'),
(1019, 5018, '2025-01-13', NULL, 'BORROWED');

--------------------------------------------------------


-- Choose one book and update its category to Poetry.
 
UPDATE Books
SET Category = 'Poetry'
WHERE Book_Id=1001

--VERIFYING
SELECT *  FROM Books WHERE Book_Id=1001

--------------------------------------------------------

--List all the user ids and names for the users who haven’t provided their cities.

SELECT User_Id,Name 
FROM Users
WHERE City IS NULL

--------------------------------------------------------

--Considering due date of 1 week, update status to overdue for overdue books.

SELECT *  
FROM Transactions  
WHERE DATEDIFF(DAY, Borrow_Date, GETDATE()) > 7  
AND Return_Date IS NULL  
AND Status = 'BORROWED';
	
UPDATE Transactions  
SET Status = 'OVERDUE'  
WHERE DATEDIFF(DAY, Borrow_Date, GETDATE()) > 7  
AND Return_Date IS NULL  
AND Status = 'BORROWED';

--VERIFYING

SELECT * FROM Transactions WHERE Status = 'OVERDUE';

--------------------------------------------------------

--Display all book ids in descending order that are not returned yet.

SELECT Book_Id  
FROM Transactions  
WHERE Return_Date IS NULL  
ORDER BY Book_Id DESC;

--------------------------------------------------------

--List all book where the price is more than $250 and quantity is below 5.

SELECT *
FROM Books
WHERE Price>250 AND Quantity<5;

--------------------------------------------------------

--Display the transactionId and status of 3 most recent transactions.

SELECT TOP 3 Transaction_Id
FROM Transactions
WHERE Borrow_Date IS NOT NULL
ORDER BY Borrow_Date DESC;
--------------------------------------------------------

--Retrieve distinct categories of books from the `Books` table.
SELECT DISTINCT Category
FROM Books;

--------------------------------------------------------

--Update the price of all books in the 'Education' category to decrease by 10%.
UPDATE Books
SET Price=Price-(Price*0.10)
WHERE Category = 'Education';

--VERIFICATION
SELECT * FROM Books

--------------------------------------------------------

--Select books where the price is either less than $50 or quantity is between 5 and 10.

SELECT *
FROM Books
WHERE Price>50 AND Quantity BETWEEN 5 AND 10;

--------------------------------------------------------

--List all book titles that do not have 'w' as the third letter and are currently out of stock

SELECT Title
FROM Books
WHERE Quantity = 0  
AND Title NOT LIKE '__w%';

--------------------------------------------------------
--Find all books that have ‘data’ in their name and do not belong to the Fiction Category.

SELECT Title
FROM Books
WHERE NOT Category= 'Fiction' 
AND Title LIKE '%data%';

--------------------------------------------------------

--Find all users who belong from New York, Chicago or Seattle as ‘CustomerCity’ without using OR operator.
SELECT *  , City AS CustomerCity
FROM Users  
WHERE City IN ('New York', 'Chicago', 'Seattle');

--------------------------------------------------------

--Find all customers whose email addresses do not follow a valid format.
SELECT *  
FROM Users  
WHERE Email NOT LIKE '%_@_%._%';

--------------------------------------------------------

--Create a new table ArchivedMembers with attributes ArchivedUserId, name, email and city. 
--Then transfer all data for the inactive members from the users table.

--ArchivedMembers TABLE

CREATE TABLE ArchivedMembers
(
    ArchivedUserId INT PRIMARY KEY,  
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    City VARCHAR(100) NULL
);

INSERT INTO ArchivedMembers (ArchivedUserId, Name, Email, City)
SELECT User_Id, Name, Email, City
FROM Users
WHERE Membership_status = 'INACTIVE';

--VERIFICATION
SELECT * FROM ArchivedMembers;
SELECT * FROM Users WHERE Membership_status = 'INACTIVE';



--------------------------------------------------------

--Delete all inactive members from the database.

DELETE FROM Transactions
WHERE Borrower_Id IN (SELECT User_Id FROM Users WHERE Membership_status = 'INACTIVE');

DELETE FROM Users
WHERE Membership_status = 'INACTIVE';

--------------------------------------------------------