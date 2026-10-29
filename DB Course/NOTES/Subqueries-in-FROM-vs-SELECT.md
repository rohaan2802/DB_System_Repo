# Subqueries in FROM vs SELECT

## Derived table (subquery in FROM)
The inner query acts as a temporary table that feeds the outer query; only the outer SELECT list appears in the result.
```sql
SELECT dep_name, AVG(salary) AS avg_salary
FROM (SELECT dep_name, salary FROM Employees) AS TempTable
GROUP BY dep_name;
```

## Scalar subquery (subquery in SELECT)
Runs for each row of the outer query and its value **is** shown as a column.
```sql
SELECT CustomerID,
       (SELECT FullName FROM Customers c WHERE c.CustomerID = o.CustomerID) AS CustomerName,
       COUNT(OrderID) AS TotalOrders
FROM Orders o
GROUP BY CustomerID
HAVING COUNT(OrderID) > 6;
```
A scalar subquery must return a single value per row.

| Position | Result shown in output? | Role |
|---|---|---|
| FROM | No (only through outer SELECT) | Source data |
| SELECT | Yes | Computed column |
| WHERE / HAVING | No | Filter |
