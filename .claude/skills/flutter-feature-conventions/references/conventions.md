# Conventions — rationale & details

Companion to `SKILL.md`. Read `SKILL.md` first; this expands the "why" and the wiring.

## Dependencies this style assumes

- State: `flutter_bloc`, `bloc`, `bloc_concurrency`, `equatable`
- Errors: `dartz` (`Either`, `Left`, `Right`)
- Data: `http`, `sqflite`, `json_annotation` + `json_serializable` (dev)
- DI: `get_it` (+ `injectable` for generated registration if you use it)
- Tests: `bloc_test`, `mockito` + `build_runner` (dev)

If `NetworkException` / `CacheException` / `NetworkFailure` are not in `core/error/` yet, add them next to `ServerException` / `ServerFailure`. The "catch everything and call it `CacheFailure`" shortcut is the anti-pattern this style replaces.

## State: why single-class + status (with sources)

The bloc docs present two representations and recommend by fit: a single class + status enum suits states that share data / are not strictly exclusive; sealed subclasses suit disjoint states and give compile-time exhaustiveness. For data that must survive transitions (lists, refresh, error-with-stale-data) the docs explicitly suggest a single state class so widgets can read data and error together via `copyWith`. Feeds and lists are exactly that case — hence the house default. Use the sealed-subclass escape hatch only for genuinely disjoint states.

Refs: bloclibrary.dev "Modeling State", "FAQs", "Naming Conventions".

## Error taxonomy

| Layer | Throws / returns |
| :---- | :---- |
| DataSource | throws `ServerException` (HTTP non-200), `NetworkException` (connectivity), `CacheException` (sqflite) |
| Repository | catches each, maps to `ServerFailure` / `NetworkFailure` / `CacheFailure`, returns `Either<Failure, T>`; serves cache on network/server failure |
| UseCase | passes the `Either` through (or composes several) |
| Bloc | `fold`s the `Either` into a `loaded` / `error` state |

No blanket `catch (e)`. Unexpected exceptions propagate so bugs surface in tests/observability instead of masquerading as failures.

## Offline contract

Network-first, cache-fallback for reads: try remote -> write-through to sqflite -> return fresh; on `ServerException`/`NetworkException` -> return the cached page as `Right`. (For live cache->UI streaming you would return a `Stream`; the plain `Future` form keeps it legible.)

## Test policy

Two seams, every feature:

1. Bloc (`bloc_test`, mocked UseCase): first page, next-page append, `hasReachedMax`.
2. Repository (mocked remote + local): remote throws -> cached `Right` (the offline guarantee).

Mocks via `@GenerateMocks` + `build_runner`, mirroring the existing `test/.../mocks` setup.
