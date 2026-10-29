# Normalization

Normalization organises tables to remove redundancy and the **insertion, update and deletion anomalies** it causes.

## Unnormalized example
| StudentID | Name | Courses | Teacher | TeacherPhone |
|---|---|---|---|---|
| 1 | Ali | DB, OS | Sir Ahmed, Sir Bilal | 0300..., 0311... |

Problems: multiple values in one cell, teacher phone repeated for every student, deleting the last student of a course loses the teacher's data.

## Functional dependency
`X → Y` means the value of X determines the value of Y (StudentID → Name).

## Normal forms
| Form | Rule | Fix |
|---|---|---|
| 1NF | Atomic values, no repeating groups, each row unique | One course per row |
| 2NF | 1NF + no **partial** dependency on part of a composite key | Move attributes that depend on part of the key to their own table |
| 3NF | 2NF + no **transitive** dependency (non-key → non-key) | Move the dependent attributes to a new table |
| BCNF | For every `X → Y`, X is a super key | Decompose further |
| 4NF | BCNF + no multi-valued dependencies | Separate independent multi-valued facts |
| 5NF | No join dependency that is not implied by keys | Decompose until lossless joins are only on keys |

## Worked decomposition
1NF table `Enrollment(StudentID, CourseID, Name, CourseTitle, Teacher, TeacherPhone)` with key (StudentID, CourseID):
- StudentID → Name (partial)
- CourseID → CourseTitle, Teacher (partial)
- Teacher → TeacherPhone (transitive)

Result in 3NF:
- `Student(StudentID, Name)`
- `Course(CourseID, CourseTitle, Teacher)`
- `Teacher(Teacher, TeacherPhone)`
- `Enrollment(StudentID, CourseID)`

## Anomalies removed
| Anomaly | Example before normalization |
|---|---|
| Insertion | A new course cannot be stored until a student enrols |
| Update | Changing a teacher's phone needs many row updates |
| Deletion | Deleting the last student removes course information |

**Trade-off:** more tables mean more joins; data warehouses sometimes denormalize for read speed.

## Denormalization
Denormalization deliberately merges tables or repeats data to make reads faster by avoiding joins.

Normalized: `Customers(CustomerID, Name, Email)` and `Orders(OrderID, CustomerID, Product, Quantity)`.

Denormalized: `Orders(OrderID, CustomerID, CustomerName, Email, Product, Quantity)` – a report on orders with customer names needs no join, but a changed email must be updated in many rows.

| | Normalization | Denormalization |
|---|---|---|
| Goal | Remove redundancy, keep integrity | Faster reads |
| Tables | More, smaller | Fewer, wider |
| Typical use | OLTP systems | Reporting, data warehouses |
