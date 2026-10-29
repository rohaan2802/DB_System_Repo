# JOIN vs WHERE

- **JOIN** relates rows of two or more tables through a shared key: "customer 1 in Orders is customer 1 in Customers, combine them".
- **WHERE** filters rows that already exist in the result: "keep only rows where the condition is true".

```sql
-- explicit join, then filter
SELECT c.Name, o.OrderID
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= '2025-01-01';

-- old style: tables listed with commas, join condition in WHERE
SELECT c.Name, o.OrderID
FROM Customers c, Orders o
WHERE o.CustomerID = c.CustomerID;
```
Without a join condition, listing two tables produces a **Cartesian product** (every row with every row). For inner joins both forms give the same result, but the JOIN syntax keeps relationships separate from filters and is required for outer joins.

Analogy: JOIN connects puzzle pieces; WHERE picks only the pieces you want.
