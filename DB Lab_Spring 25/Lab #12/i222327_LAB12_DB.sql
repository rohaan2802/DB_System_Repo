-- Step 1: Create the database
CREATE DATABASE Lab12;
GO

-- Step 2: Use the new database
USE Lab12;
GO

-- Step 3: Create the User table
CREATE TABLE User_Table 
(
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    UserPassword VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female')) NOT NULL
);
