---
name: flutter-feature-conventions
description: >-
  Production conventions for building or changing features in this Flutter/Dart
  codebase: Clean-Architecture layering (UI -> Bloc -> UseCase -> Repository -> DataSource), single-immutable-state Bloc that renders every loading/empty/error/data case, repository-as-source-of-truth with offline support (network-first, cache fallback), and a mandatory bloc_test plus repository test covering pagination and offline. ALWAYS use this skill whenever adding or editing any Flutter feature, screen, page, list, feed, Bloc/Cubit, repository, use case, data source, or model, or anything touching state management, networking, persistence, pagination, or offline behaviour - even when the request does not mention architecture, tests, or conventions.
---

# Flutter Feature Conventions

How features are built in this codebase. Apply these on every feature you add or change. The four rules are non-negotiable; the rest is the house style that makes them concrete.

## The four rules

1. **The widget renders, it never decides.** UI dispatches events and renders the current state. All orchestration — fetching, paging, caching, error mapping — lives in the Bloc and below. No business logic, no `Future`s, no `try/catch` in widgets.
2. **One immutable state; render every case.** Every async surface explicitly handles **loading / empty / error / data** — no silent or missing states. Empty is `loaded` with no items, rendered on purpose. Lists carry `hasReachedMax` and `isLoadingMore`. (Representation is the house default below; the _invariant_ — every case is rendered — is the rule.)
3. **The repository is the source of truth; network-first with cache fallback.** Data sources throw typed exceptions; the repository writes through to the cache, serves the cache when the network is unavailable, and maps each exception to a _specific_ `Failure`, returning `Either<Failure, T>`. A read never surfaces a raw error when a cache exists.
4. **Mandatory tests per feature: pagination + offline.** A `bloc_test` proves first-page load, next-page append, and reaching the end; a repository test proves the offline path (remote throws -> cached data returned as `Right`). No feature ships without them.

## Layering

`UI (page + widgets) -> Bloc -> UseCase -> Repository (abstract, domain) -> DataSource (remote/local, data)`

- `domain/` is pure Dart: entities, repository contracts, use cases. Depends on nothing else.
- `data/` implements the contracts: models (DTOs) with `fromJson`/`toMap`/`toEntity`, repository impls, remote (`http`) + local (`sqflite`) data sources.
- `presentation/` is Bloc + pages + per-state widgets.
- **Entity != Model.** Mapping lives on the model (`toEntity()`), never in the repository.

## State (house default)

Single immutable `State extends Equatable` + a `Status` enum + `copyWith`. For lists add `hasReachedMax` and `isLoadingMore`; treat empty as `loaded` with an empty list. This is the default because these states share data and must survive transitions (paging, refresh, error-with-stale-list) — which `copyWith` does cleanly.

**Escape hatch:** use sealed state subclasses _only_ for fully disjoint states with no shared data, and flag it in review. Otherwise default to single-state.

## Error taxonomy

`DataSource` throws typed exceptions (`ServerException`, `NetworkException`, `CacheException`). The repository maps each to its own `Failure` (`ServerFailure`, `NetworkFailure`, `CacheFailure`) and returns `Either<Failure, T>`. **Never** bucket unknown errors into a catch-all failure, and never wrap a bare `catch (e)` that hides programmer errors — unexpected exceptions should be loud.

## Concurrency

List/search blocs use `bloc_concurrency` transformers: `droppable()` for "load next page" (ignore extra events mid-fetch), `restartable()` for refresh/search (cancel the previous run). Never fire overlapping page fetches.

## Before you finish (checklist)

- [ ] No fetching / paging / caching / try-catch inside any widget.
- [ ] State renders loading, empty, error, and data — each one reachable.
- [ ] List paginates via the bloc with `hasReachedMax` + a `droppable()` transformer.
- [ ] Offline: repository returns cached data (`Right`), not an error.
- [ ] Each exception maps to a specific `Failure`; no catch-all, no silent `catch (e)`.
- [ ] A `bloc_test` covers first page + next page + end, and a repository test covers offline fallback.

## Reference

`references/conventions.md` has the full rationale and the wiring details — the state-modeling sources, the error-taxonomy table, the offline contract, and the test policy. Read it before implementing.
