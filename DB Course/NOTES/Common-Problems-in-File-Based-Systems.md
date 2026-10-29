# Problems of Traditional File-Based Systems

A DBMS was introduced to fix the following problems of storing data in separate application files.

## 1. Data redundancy and inconsistency
- **Redundancy:** the same data is stored in several files.
- **Inconsistency:** the copies stop matching. Example: a student's address is updated in the personal-details file but not in the fees file.
- Effect: wasted storage, conflicting records, complex updates.

## 2. Difficulty in accessing data
Every new report needs a new program. Example: HR wants all employees who joined in 2022 but the data is spread over several text files.

## 3. Data isolation
Data is scattered across files in different formats, so combining it is hard. Example: diagnosis in one system, billing in another.

## 4. Integrity problems
Rules such as "balance must not be negative" are buried inside program code and are hard to enforce or change.
- DBMS fix: constraints such as `NOT NULL`, `UNIQUE`, `CHECK`, `FOREIGN KEY`.

## 5. Atomicity problems
A transfer of 500 from account A to B must happen completely or not at all. If the system crashes after the debit but before the credit, money is lost.
- DBMS fix: transactions with the **ACID** properties.

| Property | Meaning |
|---|---|
| Atomicity | All operations of a transaction happen, or none do |
| Consistency | A transaction moves the database from one valid state to another |
| Isolation | Concurrent transactions do not interfere; each behaves as if it ran alone |
| Durability | Once committed, changes survive crashes and power failures |

## 6. Concurrent access anomalies
Two users update the same record at the same time and one update is lost.
- DBMS fix: locking and concurrency control.

## 7. Security problems
Not every user should see every field (a receptionist should not read medical history).
- DBMS fix: authentication, role-based authorization, encryption.

**Summary:** a DBMS centralises data and provides integrity, atomicity, concurrency control and security that file systems lack.
