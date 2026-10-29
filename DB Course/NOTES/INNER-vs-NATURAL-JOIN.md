# INNER JOIN vs NATURAL JOIN

## INNER JOIN
Joins rows using a condition written in the `ON` clause. Columns can have different names.
```sql
SELECT *
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID;
```

## NATURAL JOIN
Joins automatically on **all** columns with the same name and compatible type; no `ON` clause. (Supported in MySQL, PostgreSQL and Oracle, not in SQL Server.)
```sql
SELECT * FROM Employees NATURAL JOIN Orders;
```

## Differences
| Feature | INNER JOIN | NATURAL JOIN |
|---|---|---|
| Join condition | Written manually | Derived from same-named columns |
| Flexibility | Any columns, any condition | Only equal names |
| Duplicate join column | Appears twice unless selected | Appears once |
| Risk | Low, explicit | Joins on unintended columns such as `Name` or `ModifiedDate` |

**Rule:** prefer INNER JOIN in real code because it is explicit and safe when schemas change.
