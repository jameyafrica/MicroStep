# ADR-0001: State Management — Provider (ChangeNotifier)

## Status
Accepted

## Context
Flutter widgets only rebuild when explicitly told to — there is no
automatic watching of variables. `setState()`, built into every
`StatefulWidget`, is the simplest version of that trigger, but it is
**scoped**: it tells Flutter to rebuild only the widget it was called
inside (and its children), not the wider app.

This becomes a problem the moment two *separate* widgets need to agree
on the same fact. Concretely: if a MicroStep is marked complete on a
Tasks screen, the Backlog screen — a different widget, built
separately, sitting elsewhere in the widget tree — never called
`setState()` itself, so nothing tells it to rebuild. It would stay
frozen on stale data.

A plain global variable doesn't solve this either. It gives every
screen access to the same underlying data (solving "one source of
truth"), but it has no way to *announce* that it changed. Flutter has
no built-in mechanism that watches raw variables, so even a shared
global list wouldn't cause a listening widget to rebuild on its own.

This left three concrete requirements, derived directly from working
through the failure cases above rather than assumed upfront:
1. **Shared** — one single source of truth, not duplicated copies that
   could disagree.
2. **Reactive** — when the shared data changes, every widget that
   cares must be notified, not just the widget that made the change.
3. **Not tied to one widget's lifetime** — must survive navigation
   between screens (e.g. Tasks → Backlog), unlike a `StatefulWidget`'s
   own internal state.

## Decision
Use **Provider**, built on Flutter's `ChangeNotifier`, for state that
needs to be shared across features — specifically, Task/MicroStep data
that both the `tasks` and `backlog` features need to read and react to.

A `TaskProvider extends ChangeNotifier` holds the shared list privately
(`_tasks`), exposes it read-only via `List.unmodifiable`, and calls
`notifyListeners()` on every mutation (e.g. `addTask()`). Any widget
wrapped in a `Consumer<TaskProvider>` (or using
`context.watch<TaskProvider>()`) rebuilds automatically when that
fires — solving all three requirements above directly.

**The focus timer is explicitly excluded from this.** The timer's
Stream/StreamController ticking is self-contained: nothing outside the
timer screen needs to react to it tick-by-tick. It will be consumed
locally via `StreamBuilder`, not routed through `Provider`. Provider
and `StreamBuilder` are solving two different problems in the same
app — cross-feature shared state, and one screen's own moment-to-moment
updates — not competing for the same job.

## Reasoning Against This App's Concrete Requirements
- **Timer (Streams/StreamControllers):** `ChangeNotifier` and `Stream`
  are different reactive patterns. Since the timer's ticks don't need
  to be visible outside its own screen, this isn't actually a conflict
  — the timer simply doesn't go through Provider at all.
- **Offline persistence (state must survive read/write to local
  storage):** `ChangeNotifier` is agnostic to where data comes from —
  "load data, call `notifyListeners()`" works the same whether the
  source is sqflite or shared_preferences. No friction here.
- **Cross-feature sharing (backlog needs MicroStep completion status,
  which lives conceptually under `tasks`):** this is Provider's
  strongest fit — it is explicitly designed to expose state up the
  widget tree so unrelated features can read and react to it.

## Consequences
- Cross-feature state (Task/MicroStep data shared between `tasks` and
  `backlog`) has one clear, reactive source of truth.
- The timer feature stays simpler by *not* being forced through
  Provider — it keeps its own local `StreamBuilder`-based state,
  scoped to its own screen.
- Future features needing shared state follow the same
  `ChangeNotifier` + `Provider` pattern already established here,
  rather than inventing a new approach each time.

## Note on Process
The core reasoning in this ADR (the `setState()` scoping problem, the
global-variable dead end, and the three derived requirements) was
worked through independently before this decision was formally
reviewed in a mentoring session. The `Provider` package and an initial
`TaskProvider` implementation existed prior to that review. The
reasoning was walked through together on 2026-09-07, confirmed sound
against this app's three concrete requirements (timer, persistence,
cross-feature sharing), and is recorded here as the record of that
confirmation — not as a decision made blind, but as one reasoned
through correctly and then independently verified.