/* ============================================================
   SuperStoreDB — Lab 12 (i222327)
   ============================================================ */

USE master;
GO

DROP DATABASE IF EXISTS SuperStoreDB;
GO

CREATE DATABASE SuperStoreDB;
GO

USE SuperStoreDB;
GO

/* --- Supplier --- */
CREATE TABLE Supplier (
    SupId       INT PRIMARY KEY,
    SupName     VARCHAR(100) NOT NULL,
    TelNo       VARCHAR(20)  NOT NULL,
    City        VARCHAR(50)  NULL,
    Address     VARCHAR(255) NULL
);
GO

/* --- Product --- */
CREATE TABLE Product (
    Pid         INT PRIMARY KEY,
    PName       VARCHAR(100) NOT NULL,
    PPrice      DECIMAL(10, 2) NOT NULL,
    PQty        INT NOT NULL
);
GO

/* --- Customer --- */
CREATE TABLE Customer (
    Cid         INT PRIMARY KEY,
    CName       VARCHAR(100) NOT NULL,
    City        VARCHAR(50)  NULL,
    Address     VARCHAR(255) NULL,
    TelNo       VARCHAR(20)  NOT NULL
);
GO

/* --- Employee --- */
CREATE TABLE Employee (
    Empid       INT PRIMARY KEY,
    EmpName     VARCHAR(100) NOT NULL,
    City        VARCHAR(50)  NULL,
    Address     VARCHAR(255) NULL,
    TelNo       VARCHAR(20)  NOT NULL
);
GO

/* --- Shipper --- */
CREATE TABLE Shipper (
    Shpid       INT PRIMARY KEY,
    ShpName     VARCHAR(100) NOT NULL,
    City        VARCHAR(50)  NULL,
    Address     VARCHAR(255) NULL,
    TelNo       VARCHAR(20)  NOT NULL
);
GO

/* --- Invoice --- */
CREATE TABLE Invoice (
    [Inv#]        INT IDENTITY(1,1) PRIMARY KEY,
    Cid           INT NULL,
    InvDate       DATE NULL,
    TotalAmount   DECIMAL(10, 2) NULL,
    Empid         INT NULL,
    Shipid        INT NULL,
    FOREIGN KEY (Cid)     REFERENCES Customer(Cid),
    FOREIGN KEY (Empid)   REFERENCES Employee(Empid),
    FOREIGN KEY (Shipid)  REFERENCES Shipper(Shpid)
);
GO

/* --- OrderDetail --- */
CREATE TABLE OrderDetail (
    [Inv#]        INT NOT NULL,
    Pid           INT NOT NULL,
    Qty           INT NOT NULL,
    SPrice        DECIMAL(10, 2) NOT NULL,
    ExtendPrice   DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY ([Inv#], Pid),
    FOREIGN KEY ([Inv#]) REFERENCES Invoice([Inv#]),
    FOREIGN KEY (Pid)    REFERENCES Product(Pid)
);
GO

/* --- StockInRec --- */
CREATE TABLE StockInRec (
    SInv#         INT PRIMARY KEY,
    SInvDate      DATE NULL,
    TotalQtyPrice DECIMAL(10, 2) NULL,
    Discount      DECIMAL(10, 2) NULL,
    SupId         INT NULL,
    FOREIGN KEY (SupId) REFERENCES Supplier(SupId)
);
GO

/* --- StockInDetail --- */
CREATE TABLE StockInDetail (
    SInv#   INT NOT NULL,
    Pid     INT NOT NULL,
    QtyRec  INT NOT NULL,
    PPrice  DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (SInv#, Pid),
    FOREIGN KEY (SInv#) REFERENCES StockInRec(SInv#),
    FOREIGN KEY (Pid)   REFERENCES Product(Pid)
);
GO

/* ============================================================
                        Sample data
   ============================================================ */

INSERT INTO Supplier (SupId, SupName, TelNo, City, Address)
VALUES
(1, 'Tech Supplies Inc.', '800-123-4567', 'Los Angeles', '123 Supply St, CA');

INSERT INTO Customer (Cid, CName, City, Address, TelNo)
VALUES
(1, 'John Doe', 'New York', '123 Elm Street, NY', '123-456-7890');

INSERT INTO Employee (Empid, EmpName, City, Address, TelNo)
VALUES
(1, 'Alice Brown', 'Chicago', '789 Pine Road, IL', '111-222-3333');

INSERT INTO Product (Pid, PName, PPrice, PQty)
VALUES
(1, 'Laptop', 1200.00, 50),
(2, 'Phone', 700.00, 100);

INSERT INTO Shipper (Shpid, ShpName, City, Address, TelNo)
VALUES
(1, 'FedEx', 'New York', '123 FedEx St', '123-321-4567');

INSERT INTO Invoice (Cid, InvDate, TotalAmount, Empid, Shipid)
VALUES
(1, '2026-05-01', 1900.00, 1, 1);

INSERT INTO OrderDetail ([Inv#], Pid, Qty, SPrice, ExtendPrice)
VALUES
(1, 1, 1, 1200.00, 1200.00),
(1, 2, 1, 700.00, 700.00);
