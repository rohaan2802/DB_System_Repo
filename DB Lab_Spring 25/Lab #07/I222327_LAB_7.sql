
--1.	Write a query to display the number of orders placed by each customer.

SELECT O.CustomerID, COUNT(*) AS Order_Count
FROM Orders O
GROUP BY O.CustomerID

--2.	Write a query to display the average unit price of products in each category.

SELECT CategoryID ,AVG(UnitPrice) AS AVERAGE_PRICE
FROM Products 
GROUP BY CategoryID

SELECT P.CategoryID ,(SELECT C.CategoryName FROM Categories C WHERE C.CategoryID=P.CategoryID) AS CategoryName,AVG(UnitPrice) AS AVERAGE_PRICE
FROM Products P
GROUP BY P.CategoryID


--3.	Write a query to display customers who have placed more than 6 orders.

SELECT O.CustomerID,COUNT(OrderID) AS Total_Orders
FROM Orders O
GROUP BY O.CustomerID
HAVING COUNT(OrderID)>6


SELECT O.CustomerID,(SELECT ContactName FROM Customers C WHERE C.CustomerID = O.CustomerID) AS CustomerName, COUNT(O.OrderID) AS Total_Orders
FROM Orders O
GROUP BY O.CustomerID
HAVING COUNT(OrderID)>6


--4.	Write a query to display the total number of orders placed each year.
SELECT DATEPART(YEAR,O.OrderDate) AS Order_Year,COUNT(O.OrderID) AS TOTAL_ORDERS
FROM Orders O 
GROUP BY DATEPART(YEAR,O.OrderDate)


--5.	Write a query to find the total number of products supplied by each supplier.
SELECT P.SupplierID AS SUPPLIER_ID,(SELECT S.ContactName FROM Suppliers S WHERE S.SupplierID=P.SupplierID) AS SUPPLIER_NAME , COUNT(P.ProductID) AS TOTAL_PRODUCTS
FROM Products P
GROUP BY P.SupplierID

--6.	Write a query to find the months in which more than 50 orders were placed that are also shipped.
SELECT DATENAME(MONTH,O.OrderDate) AS MONTHS, COUNT(O.OrderID) AS ORDERS_COUNT
FROM Orders O
--WHERE O.ShippedDate IS NOT NULL
GROUP BY DATENAME(MONTH,O.OrderDate)
HAVING COUNT(O.OrderID)>50


--7.	Write a query to find the customers who haven't placed any orders.

SELECT C.CustomerID AS CUSTOMER_ID,C.ContactName AS CUSTOMER_NAME
FROM Customers C
WHERE C.CustomerID NOT IN (SELECT O.CustomerID FROM Orders O WHERE C.CustomerID=O.CustomerID)


--8.	Write a query to find the products that have never been ordered.

SELECT P.ProductName
FROM Products P
WHERE P.ProductID NOT IN (SELECT O.ProductID FROM [Order Details] O WHERE P.ProductID=O.ProductID)


--9.	Write a query to find the average number of units ordered for each product.

SELECT P.ProductName, (SELECT AVG(Quantity) FROM [Order Details] O WHERE O.ProductID = P.ProductID) AS Average_Units_Ordered
FROM Products P;


--10.	Write a query to list employees who have been hired after January 1, 1995.

SELECT E.EmployeeID,E.FirstName,E.LastName,E.HireDate
FROM Employees E
WHERE E.HireDate > '1995-01-01'


--11.	Write a query to find the products that have been discontinued.

SELECT P.ProductID,P.ProductName
FROM Products P
WHERE P.Discontinued=1


--12.	Write a query to find the total number of units in stock for each category.

SELECT P.CategoryID,(SELECT C.CategoryName FROM Categories C WHERE C.CategoryID=P.CategoryID),SUM(P.UnitsInStock) AS UnitsInStock
FROM Products P
GROUP BY P.CategoryID


--13.	Find a product whose unit price is more than the average unit price of each product category.

SELECT P.CategoryID,P.ProductName,P.UnitPrice
FROM Products P
WHERE P.UnitPrice>(SELECT AVG(P1.UnitPrice) FROM Products P1 WHERE P1.CategoryID=P.CategoryID GROUP BY P1.CategoryID)


--14.	Find all products that have a price higher than the average price in their category.

SELECT P.CategoryID,P.ProductName,P.UnitPrice
FROM Products P
WHERE P.UnitPrice>(SELECT AVG(P1.UnitPrice) FROM Products P1 WHERE P1.CategoryID=P.CategoryID GROUP BY P1.CategoryID)


--15.	Without sorting the data, retrieve the employees whose hire date is earlier than all their subordinates (employees reporting to them).

SELECT EmployeeID, FirstName, LastName, HireDate
FROM Employees e1
WHERE HireDate < ALL (
    SELECT HireDate
    FROM Employees
    WHERE ReportsTo = e1.EmployeeID
);



--16.	Find all customers who placed an order for a product supplied by "Exotic Liquids". (check tables Customers, Orders, OrderDetails, Products, and Suppliers)

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    WHERE o.OrderID IN (
        SELECT od.OrderID
        FROM [Order Details] od
        WHERE od.ProductID IN (
            SELECT p.ProductID
            FROM Products p
            WHERE p.SupplierID = (
                SELECT s.SupplierID
                FROM Suppliers s
                WHERE s.CompanyName = 'Exotic Liquids'
            )
        )
    )
)
