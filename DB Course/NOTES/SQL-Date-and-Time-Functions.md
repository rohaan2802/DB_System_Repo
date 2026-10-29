# SQL Server Date and Time Functions

## DATEDIFF
```sql
DATEDIFF(datepart, start_date, end_date)
```
| Parameter | Meaning |
|---|---|
| datepart | Unit of the result: `year`, `month`, `day`, `hour`, `minute` ... |
| start_date | Earlier date |
| end_date | Later date |

```sql
SELECT DATEDIFF(day,  '2024-01-01', '2024-01-10');   -- 9
SELECT DATEDIFF(year, '2000-05-01', '2025-04-05');   -- 25
SELECT Name, DATEDIFF(day,  DOB, GETDATE()) AS AgeInDays  FROM Students;
SELECT Name, DATEDIFF(year, DOB, GETDATE()) AS ApproxAge  FROM Students;
```
- DATEDIFF counts **boundaries crossed**, not complete periods, so `DATEDIFF(year, ...)` gives only an approximate age.
- The result is negative when `start_date > end_date`.

## Getting the current date
| Function | Returns |
|---|---|
| `GETDATE()` | Current date and time (`datetime`) |
| `CURRENT_TIMESTAMP` | ANSI equivalent of `GETDATE()` |
| `SYSDATETIME()` | Higher precision (`datetime2`) |
| `CAST(GETDATE() AS DATE)` / `CONVERT(DATE, GETDATE())` | Date only |

```sql
SELECT Name, DOB FROM Students
WHERE DATEDIFF(year, DOB, GETDATE()) > 18;
```

## TIMESTAMP / ROWVERSION
In SQL Server `TIMESTAMP` is **not** a date. It is a synonym of `ROWVERSION`: an automatically generated binary number that changes every time the row is inserted or updated.

```sql
CREATE TABLE Employees (
    EmployeeID  INT PRIMARY KEY,
    Name        VARCHAR(100),
    Position    VARCHAR(50),
    LastUpdated ROWVERSION
);

-- optimistic concurrency: update only if nobody changed the row since it was read
UPDATE Employees
SET    Position = 'Senior Software Engineer'
WHERE  EmployeeID = 1 AND LastUpdated = @PreviousVersion;
```
Use it for version tracking and optimistic locking. To store real dates use `DATE`, `TIME`, `DATETIME` or `DATETIME2`.

## DATETIME vs DATETIME2
| Feature | DATETIME | DATETIME2 |
|---|---|---|
| Range | 1753-01-01 to 9999-12-31 | 0001-01-01 to 9999-12-31 |
| Precision | Rounded to about 3 ms | Up to 100 ns (7 fractional digits) |
| Storage | 8 bytes | 6 to 8 bytes depending on precision |
| Adjustable precision | No | Yes, 0 to 7 |

- `DATETIME`: legacy systems and normal precision.
- `DATETIME2`: new designs, logging, financial data, dates before 1753.

## CAST vs CONVERT
| Feature | `CAST` | `CONVERT` |
|---|---|---|
| Standard | ANSI SQL | SQL Server specific |
| Formatting style | Not supported | Optional style code (e.g. 103 = dd/mm/yyyy) |
| Typical use | Simple type changes | Date/time conversion with a format |

```sql
SELECT TRY_CAST('123' AS INT);            -- 123
SELECT TRY_CONVERT(INT, '123');           -- 123
SELECT TRY_CAST('abc' AS INT);            -- NULL (conversion fails, no error)
SELECT TRY_CONVERT(DATE, '25/12/2024', 103);  -- 2024-12-25
SELECT CONVERT(VARCHAR(10), GETDATE(), 103);  -- today as dd/mm/yyyy
```
`TRY_CAST` / `TRY_CONVERT` return `NULL` instead of raising an error when a value cannot be converted.

### Common `datepart` values
| datepart | Abbreviation | Meaning |
|---|---|---|
| year | yy, yyyy | Year |
| month | mm, m | Month |
| day | dd, d | Day |
| hour | hh | Hour |
| minute | mi, n | Minute |
| second | ss, s | Second |
