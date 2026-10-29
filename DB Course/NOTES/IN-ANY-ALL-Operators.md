# IN, ANY and ALL Operators

## IN
Checks equality against a list or subquery. Equivalent to a chain of `OR =`.
```sql
SELECT Title FROM Books WHERE Price IN (1000, 2000, 3000);
-- same as: Price = 1000 OR Price = 2000 OR Price = 3000
```

## ANY
Compares a value with each value of a subquery using any comparison operator; true if the condition holds for **at least one** value.
```sql
SELECT Title FROM Books
WHERE Price > ANY (SELECT Price FROM Books WHERE Genre = 'Fiction');
-- price greater than the cheapest Fiction book
```
`= ANY (subquery)` behaves exactly like `IN (subquery)`.

## ALL
True only if the condition holds for **every** value of the subquery.
```sql
SELECT Title FROM Books
WHERE Price > ALL (SELECT Price FROM Books WHERE Genre = 'Fiction');
-- price greater than the most expensive Fiction book

SELECT Title FROM Books
WHERE Price = ALL (SELECT Price FROM Books WHERE Genre = 'Fiction');
-- only matches if all Fiction books share one price
```

## Comparison
| Operator | True when | Operators allowed | Example |
|---|---|---|---|
| IN | value equals some item | `=` only | `Price IN (1000, 2000)` |
| ANY | condition holds for at least one value | `= > < >= <= <>` | `Price > ANY (subquery)` |
| ALL | condition holds for every value | `= > < >= <= <>` | `Price > ALL (subquery)` |

Shortcuts: `> ANY` = greater than the MIN, `> ALL` = greater than the MAX.
