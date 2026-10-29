# EXISTS and Functional Dependencies

## EXISTS
`EXISTS` returns TRUE when the subquery returns at least one row. It is used to test for related data.
```sql
SELECT column1, column2
FROM table1
WHERE EXISTS (
    SELECT 1 FROM table2
    WHERE table2.related_column = table1.related_column
);
```
Customers who placed at least one order:
```sql
SELECT *
FROM Customers c
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.customer_id = c.customer_id);
```
Customers with no orders: replace `EXISTS` with `NOT EXISTS`.

### Why `SELECT 1`?
The selected value is ignored; EXISTS only checks whether any row matches. `SELECT 1`, `SELECT *` or `SELECT NULL` all behave the same. `SELECT 1` is a convention meaning "only existence matters".

## Full vs partial functional dependency
Table `Grades(StudentID, CourseID, StudentName, Grade)` with composite primary key **(StudentID, CourseID)**.

| Type | Definition | Example |
|---|---|---|
| Full functional dependency | Attribute depends on the **whole** composite key | (StudentID, CourseID) → Grade |
| Partial functional dependency | Non-prime attribute depends on **part** of the composite key | StudentID → StudentName |

Partial dependencies violate **2NF**; they are removed by moving `StudentName` into a separate `Student(StudentID, StudentName)` table.
