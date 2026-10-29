# Mapping ER Relationships to Tables

## Where does the foreign key go?
| Relationship | Foreign key placement |
|---|---|
| 1:1 mandatory–mandatory | Shared primary key (or merge into one table) |
| 1:1 mandatory–optional | In the optional (dependent) side, with `UNIQUE` |
| 1:1 optional–optional | In either table, but only one of them |
| 1:N | On the "many" side |
| M:N | New junction table with two foreign keys; composite PK |

## 1:1 options
Entities `Person(person_id, name)` and `Passport(passport_id, issue_date)`.

**Option 1 – merge** (both always exist together):
```sql
CREATE TABLE PersonPassport (
    person_id   INT PRIMARY KEY,
    name        VARCHAR(50),
    passport_id INT UNIQUE,
    issue_date  DATE
);
```

**Option 2 – foreign key with UNIQUE** (a passport must belong to a person; a person may have none):
```sql
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name      VARCHAR(50)
);
CREATE TABLE Passport (
    passport_id INT PRIMARY KEY,
    issue_date  DATE,
    person_id   INT UNIQUE,                       -- UNIQUE enforces 1:1
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```

**Option 3 – shared primary key** (strict 1:1):
```sql
CREATE TABLE Passport (
    passport_id INT PRIMARY KEY,                  -- same value as person_id
    issue_date  DATE,
    FOREIGN KEY (passport_id) REFERENCES Person(person_id)
);
```
The passport row cannot exist without its person and there can be only one per person.

### Optional–optional 1:1
Example: `Person` and `DrivingLicense`, both optional. Put a nullable `UNIQUE` foreign key in the side that is more dependent or less often used on its own (here `DrivingLicense.person_id`). Never put foreign keys in both tables: it creates a circular dependency and insert problems.

## 1:N
One department has many employees → `Employee.dept_id REFERENCES Department(dept_id)`.

## M:N
```sql
CREATE TABLE Enrollment (
    student_id INT,
    course_id  INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id)  REFERENCES Course(course_id)
);
```
Attributes of the relationship (e.g. grade, enrolment date) go in the junction table.
