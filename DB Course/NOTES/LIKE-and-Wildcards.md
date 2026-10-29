# LIKE and Wildcards (SQL Server)

| Wildcard | Matches |
|---|---|
| `%` | Zero or more characters |
| `_` | Exactly one character |
| `[abc]` | One character from the set |
| `[a-f]` | One character in the range |
| `[^abc]` | One character not in the set |

```sql
SELECT * FROM Students WHERE Name LIKE 'A%';     -- starts with A
SELECT * FROM Students WHERE Name LIKE '%n';     -- ends with n
SELECT * FROM Students WHERE Name LIKE '%li%';   -- contains li
SELECT * FROM Students WHERE Name LIKE '___';    -- exactly 3 characters
SELECT * FROM Students WHERE Name NOT LIKE 'A%'; -- does not start with A
```

- Case sensitivity depends on the collation; the default SQL Server collation is case-insensitive, so `LIKE 'ali'` matches `Ali` and `ALI`.
- To search for a literal `%` or `_`, use `ESCAPE`:
```sql
SELECT * FROM Messages WHERE Text LIKE '%30\%%' ESCAPE '\';   -- contains "30%"
```

## Simple email validation
```sql
SELECT * FROM Users
WHERE Email NOT LIKE '%_@_%._%';
```
Pattern `%_@_%._%`: at least one character before `@`, at least one after it, then a dot followed by at least one character. The query returns invalid emails such as `plainaddress`, `missing@domain`, `@missingusername.com`; valid ones such as `test@example.com` are excluded.
