--CREATE DATABASE ECommerce   --Create the Database:
--USE ECommerce

-- Create Tables:

-- Customers Table:
CREATE TABLE Customers
(
CuS_Id INT IDENTITY(1,100) PRIMARY KEY,
CuS_Name VARCHAR(50) NOT NULL,
Cus_Email VARCHAR(50) NOT NULL DEFAULT 'Unknown',
Cus_Phone VARCHAR(11) NOT NULL,
Cus_Address VARCHAR(50) NOT NULL DEFAULT 'Unknown',
Cus_Signup_Date DATE DEFAULT 'Unknown'
);

-- Products Table:
CREATE TABLE Products
(
P_Id INT IDENTITY(1,1001) PRIMARY KEY,
P_Name VARCHAR(50) NOT NULL,
P_Description VARCHAR(255) NOT NULL,
P_Price INT CHECK(P_Price > 0),
P_Stock INT NOT NULL CHECK (P_Stock >0),
P_Category VARCHAR(50),
P_Rating INT NOT NULL CHECK (P_Rating >=0)
);

--Orders Table:
CREATE TABLE Orders
(
O_Id INT IDENTITY(1,1001) PRIMARY KEY,
Cus_Id INT,
FOREIGN KEY(Cus_Id) REFERENCES Customers(Cus_Id),
O_Date DATE NOT NULL,
O_Status VARCHAR(50) CHECK (O_Status IN ('ACTIVE','INACTIVE')),
O_Total_Amount DECIMAL(5,2) CHECK (O_Total_Amount>0) 
);

--OrderDetails Table:

CREATE TABLE Order_Details
(
O_Id INT,
P_Id INT,
O_Date DATE,
--PRIMARY KEY(O_Id, P_Id),
FOREIGN KEY(O_Id) REFERENCES Orders(O_Id),
FOREIGN KEY(P_Id) REFERENCES Products(P_Id),
O_Quantity INT CHECK(O_Quantity>=1),
O_Price_Per_Unit INT CHECK(O_Price_Per_Unit>0),
O_TotaL_Price INT CHECK(O_TotaL_Price>0),
);

-- Payments Table: 

CREATE TABLE Payments
(
Payment_Id INT IDENTITY(1,1001) PRIMARY KEY,
O_Id INT,
FOREIGN KEY(O_Id) REFERENCES Orders(O_Id),
Payment_Date DATE NOT NULL,
O_Payment INT CHECK(O_Payment>0) ,
Payment_Method VARCHAR(50) NOT NULL
);

--Modify Tables:

ALTER TABLE Products ADD Discount INT DEFAULT 0 CHECK(Discount>=0)

-- TO GET THE FOREIGN KEY TO DROP CONSTRAINT


--SELECT name AS ForeignKeyName, 
--OBJECT_NAME(parent_object_id) AS ReferencingTable
--FROM sys.foreign_keys 
--WHERE referenced_object_id = OBJECT_ID('Orders');



-- Truncate and Drop:

ALTER TABLE Orders DROP CONSTRAINT FK__Orders__Cus_Id__02084FDA

ALTER TABLE Order_Details DROP CONSTRAINT FK__Order_Deta__O_Id__05D8E0BE;

ALTER TABLE Payments DROP CONSTRAINT FK__Payments__O_Id__0C85DE4D

TRUNCATE TABLE Customers
TRUNCATE TABLE Orders

DROP TABLE Order_Details;
