# Database Schema

A **schema** is the blueprint of a database: which tables exist, which columns each table has, their data types and constraints, and how the tables are related. It describes structure, not data.

## Example: school database
```sql
CREATE TABLE Students (
    id   INT PRIMARY KEY,
    name VARCHAR(50),
    age  INT
);
CREATE TABLE Courses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(50)
);
CREATE TABLE Enrollment (
    student_id INT REFERENCES Students(id),
    course_id  INT REFERENCES Courses(course_id),
    PRIMARY KEY (student_id, course_id)
);
```

## Three-schema architecture (ANSI/SPARC)
| Level | Also called | Describes | Seen by |
|---|---|---|---|
| External | View level | Part of the database relevant to one user group | End users, applications |
| Conceptual | Logical level | All entities, attributes, relationships and constraints | Designers, DBA |
| Internal | Physical level | How data is stored: files, indexes, pages | DBMS, DBA |

- **Logical data independence:** the conceptual schema can change without changing external views.
- **Physical data independence:** storage can change without changing the conceptual schema.

## Other uses of the word
- **Star schema / snowflake schema:** data-warehouse designs with a central fact table and surrounding dimension tables.
- **SQL Server schema:** a namespace inside a database (`dbo.Students`, `sales.Orders`).

## Schema vs instance
The schema is fixed design (DDL); the instance is the data stored at a moment (DML) and changes constantly.

## Categories of data models
| Data model | Focus | Key concepts | Example models | Use |
|---|---|---|---|---|
| Conceptual (high-level) | How users understand data | Entities, attributes, relationships | ER model | Database design and planning |
| Physical (low-level) | How data is stored in memory/disk | Storage, indexing, file formats | B+ tree indexes, hashing | Performance tuning |
| Implementation (representational) | How the DBMS represents data | Tables, keys, relations | Relational, document | Building the database |
