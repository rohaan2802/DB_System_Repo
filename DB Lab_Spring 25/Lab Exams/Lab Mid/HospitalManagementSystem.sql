/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'HospitalManagementSystem')
BEGIN
	ALTER DATABASE [HospitalManagementSystem] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [HospitalManagementSystem] SET ONLINE;
	DROP DATABASE [HospitalManagementSystem];
END
GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE [HospitalManagementSystem];
GO

USE [HospitalManagementSystem];
GO

/*******************************************************************************
   Create Tables
********************************************************************************/

CREATE TABLE Patients (
    PatientID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    ContactNumber VARCHAR(15),
    Address TEXT,
    BloodType VARCHAR(5),
    EmergencyContact VARCHAR(50),
    CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED (PatientID)
);
GO

CREATE TABLE Doctors (
    DoctorID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialization VARCHAR(100),
    ContactNumber VARCHAR(15),
    Email VARCHAR(100),
    Department VARCHAR(50),
    CONSTRAINT [PK_Doctor] PRIMARY KEY CLUSTERED (DoctorID)
);
GO

CREATE TABLE Appointments (
    AppointmentID INT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Status VARCHAR(10) CHECK (Status IN('Scheduled', 'Completed', 'Cancelled')),
    Notes TEXT,
    CONSTRAINT [PK_Appointment] PRIMARY KEY CLUSTERED (AppointmentID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
GO

CREATE TABLE MedicalRecords (
    RecordID INT,
    PatientID INT,
    DoctorID INT,
    Diagnosis TEXT,
    Treatment TEXT,
    Date DATE,
    CONSTRAINT [PK_MedicalRecord] PRIMARY KEY CLUSTERED (RecordID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
GO


CREATE TABLE Staff (
    StaffID VARCHAR(5),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Role VARCHAR(50),
    Department VARCHAR(50),
    ContactNumber VARCHAR(15),
    CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED (StaffID)
);
GO


CREATE TABLE Rooms (
    RoomID VARCHAR(5),
    StaffID VARCHAR(5),
    RoomType VARCHAR(15) CHECK(RoomType IN ('General', 'ICU', 'Private', 'Semi-Private')),
    AvailabilityStatus VARCHAR(10) CHECK (AvailabilityStatus IN ('Available', 'Occupied')),
    ChargePerDay DECIMAL(10,2),
    CONSTRAINT [PK_Rooms] PRIMARY KEY CLUSTERED (RoomID),
    CONSTRAINT FK_Room_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
GO


CREATE TABLE Admissions (
    AdmissionID INT,
    PatientID INT,
    RoomID VARCHAR(5),
    AdmissionDate DATE,
    DischargeDate DATE,
    CONSTRAINT [PK_Admission] PRIMARY KEY CLUSTERED (AdmissionID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);
GO


CREATE TABLE Billing (
    BillID INT,
    PatientID INT,
    StaffID VARCHAR(5),
    Amount DECIMAL(10,2),
    PaymentStatus VARCHAR(10) CHECK (PaymentStatus IN('Paid', 'Unpaid', 'Pending')),
    BillingDate DATE,
    CONSTRAINT [PK_Billing] PRIMARY KEY CLUSTERED (BillID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_Billing_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
GO

/*******************************************************************************
   Populate Tables
********************************************************************************/

INSERT INTO Patients (PatientID, FirstName, LastName, DOB, Gender, ContactNumber, Address, BloodType, EmergencyContact) VALUES
(1, 'John', 'Doe', '1985-06-15', 'Male', '1234567890', '123 Elm Street, NY', 'O+', 'Jane Doe - 9876543210'),
(2, 'Emily', 'Smith', '1992-09-21', 'Female', '9876543210', '456 Oak Street, LA', 'A-', 'Michael Smith - 1231231234'),
(3, 'Raj', 'Kumar', '1978-03-10', 'Male', '8745632100', '789 Maple Street, TX', 'B+', 'Anita Kumar - 7418529630'),
(4, 'Sophia', 'Garcia', '2000-11-25', 'Female', '7418529630', '567 Pine Street, FL', 'AB+', 'Carlos Garcia - 8529637410'),
(5, 'Ali', 'Khan', '1995-07-14', 'Male', '9632587410', '951 Cedar Street, IL', 'O-', 'Sara Khan - 7531598520'),
(6, 'Alice', 'Johnson', '1975-12-10', 'Female', '3456789012', '789 Oak St, Capital City', 'O+', 'Bob Johnson'),
(7, 'Bob', 'Brown', '1980-03-22', 'Male', '4567890123', '321 Pine St, Ogdenville', 'AB+', 'Alice Brown'),
(8, 'Charlie', 'Davis', '1995-07-30', 'Male', '5678901234', '654 Maple St, North Haverbrook', 'A-', 'Eve Davis'),
(9, 'Eve', 'Miller', '1988-11-05', 'Female', '6789012345', '987 Birch St, Brockway', 'B+', 'Charlie Miller'),
(10, 'Frank', 'Wilson', '1970-09-18', 'Male', '7890123456', '147 Cedar St, Ogdenville', 'O-', 'Grace Wilson'),
(11, 'Grace', 'Moore', '1982-04-12', 'Female', '8901234567', '258 Walnut St, Springfield', 'AB-', 'Frank Moore'),
(12, 'Henry', 'Taylor', '1992-06-20', 'Male', '9012345678', '369 Spruce St, Shelbyville', 'A+', 'Ivy Taylor'),
(13, 'Ivy', 'Anderson', '1987-02-28', 'Female', '0123456789', '741 Cherry St, Capital City', 'B-', 'Henry Anderson'),
(14, 'Jack', 'Thomas', '1978-10-15', 'Male', '1234509876', '852 Willow St, North Haverbrook', 'O+', 'Karen Thomas'),
(15, 'Karen', 'Jackson', '1993-01-25', 'Female', '2345610987', '963 Ash St, Brockway', 'AB+', 'Jack Jackson'),
(16, 'Leo', 'White', '1984-07-07', 'Male', '3456721098', '159 Poplar St, Ogdenville', 'A-', 'Mia White'),
(17, 'Mia', 'Harris', '1973-12-30', 'Female', '4567832109', '357 Birch St, Springfield', 'B+', 'Leo Harris'),
(18, 'Noah', 'Martin', '1998-03-10', 'Male', '5678943210', '753 Oak St, Shelbyville', 'O-', 'Olivia Martin'),
(19, 'Olivia', 'Thompson', '1989-05-20', 'Female', '6789054321', '951 Pine St, Capital City', 'AB-', 'Noah Thompson'),
(20, 'Peter', 'Garcia', '1976-08-12', 'Male', '7890165432', '852 Maple St, North Haverbrook', 'A+', 'Quinn Garcia');
GO


INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialization, ContactNumber, Email, Department) VALUES
(101, 'Dr. Sarah', 'Miller', 'Cardiology', '7418529630', 'sarah.miller@hospital.com', 'Cardiology'),
(102, 'Dr. James', 'Anderson', 'Neurology', '8529637410', 'james.anderson@hospital.com', 'Neurology'),
(103, 'Dr. Priya', 'Sharma', 'Orthopedics', '9632587410', 'priya.sharma@hospital.com', 'Orthopedics'),
(104, 'Dr. Miguel', 'Lopez', 'Pediatrics', '7531598520', 'miguel.lopez@hospital.com', 'Pediatrics'),
(105, 'Dr. Anna', 'Brown', 'General Medicine', '9513578520', 'anna.brown@hospital.com', 'General Medicine'),
(106, 'Dr. Michael', 'Scott', 'Cardiology', '1234567890', 'michael.scott@hospital.com', 'Cardiology'),
(107, 'Dr. Pam', 'Beesly', 'Pediatrics', '2345678901', 'pam.beesly@hospital.com', 'Pediatrics'),
(108, 'Dr. Jim', 'Halpert', 'Orthopedics', '3456789012', 'jim.halpert@hospital.com', 'Orthopedics'),
(109, 'Dr. Dwight', 'Schrute', 'Neurology', '4567890123', 'dwight.schrute@hospital.com', 'Neurology'),
(110, 'Dr. Angela', 'Martin', 'Dermatology', '5678901234', 'angela.martin@hospital.com', 'Dermatology'),
(111, 'Dr. Kevin', 'Malone', 'Oncology', '6789012345', 'kevin.malone@hospital.com', 'Oncology'),
(112, 'Dr. Oscar', 'Martinez', 'Gastroenterology', '7890123456', 'oscar.martinez@hospital.com', 'Gastroenterology'),
(113, 'Dr. Phyllis', 'Vance', 'Psychiatry', '8901234567', 'phyllis.vance@hospital.com', 'Psychiatry'),
(114, 'Dr. Stanley', 'Hudson', 'Radiology', '9012345678', 'stanley.hudson@hospital.com', 'Radiology'),
(115, 'Dr. Meredith', 'Palmer', 'Endocrinology', '0123456789', 'meredith.palmer@hospital.com', 'Endocrinology'),
(116, 'Dr. Creed', 'Bratton', 'Urology', '1234509876', 'creed.bratton@hospital.com', 'Urology'),
(117, 'Dr. Ryan', 'Howard', 'Pulmonology', '2345610987', 'ryan.howard@hospital.com', 'Pulmonology'),
(118, 'Dr. Kelly', 'Kapoor', 'Hematology', '3456721098', 'kelly.kapoor@hospital.com', 'Hematology'),
(119, 'Dr. Andy', 'Bernard', 'Nephrology', '4567832109', 'andy.bernard@hospital.com', 'Nephrology'),
(120, 'Dr. Toby', 'Flenderson', 'Infectious Diseases', '5678943210', 'toby.flenderson@hospital.com', 'Infectious Diseases');
GO


INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Status, Notes) VALUES
(1001, 1, 101, '2025-04-10 10:00:00', 'Scheduled', 'Routine heart checkup'),
(1002, 2, 102, '2025-04-12 14:30:00', 'Scheduled', 'Migraine consultation'),
(1003, 3, 103, '2025-04-15 11:00:00', 'Completed', 'Knee pain treatment'),
(1004, 4, 104, '2025-04-20 09:00:00', 'Cancelled', 'Child vaccination - rescheduled'),
(1005, 5, 109, '2025-04-25 16:00:00', 'Scheduled', 'General health checkup'),
(1006, 6, 106, '2023-10-01 09:00:00', 'Scheduled', 'Routine checkup'),
(1007, 1, 107, '2023-10-02 10:00:00', 'Completed', 'Vaccination'),
(1008, 8, 108, '2023-10-03 11:00:00', 'Cancelled', 'Rescheduled'),
(1009, 9, 109, '2023-10-04 12:00:00', 'Scheduled', 'Follow-up'),
(1010, 10, 110, '2023-10-05 13:00:00', 'Completed', 'Skin check'),
(1011, 11, 111, '2023-10-06 14:00:00', 'Scheduled', 'Chemotherapy'),
(1012, 12, 112, '2023-10-07 15:00:00', 'Completed', 'Endoscopy'),
(1013, 13, 113, '2023-10-08 16:00:00', 'Scheduled', 'Therapy session'),
(1014, 1, 101, '2023-10-09 17:00:00', 'Completed', 'X-ray'),
(1015, 15, 115, '2023-10-10 18:00:00', 'Scheduled', 'Diabetes management'),
(1016, 16, 109, '2023-10-11 19:00:00', 'Completed', 'Kidney check'),
(1017, 17, 117, '2023-10-12 20:00:00', 'Scheduled', 'Lung function test'),
(1018, 18, 118, '2023-10-13 21:00:00', 'Completed', 'Blood test'),
(1019, 19, 119, '2023-10-14 22:00:00', 'Scheduled', 'Kidney function test'),
(1020, 20, 109, '2023-10-15 23:00:00', 'Completed', 'Infection treatment');
GO


INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, Diagnosis, Treatment, Date) VALUES
(2001, 1, 101, 'High Blood Pressure', 'Prescribed medication and lifestyle changes', '2025-04-10'),
(2002, 2, 102, 'Migraine', 'Advised stress management and prescribed pain relievers', '2025-04-12'),
(2003, 3, 103, 'Arthritis in knee', 'Physical therapy and pain management', '2025-04-15'),
(2004, 4, 104, 'Common cold', 'Rest, hydration, and over-the-counter medicine', '2025-04-18'),
(2005, 5, 105, 'Routine checkup - No issues', 'Maintain current lifestyle', '2025-04-25'),
(2006, 6, 106, 'Hypertension', 'Prescribed medication', '2023-10-01'),
(2007, 7, 107, 'Common cold', 'Rest and hydration', '2023-10-02'),
(2008, 8, 108, 'Fractured arm', 'Cast applied', '2023-10-03'),
(2009, 9, 109, 'Migraine', 'Prescribed painkillers', '2023-10-04'),
(2010, 1, 110, 'Eczema', 'Topical cream', '2023-10-05'),
(2011, 1, 111, 'Lung cancer', 'Chemotherapy', '2023-10-06'),
(2012, 12, 112, 'Ulcer', 'Antibiotics', '2023-10-07'),
(2013, 13, 113, 'Depression', 'Therapy sessions', '2023-10-08'),
(2014, 14, 114, 'Broken rib', 'Pain management', '2023-10-09'),
(2015, 15, 115, 'Diabetes', 'Insulin therapy', '2023-10-10'),
(2016, 16, 116, 'Kidney stones', 'Surgery', '2023-10-11'),
(2017, 3, 103, 'Asthma', 'Inhaler prescribed', '2023-10-12'),
(2018, 18, 118, 'Anemia', 'Iron supplements', '2023-10-13'),
(2019, 19, 119, 'Kidney infection', 'Antibiotics', '2023-10-14'),
(2020, 20, 120, 'Flu', 'Antiviral medication', '2023-10-15');
GO


INSERT INTO Staff (StaffID, FirstName, LastName, Role, Department, ContactNumber) VALUES
('S001', 'John', 'Clark', 'Nurse', 'Emergency', '7418529630'),
('S002', 'Sophia', 'Williams', 'Lab Technician', 'Pathology', '8529637410'),
('S003', 'Daniel', 'Johnson', 'Receptionist', 'Front Desk', '9632587410'),
('S004', 'Emma', 'Davis', 'Pharmacist', 'Pharmacy', '7531598520'),
('S005', 'Oliver', 'Brown', 'Administrator', 'Management', '9513578520'),
('S006', 'Sarah', 'Connor', 'Nurse', 'Cardiology', '1234567890'),
('S007', 'John', 'Wick', 'Nurse', 'Pediatrics', '2345678901'),
('S008', 'Emma', 'Watson', 'Receptionist', 'Administration', '3456789012'),
('S009', 'Bruce', 'Wayne', 'Lab Technician', 'Pathology', '4567890123'),
('S010', 'Diana', 'Prince', 'Pharmacist', 'Pharmacy', '5678901234'),
('S011', 'Clark', 'Kent', 'Radiologist', 'Radiology', '6789012345'),
('S012', 'Tony', 'Stark', 'Surgeon', 'Surgery', '7890123456'),
('S013', 'Natasha', 'Romanoff', 'Nurse', 'Emergency', '8901234567'),
('S014', 'Steve', 'Rogers', 'Physiotherapist', 'Rehabilitation', '9012345678'),
('S015', 'Peter', 'Parker', 'Intern', 'General Medicine', '0123456789'),
('S016', 'Wanda', 'Maximoff', 'Psychologist', 'Psychiatry', '1234509876'),
('S017', 'Thor', 'Odinson', 'Dietician', 'Nutrition', '2345610987'),
('S018', 'Loki', 'Laufeyson', 'IT Support', 'IT', '3456721098'),
('S019', 'Pepper', 'Potts', 'HR Manager', 'Human Resources', '4567832109'),
('S020', 'Nick', 'Fury', 'Security Head', 'Security', '5678943210');
GO


INSERT INTO Rooms (RoomID, RoomType, AvailabilityStatus, ChargePerDay, StaffID) VALUES
('A101', 'General', 'Available', 100.00, 'S001'),
('B220', 'ICU', 'Occupied', 500.00, 'S002'),
('C305', 'Private', 'Available', 300.00, 'S003'),
('D412', 'Semi-Private', 'Available', 200.00, 'S004'),
('E520', 'General', 'Occupied', 100.00, 'S005'),
('F630', 'ICU', 'Available', 500.00, 'S006'),
('G740', 'Private', 'Occupied', 300.00, 'S007'),
('H850', 'Private', 'Available', 200.00, 'S008'),
('I960', 'General', 'Available', 100.00, 'S009'),
('J107', 'ICU', 'Occupied', 500.00, 'S010'),
('K208', 'Private', 'Available', 300.00, 'S011'),
('L309', 'Semi-Private', 'Occupied', 200.00, 'S012'),
('M410', 'General', 'Available', 100.00, 'S013'),
('N511', 'ICU', 'Occupied', 500.00, 'S014'),
('O612', 'Private', 'Available', 300.00, 'S015'),
('P713', 'Semi-Private', 'Occupied', 200.00, 'S016'),
('Q814', 'General', 'Available', 100.00, 'S017'),
('R915', 'ICU', 'Occupied', 500.00, 'S018'),
('S016', 'Private', 'Available', 300.00, 'S019'),
('T117', 'Semi-Private', 'Occupied', 200.00, 'S020');
GO


INSERT INTO Admissions (AdmissionID, PatientID, RoomID, AdmissionDate, DischargeDate) VALUES
(4001, 1, 'B220', '2025-04-08', NULL),
(4002, 2, 'C305', '2025-04-10', '2025-04-15'),
(4003, 3, 'E520', '2025-04-12', NULL),
(4004, 4, 'A101', '2025-04-18', '2025-04-20'),
(4005, 5, 'D412', '2025-04-22', NULL),
(4006, 6, 'F630', '2023-10-01', '2023-10-05'),
(4007, 7, 'G740', '2023-10-02', '2023-10-06'),
(4008, 2, 'H850', '2023-10-03', '2023-10-07'),
(4009, 9, 'I960', '2023-10-04', NULL),
(4010, 10, 'J107', '2023-10-05', '2023-10-09'),
(4011, 11, 'K208', '2023-10-06', '2023-10-10'),
(4012, 12, 'L309', '2023-10-07', '2023-10-11'),
(4013, 13, 'M410', '2023-10-08', '2023-10-12'),
(4014, 14, 'N511', '2023-10-09', '2023-10-13'),
(4015, 4, 'O612', '2023-10-10', '2023-10-14'),
(4016, 16, 'P713', '2023-10-11', '2023-10-15'),
(4017, 17, 'Q814', '2023-10-12', '2023-10-16'),
(4018, 18, 'R915', '2023-10-13', '2023-10-17'),
(4019, 19, 'S016', '2023-10-14', '2023-10-18'),
(4020, 20, 'T117', '2023-10-15', '2023-10-19');
GO


INSERT INTO Billing (BillID, PatientID, Amount, PaymentStatus, BillingDate, StaffID) VALUES
(3001, 1, 200.00, 'Paid', '2025-04-10', 'S001'),
(3002, 2, 150.50, 'Unpaid', '2025-04-12', 'S002'),
(3003, 3, 300.75, 'Paid', '2025-04-15', 'S003'),
(3004, 4, 50.00, 'Pending', '2025-04-18', 'S004'),
(3005, 5, 100.00, 'Paid', '2025-04-25', 'S005'),
(3006, 6, 200.00, 'Paid', '2023-10-01', 'S006'),
(3007, 7, 150.00, 'Unpaid', '2023-10-02', 'S007'),
(3008, 8, 300.00, 'Pending', '2023-10-03', 'S008'),
(3009, 9, 250.00, 'Paid', '2023-10-04', 'S009'),
(3010, 10, 100.00, 'Unpaid', '2023-10-05', 'S010'),
(3011, 11, 500.00, 'Pending', '2023-10-06', 'S011'),
(3012, 12, 400.00, 'Paid', '2023-10-07', 'S012'),
(3013, 5, 350.00, 'Unpaid', '2023-10-08', 'S013'),
(3014, 14, 450.00, 'Pending', '2023-10-09', 'S014'),
(3015, 15, 200.00, 'Paid', '2023-10-10', 'S015'),
(3016, 16, 600.00, 'Unpaid', '2023-10-11', 'S016'),
(3017, 5, 550.00, 'Pending', '2023-10-12', 'S017'),
(3018, 18, 300.00, 'Paid', '2023-10-13', 'S018'),
(3019, 19, 700.00, 'Unpaid', '2023-10-14', 'S019'),
(3020, 20, 400.00, 'Pending', '2023-10-15', 'S020');
GO