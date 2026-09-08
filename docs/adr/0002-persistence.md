# ADR-0002: Persistence — sqflite

## Status
Accepted

## Context
`Task` and `MicroStep` have a **one-to-many relationship**: one `Task`
can have many `MicroStep`s, and each `MicroStep` points back to exactly
one `Task` via `taskId` — a **foreign key** referencing `Task.id`,
rather than a duplicated copy of the Task itself (see ADR-0001's
predecessor reasoning in the domain modeling phase).

This relationship means the app will need to answer queries like "give
me all the MicroSteps for this Task" — a query relational databases are
built around, and one a flat key-value store has no native way to
express or answer efficiently.

Two persistence options were on the table from the original project
scope: `sqflite` and `shared_preferences`.

## Decision
Use **sqflite** for persistence.

## Reasoning Against This App's Concrete Requirements
- **Data shape:** `shared_preferences` is a flat key-value store —
  suited to simple, independent settings (e.g. a theme preference), not
  to structured, relational data. Forcing a one-to-many,
  foreign-key-based relationship into a flat store would fight the
  data's actual shape rather than work with it. `sqflite` gives real
  relational tables, matching `Task`/`MicroStep` directly.
- **Querying by relationship:** Fetching "all MicroSteps for Task X" is
  a natural, efficient SQL query (`WHERE taskId = X`) in a relational
  database, and something a key-value store cannot do without
  significant manual workarounds.
- **Integration with state management (ADR-0001):** `TaskProvider`
  methods (e.g. `addTask()`) must change from synchronous, in-memory-only
  mutation to an `async` operation: write to disk first (`await
  database.insertTask(task)`), update the in-memory list second, and
  only then call `notifyListeners()`. This ordering matters because
  `notifyListeners()` tells the UI "the current state is now true" — if
  it fired before the disk write completed (or if that write then
  failed), the UI would show a Task as saved when it was never actually
  persisted, silently vanishing on the next app restart. Disk-write
  failures must be caught *before* the UI claims success.

## Consequences
- Every mutating method on `TaskProvider` (and its future `MicroStep`
  equivalent) becomes `async`, returning `Future<void>` instead of
  `void`, since disk writes are not instantaneous and the app must wait
  for confirmation before updating in-memory state and notifying
  listeners.
- A single shared SQLite connection lives in `core/services/`, per the
  locked-in feature-first architecture, rather than being duplicated
  inside any one feature's `data/` folder.
- Schema design (tables for `tasks` and `micro_steps`, with `taskId` as
  a foreign key) becomes the next concrete build step.

