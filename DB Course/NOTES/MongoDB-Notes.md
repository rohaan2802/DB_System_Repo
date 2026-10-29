# MongoDB Notes

## What is NoSQL / MongoDB?
MongoDB is a **document-oriented NoSQL database**. Data is stored as BSON (binary JSON) documents grouped into collections instead of rows in fixed tables.

| RDBMS | MongoDB |
|---|---|
| Database | Database |
| Table | Collection |
| Row | Document |
| Column | Field |
| JOIN | Embedded document or `$lookup` |
| Fixed schema | Flexible schema |

## JSON
JavaScript Object Notation: a lightweight text format of key–value pairs, arrays and nested objects. It is easy to read, maps directly to objects in code and needs no table definitions, which is why it is "lighter" than a relational schema.
```json
{ "name": "Ali", "age": 22, "skills": ["SQL", "C++"], "address": { "city": "Islamabad" } }
```

## Is MongoDB like file handling?
No. Although documents are saved in data files on disk, MongoDB adds a storage engine (WiredTiger), indexes, a query language, concurrency control, journaling and replication. Plain text/binary file handling has none of these.

## Structured vs unstructured data
Documents in one collection may have different fields, e.g. a product catalogue where phones have `ram` and `camera` while shirts have `size` and `colour`. In SQL this needs many nullable columns or extra tables.

## Why MongoDB can be fast
1. **No joins for related data:** related data is embedded in one document and read in one operation.
2. **Indexes:** B-tree indexes on any field, including nested fields and arrays.
3. **Horizontal scaling (sharding):** a collection is split across several servers by a shard key; more servers are added as data grows (scaling *out*), instead of buying a bigger server (scaling *up*).

### Searching 20 million documents
Without an index MongoDB performs a collection scan (checks every document). With an index on `name`
```js
db.users.createIndex({ name: 1 })
db.users.find({ name: "Ali" })
```
it walks the B-tree in O(log n) steps and jumps straight to matching documents.

## Embedding vs referencing
- **Embedded:** related data stored inside the parent document (a blog post with its comments array). One read, no join; best for data that is always used together.
- **Referenced:** store the `_id` of another document (like a foreign key). Best for large or shared data.
```js
{ title: "First Post", comments: [ { user: "Sara", text: "Nice" } ] }
```

## Embedded systems (different meaning)
An *embedded system* is a small computer built into a device for a dedicated task (washing machine, car ECU, router). It is unrelated to *embedded documents*.

## HDD vs SSD
| Feature | HDD | SSD |
|---|---|---|
| Storage | Spinning magnetic platters, moving head | Flash memory, no moving parts |
| Speed | Slower, high seek time | Much faster random access |
| Durability | Can be damaged by drops or shocks | More durable |
| Cost per GB | Lower | Higher |

## Inserting documents
| Method | Use |
|---|---|
| `insertOne(doc)` | One document, e.g. a form submission |
| `insertMany([docs])` | Several documents in one call, faster for batches |
| `bulkWrite([ops])` | Mixed insert/update/delete operations in one batch |

## Shell basics
```js
cls                         // clear the mongosh screen
use lab14DB                 // switch/create database
db.createCollection("students")
db.createCollection("courses")
db.students.insertOne({ name: "Ali", age: 22 })
db.students.find()
db.employees.find({ sal: { $gt: 1500 } }, { ename: 1, sal: 1, _id: 0 })
```
Two RDBMS tables normally become two collections, but data that is always read together can be embedded in one.

## Advantages over RDBMS
1. Flexible schema: add fields without `ALTER TABLE`.
2. Horizontal scalability through sharding.
3. Natural JSON-like structure for application objects.
4. Fast reads and writes for document-shaped workloads.
5. Handles large semi-structured data.
6. Aggregation pipeline for real-time analytics.

Example use case: a blog platform storing posts with embedded comments and tags.

## SQL Server hosting
SQL Server (like MongoDB) can run on a local machine, an on-premises server or in the cloud (Azure SQL, Amazon RDS, MongoDB Atlas).
