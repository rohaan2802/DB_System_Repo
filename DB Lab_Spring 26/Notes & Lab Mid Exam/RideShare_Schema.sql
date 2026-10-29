-- ============================================
-- Database: RideShare DB
-- Course: Database Systems Lab (CL2005)
-- Sessional 1 Exam
-- FAST NUCES Islamabad | Fall 2026
-- ============================================

-- Create and use database
CREATE DATABASE RideShareDB;
GO
USE RideShareDB;
GO

-- ============================================
-- TABLE CREATION
-- ============================================

-- Region Table
CREATE TABLE Region (
    region_id   INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL
);

-- Driver Table
CREATE TABLE Driver (
    driver_id    INT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    rating       DECIMAL(3,1) NOT NULL,
    vehicle_type VARCHAR(50)  NOT NULL,
    region_id    INT NOT NULL,
    CONSTRAINT FK_Driver_Region FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Rider Table
CREATE TABLE Rider (
    rider_id  INT PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    region_id INT NOT NULL,
    CONSTRAINT FK_Rider_Region FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Ride Table
CREATE TABLE Ride (
    ride_id    INT PRIMARY KEY,
    driver_id  INT NOT NULL,
    rider_id   INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time   DATETIME NOT NULL,
    distance   DECIMAL(5,1) NOT NULL,
    fare       DECIMAL(8,2) NOT NULL,
    status     VARCHAR(20)  NOT NULL,
    CONSTRAINT FK_Ride_Driver FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT FK_Ride_Rider  FOREIGN KEY (rider_id)  REFERENCES Rider(rider_id),
    CONSTRAINT CHK_Ride_Status CHECK (status IN ('Completed', 'Canceled'))
);
GO

-- ============================================
-- DATA INSERTION
-- ============================================

-- Region
INSERT INTO Region (region_id, name) VALUES
(1, 'East'),
(2, 'West'),
(3, 'Central');

-- Driver
INSERT INTO Driver (driver_id, name, rating, vehicle_type, region_id) VALUES
(1, 'Khushaal Khan',  4.5, 'Alto',   1),
(2, 'Zubair Malik',   4.9, 'Cultus', 1),
(3, 'Haider Kazmi',   4.1, 'Mehran', 2),
(4, 'Salman Arif',    3.8, 'Corolla',2),
(5, 'Tariq Mehmood',  4.0, 'Vitz',   3);

-- Rider
INSERT INTO Rider (rider_id, name, region_id) VALUES
(1, 'Maryam Khalid',  1),
(2, 'Muhammad Bilal', 2),
(3, 'Aleena Baig',    3),
(4, 'Umair Chaudhry', 1),
(5, 'Zohab Rana',     1),
(6, 'Areesha Noor',   2);

-- Ride
INSERT INTO Ride (ride_id, driver_id, rider_id, start_time, end_time, distance, fare, status) VALUES
(1,  1, 1, '2025-02-22 10:30:00', '2025-02-22 11:00:00', 10.5, 15.00, 'Completed'),
(2,  2, 2, '2025-02-23 11:45:00', '2025-02-23 12:30:00', 15.0, 20.00, 'Completed'),
(3,  1, 3, '2025-01-15 09:25:00', '2025-01-15 10:00:00',  7.5, 12.00, 'Canceled'),
(4,  3, 4, '2025-01-18 14:50:00', '2025-01-18 16:00:00', 12.0, 25.00, 'Completed'),
(5,  2, 1, '2025-03-05 16:30:00', '2025-03-05 17:15:00',  8.0, 10.00, 'Completed'),
(6,  4, 2, '2025-03-08 13:40:00', '2025-03-08 14:30:00', 14.0, 18.00, 'Completed'),
(7,  1, 4, '2025-03-15 09:00:00', '2025-03-15 10:00:00',  6.0,  9.00, 'Completed'),
(8,  2, 3, '2025-02-01 19:30:00', '2025-02-01 20:15:00',  9.0, 14.00, 'Canceled'),
(9,  3, 1, '2025-02-08 17:30:00', '2025-02-08 18:30:00', 10.0, 22.00, 'Completed'),
(10, 4, 6, '2025-02-15 20:30:00', '2025-02-15 21:15:00', 11.5, 19.00, 'Canceled');
GO
