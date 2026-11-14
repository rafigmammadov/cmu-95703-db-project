# CMU 95-703, Database Management Project

Oracle Database implementation project for Homer Consulting.

## Stack

- **Database:** Oracle Database
- **Development:** Oracle APEX SQL Workshop
- **SQL Client:** SQL*Plus
- **Version Control:** Git / GitHub

## Structure

```text
sql/
├── 01_create_tables.sql
├── 02_insert_data.sql
├── 03_verify_tables.sql
└── queries/
    ├── q01.sql ... q14.sql
    └── all_queries.sql
```

## Setup

```bash
git clone https://github.com/rafigmammadov/cmu-95703-db-project.git
cd cmu-95703-db-project
```

Run the SQL scripts in order:

1. `01_create_tables.sql` — Schema and constraints
2. `02_insert_data.sql` — Seed data
3. `03_verify_tables.sql` — Data verification
4. `queries/` — Project queries

Use the shared Oracle APEX workspace for development and SQL*Plus for final verification.

Commit changes using **Conventional Commits**:

```text
<type>(<scope>): <description>
```

Supported types:

- `feat` — New SQL functionality or queries
- `fix` — Bug fixes
- `refactor` — SQL improvements without behavior changes
- `docs` — Documentation changes
- `test` — Tests and validation
- `chore` — Repository configuration and maintenance

Examples:

```bash
git commit -m "feat(schema): create employee and department tables"
git commit -m "feat(seed): populate project and assignment tables"
git commit -m "feat(queries): implement question 1"
git commit -m "fix(schema): correct foreign key constraints"
git commit -m "docs: update setup instructions"
```

## Submission

**Deadline:** December 1, 2026

Final deliverables: SQL creation and insertion scripts, complete table contents, 14 queries with formatted results, and a title page.
