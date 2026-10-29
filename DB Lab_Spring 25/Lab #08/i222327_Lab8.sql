-- 1. Provide the order ids of all orders that are shipped using ‘Federal Shipping’.

SELECT o.OrderID
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE s.CompanyName = 'Federal Shipping';


--2. Select the name, address, city, and region of Customers that have placed orders to be delivered in Madrid.

SELECT C.ContactName, C.Address,C.City,C.Region
FROM Customers C
JOIN Orders o ON C.CustomerID = o.CustomerID
WHERE o.ShipCity = 'Madrid';



--3. Extract the ids and the names in upper case for customers who haven’t placed any orders yet.

SELECT c.CustomerID, UPPER(c.CompanyName) AS CompanyName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;
--"JOIN automatically makes it NULL logically when there’s no match."



--4. Find the total number of products ordered from each supplier, including suppliers who have not supplied any products.

SELECT s.SupplierID, s.CompanyName, SUM(od.Quantity) AS Total_Quantity_Ordered
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.CompanyName;


--5. Provide the names of the customers and their cities who belong to the same city as the employee who processed their order. Also display the full names of the employees.

SELECT c.ContactName AS CustomerName, c.City, e.FirstName + ' ' + e.LastName AS EmployeeFullName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE c.City = e.City;


--6. Display the employees (managers) who manage at least 3 employees.

SELECT e.ReportsTo AS ManagerID, m.FirstName + ' ' + m.LastName AS ManagerName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees e
JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY e.ReportsTo, m.FirstName, m.LastName
HAVING COUNT(e.EmployeeID) >= 3;

--7. Fetch top 5 most popular products, products that have the maximum quantity of units sold.

SELECT TOP 5 p.ProductName, SUM(od.Quantity) AS Total_Units_Sold
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName

--8. Create a view to find the total number of products ordered by each customer.

CREATE VIEW Customer_Total_Products AS
SELECT o.CustomerID, c.ContactName, SUM(od.Quantity) AS TotalProducts
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, c.ContactName;


DROP VIEW Customer_Total_Products

SELECT * FROM Customer_Total_Products

--9. Find all products and their corresponding supplier names, but only return products that have not been discontinued.

SELECT p.ProductName, s.CompanyName AS SupplierName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.Discontinued = 0;


--10. Retrieve the most recent order (by order date) placed by each customer.

SELECT o.CustomerID, c.ContactName, MAX(o.OrderDate) AS MostRecentOrder
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY o.CustomerID, c.ContactName;

--11. Identify employees who have processed more than 10 orders for any individual customer.

SELECT o.EmployeeID, e.FirstName , o.CustomerID, COUNT(o.OrderID) AS OrderCount
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY o.EmployeeID, e.FirstName, e.LastName, o.CustomerID
HAVING COUNT(o.OrderID) > 10;


--12. List all products where the total quantity ordered exceeds 100 units.

SELECT p.ProductName, SUM(od.Quantity) AS Total_Units_Ordered
FROM [Order Details] od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING SUM(od.Quantity) > 100


--13. Find suppliers that have supplied products to orders shipped by a specific shipper.(e.g., ShipperID = 1)

SELECT DISTINCT s.SupplierID, s.CompanyName
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.ShipVia = 1;


--14. Find employees who have handled orders for customers in the same country as the employee.

SELECT DISTINCT e.EmployeeID, e.FirstName , e.Country AS EmployeeCountry, c.Country AS CustomerCountry
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE e.Country = c.Country

--15. Create a view to retrieve the most expensive product from each category.

CREATE VIEW MostExpensiveProductPerCategory AS
SELECT p.CategoryID, c.CategoryName, p.ProductName, p.UnitPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice = (SELECT MAX(UnitPrice) FROM Products WHERE CategoryID = p.CategoryID);


DROP VIEW MostExpensiveProductPerCategory

SELECT * FROM MostExpensiveProductPerCategory
