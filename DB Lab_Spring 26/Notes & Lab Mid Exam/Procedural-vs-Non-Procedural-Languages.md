# Procedural vs Non-Procedural (Declarative) Languages

## Procedural
The program states **how** to solve the problem as an ordered sequence of steps, using variables, loops, conditions and procedures/functions.
- Examples: C, Pascal, Fortran, BASIC, COBOL; also PL/SQL and T-SQL blocks.
```c
int sum = 0;
for (int i = 0; i < n; i++)
    sum += marks[i];
```

## Non-procedural / declarative
The program states **what** result is wanted; the system decides how to produce it.
- Examples: SQL, Prolog, HTML, regular expressions; functional languages such as Haskell are also declarative.
```sql
SELECT SUM(marks) FROM Students;
```

## Comparison
| Feature | Procedural | Non-procedural |
|---|---|---|
| Focus | How (steps) | What (result) |
| Control flow | Written by programmer | Chosen by the system/optimiser |
| Code length | Longer | Shorter |
| Example task | Loop through records and add marks | `SELECT SUM(marks)` |

## Related paradigms
| Paradigm | Idea | Languages |
|---|---|---|
| Procedural | Steps grouped into procedures | C, Pascal |
| Modular | Program split into independent modules | C (separate files), Modula-2 |
| Object-oriented | Data and behaviour in objects | C++, Java, C#, Python |
| Functional | Pure functions, no shared state | Haskell, Lisp, F# |
| Logic | Facts and rules | Prolog |

## Where common languages fit
- **C:** procedural.
- **C++, Java, C#:** object-oriented, but method bodies are written procedurally (imperative).
- **Python, JavaScript:** multi-paradigm (procedural, object-oriented and functional).
- **SQL:** declarative; procedural extensions are T-SQL and PL/SQL.

## Relational algebra vs relational calculus
Relational algebra is procedural (sequence of operations: σ, π, ⋈); relational calculus is non-procedural (describes the result). SQL is based mainly on relational calculus.
