# Keys in a Relational Database

| Key | Definition |
|---|---|
| Super key | Any set of attributes that uniquely identifies a row; may contain extra attributes |
| Candidate key | A *minimal* super key; removing any attribute loses uniqueness |
| Primary key | The candidate key chosen to identify rows; unique and NOT NULL, one per table |
| Alternate key | A candidate key that was not chosen as primary key |
| Composite key | A key made of two or more attributes |
| Foreign key | Attribute(s) in one table that reference the primary key of another table |
| Unique key | Enforces uniqueness but (in SQL Server) allows one NULL |

## Example: `Students(Student_ID, First_Name, Last_Name, Email, Roll_No)`

| Student_ID | First_Name | Last_Name | Email | Roll_No |
|---|---|---|---|---|
| 101 | Alice | Brown | alice@email.com | 01 |
| 102 | Bob | Smith | bob@email.com | 02 |
| 103 | Alice | Davis | alice.d@email.com | 03 |

- **Super keys:** {Student_ID}, {Email}, {Roll_No}, {Student_ID, Email}, {Student_ID, Roll_No, First_Name}, ...
- **Candidate keys:** {Student_ID}, {Email}, {Roll_No}
- **Primary key:** {Student_ID}
- **Alternate keys:** {Email}, {Roll_No}
- **Composite key:** {First_Name, Last_Name}, only if that pair is guaranteed unique

## Composite key vs candidate key
- In a composite key each individual attribute **may repeat**; only the combination must be unique. Example: in `Enrollment(StudentID, CourseID)` a student appears many times and a course appears many times, but each pair appears once.
- Every candidate key is a super key, but not every super key is a candidate key.

## Foreign key example
```sql
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    name    VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id  INT PRIMARY KEY,
    name    VARCHAR(50),
    dept_id INT FOREIGN KEY REFERENCES Department(dept_id)
);
```

**Summary:** super key ⊇ candidate key ⊇ primary key; a composite key is any key with more than one attribute.

## Super key vs primary key
| Feature | Super key | Primary key |
|---|---|---|
| Definition | Any attribute set that uniquely identifies a row | One minimal candidate key chosen to identify rows |
| Uniqueness | Yes | Yes |
| Minimality | Not required | Always minimal |
| Number per table | Many | Exactly one |
| NULL values | May contain NULL in extra attributes | Never NULL |
| Relation | Superset of every candidate key | A special candidate key |

## Foreign key
A foreign key is a column in one table that refers to the primary key of another table, enforcing referential integrity:
```sql
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
);
```
