CREATE DATABASE LibraryDB
USE LibraryDB

-- BOOKS TABLES
CREATE TABLE BOOKS 
(
    Book_Id INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genere VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price>0) NOT NULL,
    PublicationYear INT CHECK ((PublicationYear > =1000 AND PublicationYear <=DATEPART(YEAR,GETDATE()) ) ) NOT NULL 
);


-- MEMBERS TABLE 
CREATE TABLE MEMBERS 
(
    Member_Id INT IDENTITY(1,1) PRIMARY KEY,
    Full_Name VARCHAR(255) NOT NULL,
    Join_Date DATE NOT NULL DEFAULT GETDATE()
);

-- BORROWINGS TABLES
CREATE TABLE BORROWINGS
(
      Borrow_Id INT IDENTITY(1,1) PRIMARY KEY,
	  Book_Id INT NOT NULL,
	  Member_Id INT NOT NULL,
	  BorrowDate DATE NOT NULL DEFAULT GETDATE(),
	  Status VARCHAR(20) NOT NULL DEFAULT 'Borrowed'  CHECK (Status IN ('Borrowed', 'Returned')),
	  FOREIGN KEY (Book_Id) REFERENCES Books(Book_Id),	
	  FOREIGN KEY (Member_Id) REFERENCES MEMBERS(Member_Id),
	  Return_Date DATE DEFAULT NULL,
);

-- Insert dummy data into Books table

INSERT INTO BOOKS (Title, Genere, Price, PublicationYear)
VALUES
('The Silent Patient', 'Thriller', 1200.50, 2019),
('Atomic Habits', 'Self-Help', 950.00, 2018),
('1984', 'Dystopian', 800.00, 1949),
('The Alchemist', 'Fiction', 700.75, 1988),
('Educated', 'Memoir', 1150.00, 2018),
('Sapiens', 'History', 1300.00, 2011),
('The Psychology of Money', 'Finance', 990.00, 2020),
('Dune', 'Science Fiction', 1100.00, 1965),
('Becoming', 'Biography', 1250.00, 2018),
('Digital Fortress', 'Tech Thriller', 875.00, 2005);


INSERT INTO MEMBERS (Full_Name)
VALUES
('Ali Raza'),
('Fatima Khan'),
('Ahmed Javed'),
('Zainab Shah'),
('Usman Tariq'),
('Sara Naveed'),
('Hamza Yousuf'),
('Ayesha Malik'),
('Bilal Qureshi'),
('Mehak Noor');


INSERT INTO BORROWINGS (Book_Id, Member_Id, BorrowDate, Status, Return_Date)
VALUES
(1, 1, '2024-12-01', 'Returned', '2025-01-10'),
(2, 2, '2025-01-15', 'Borrowed', NULL),
(3, 3, '2024-11-20', 'Returned', '2025-01-05'),
(4, 4, '2025-03-01', 'Borrowed', NULL),
(5, 5, '2025-02-01', 'Returned', '2025-02-28'),
(6, 6, '2025-03-10', 'Returned', '2025-03-25'),
(7, 7, '2025-03-05', 'Borrowed', NULL),
(8, 8, '2025-01-10', 'Returned', '2025-02-05'),
(9, 9, '2025-02-20', 'Borrowed', NULL),
(10, 10, '2024-12-15', 'Returned', '2025-01-20');



-- Retrieve the total count of books available in the library.
SELECT COUNT(*)
FROM BOOKS


-- Display all books published before the year 2000, sorted in descending order by publication year.
SELECT *
FROM BOOKS
WHERE PublicationYear<2000 
ORDER BY PublicationYear DESC

-- Identify the highest and lowest-priced books in the library along with their titles and prices.

-- Highest priced book
SELECT Title, Price  
FROM Books  
WHERE Price = (SELECT MAX(Price) FROM BOOKS)


-- Lowest priced book
SELECT Title, Price  
FROM Books  
WHERE Price = (SELECT MIN(Price) FROM Books)

-- Extract and display the first three characters of each book title, ensuring that duplicate entries are removed from the results.
SELECT DISTINCT LEFT(Title, 3) AS F3  
FROM Books;

-- List all books that have the word &quot;Advanced&quot; in their title, sorted alphabetically.
SELECT Title
FROM BOOKS
WHERE Title LIKE '%Advanced%'  
ORDER BY Title ASC

-- Convert and display all book titles in uppercase format and order them by title length in descending order.
SELECT UPPER(TITLE) 
FROM BOOKS
ORDER BY  LEN(Title) DESC

-- Compute the total cost of all books available in the library, rounding the result to two decimal places.
SELECT ROUND(SUM(Price), 2)  
FROM Books;
 
-- Determine the total number of years since each book was published and display the book title along with its age.
SELECT Title, YEAR(GETDATE()) - PublicationYear  AS Book_Age
FROM Books;

-- Identify books that were published within the last 10 years and order the results by the most recent publication year.
SELECT *
FROM BOOKS
WHERE PublicationYear >= YEAR(GETDATE()) - 10  
ORDER BY PublicationYear  DESC 

-- Retrieve the most recent borrow date from the records, ensuring that the result is displayed in MM-DD-YYYY format.
SELECT FORMAT(MAX(Return_Date), 'MM-dd-yyyy')   
FROM BORROWINGS  

-- List books that have been borrowed for more than 30 days before being returned, including the book title and the number of days borrowed. (hint: use sub-query)
SELECT B.Title  ,DATEDIFF(DAY, BR.BorrowDate, BR.Return_Date) AS Days_Borrowed
FROM Books B ,BORROWINGS BR
WHERE  
    B.Book_Id = BR.Book_Id
    AND br.Return_Date IS NOT NULL
    AND DATEDIFF(DAY, BR.BorrowDate, BR.Return_Date) > 30;



-- Find books that are priced higher than the overall average book price in the library.
SELECT Title
FROM BOOKS
WHERE Price > (SELECT AVG(Price) FROM BOOKS )

-- Retrieve the absolute price difference between the most expensive and the least expensive book in the library as PriceDifference.
SELECT ABS(MAX(Price) - MIN(Price))  
FROM Books;

-- Find and display books that have never been borrowed, ensuring the results include the book title and genre.
SELECT Title, Genere  
FROM Books  
WHERE Book_Id NOT IN (SELECT DISTINCT Book_Id FROM BORROWINGS);

-- Display all the books that have the least price in library. 

SELECT Title
FROM Books  
WHERE Price = (SELECT MIN(Price) FROM Books);

-- Find the books whose price is greater than the book titled ‘The Famous Five’ and belongs to the same genre.
SELECT Title
FROM Books  
WHERE Genere = (SELECT Genere FROM Books WHERE Title = 'The Famous Five')  
AND Price > (SELECT Price FROM Books WHERE Title = 'The Famous Five');
