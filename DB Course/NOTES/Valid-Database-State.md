# Valid State of a Database

A database is in a **valid state** when its current data satisfies every constraint and business rule defined in the schema.

Characteristics:
- Integrity maintained: every foreign key points to an existing row.
- Constraints satisfied: primary key, unique, NOT NULL, CHECK.
- No corrupt or contradictory data.
- Data correctly represents the real world.

How it is maintained:
1. Declare constraints in the schema.
2. Validate input before INSERT/UPDATE.
3. Use transactions with ACID properties; the *C* (consistency) means each transaction moves the database from one valid state to another.
4. Periodically clean and audit data.

A violated constraint is rejected by the DBMS; otherwise the database would enter an invalid state.

## Example: valid vs invalid state
Schema: `Student(Student_ID PRIMARY KEY, Name, Age CHECK (Age > 0), Course NOT NULL)`

Valid state:
| Student_ID | Name | Age | Course |
|---|---|---|---|
| 101 | Ali | 20 | CS |
| 102 | Sara | 22 | IT |

Invalid state:
| Student_ID | Name | Age | Course |
|---|---|---|---|
| 101 | Ali | 20 | CS |
| 101 | Sara | -5 | NULL |

Violations: duplicate primary key `101`, negative age, and `NULL` course.
