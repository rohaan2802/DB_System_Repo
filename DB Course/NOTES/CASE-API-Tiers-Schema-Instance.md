# CASE Tools, APIs, Tier Architecture, Schema and Instance

## CASE (Computer-Aided Software Engineering)
Tools that support software design, development, testing and maintenance: diagramming (ERD/UML), code generators, debuggers, test tools. They automate repetitive work and reduce errors.

## API (Application Programming Interface)
A defined set of rules that lets one program request data or services from another without knowing its internals. Example: a weather app requesting forecasts from a weather service API.

## Tier architectures
| Architecture | Layers | Example |
|---|---|---|
| 1-tier | UI, logic and data on one machine | Notepad, MS Access file |
| 2-tier | Client (UI + logic) ↔ database server | Desktop app connecting directly to SQL Server |
| 3-tier | Presentation ↔ application/business logic ↔ data | Browser → web/app server → database |
| N-tier | 3-tier plus extra layers (cache, services, load balancers) | Large cloud platforms |

## Schema vs instance
- **Schema:** the design of the database: tables, columns, data types, constraints, relationships. Changes rarely (`CREATE TABLE`, `ALTER TABLE`).
- **Instance (state):** the actual data stored at a particular moment. Changes with every `INSERT`, `UPDATE`, `DELETE`.

| Feature | Schema | Instance |
|---|---|---|
| Describes | Structure | Current content |
| Changes | Rarely | Constantly |
| SQL | DDL | DML |
