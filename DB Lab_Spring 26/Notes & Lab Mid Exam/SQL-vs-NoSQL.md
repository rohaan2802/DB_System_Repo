# SQL vs NoSQL

## SQL (relational) databases
Data is stored in tables with a fixed schema; relationships use foreign keys; queries use SQL.

| id | name | class |
|---|---|---|
| 1 | Ali | 10 |
| 2 | Sara | 9 |

Systems: MySQL, PostgreSQL, Microsoft SQL Server, Oracle, SQLite.

## NoSQL databases
Non-relational stores with flexible schemas.

| Type | Example data | Systems |
|---|---|---|
| Document | `{ "name": "Ali", "class": 10 }` | MongoDB, CouchDB |
| Key-value | `session:123 → {...}` | Redis, DynamoDB |
| Wide column | Row key with column families | Cassandra, HBase |
| Graph | Nodes and relationships | Neo4j |

## Differences
| Feature | SQL | NoSQL |
|---|---|---|
| Schema | Fixed, defined first | Flexible |
| Structure | Tables | Documents, key-value, columns, graphs |
| Relationships | Joins and foreign keys | Embedding or references |
| Transactions | Full ACID | Varies; often BASE / eventual consistency (MongoDB supports multi-document ACID) |
| Scaling | Mostly vertical | Designed for horizontal scaling |
| Query language | Standard SQL | Product-specific APIs |
| Best for | Structured data, strong consistency | Large, fast-changing or semi-structured data |

## Syntax comparison
| Task | SQL | MongoDB |
|---|---|---|
| Insert | `INSERT INTO students VALUES (1,'Ali',10);` | `db.students.insertOne({id:1, name:"Ali", class:10})` |
| Read | `SELECT * FROM students WHERE class = 10;` | `db.students.find({class:10})` |
| Update | `UPDATE students SET class = 11 WHERE id = 1;` | `db.students.updateOne({id:1}, {$set:{class:11}})` |
| Delete | `DELETE FROM students WHERE id = 1;` | `db.students.deleteOne({id:1})` |

## Why banks use SQL
- Money transfers need **ACID** transactions: a debit and credit must both happen or neither.
- Strict schemas and constraints prevent invalid data.
- Mature auditing, security and recovery.
- Common systems: Oracle, IBM Db2, SQL Server, PostgreSQL. NoSQL is used alongside for logs, caching (Redis), fraud analytics and mobile app data.

## Tools
- SQL: SQL Server Management Studio, MySQL Workbench, pgAdmin, Oracle SQL Developer.
- NoSQL: MongoDB Compass, mongosh, Redis CLI/Insight, Neo4j Browser.
