# UNIQUE vs PRIMARY KEY (SQL Server)

| Feature | PRIMARY KEY | UNIQUE |
|---|---|---|
| Uniqueness | Yes | Yes |
| NULL allowed | No | Yes (one NULL in SQL Server) |
| Number per table | One | Many |
| Default index | Clustered | Non-clustered |
| Purpose | Identify each row | Prevent duplicates in a non-key column |

```sql
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,     -- unique and NOT NULL
    Email      VARCHAR(100) UNIQUE, -- unique, NULL allowed
    Phone      VARCHAR(15)  UNIQUE
);
```
A column does not need both constraints because PRIMARY KEY already enforces uniqueness, but a table can have one PRIMARY KEY together with several UNIQUE constraints.

- Use **PRIMARY KEY** for the row identifier.
- Use **UNIQUE** for other columns that must not repeat (email, CNIC, phone).
