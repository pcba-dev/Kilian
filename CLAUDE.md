# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About Kilian

Kilian is a Flutter app that calculates accurate time estimates for trekking trails. Users input trail segments (horizontal distance, elevation change, M.I.D. difficulty level) along with their fitness level, and the app computes hiking and resting durations using the FEDME M.I.D. classification system.

## Commands

```bash
# Run the app (web)
flutter run -d chrome

# Analyze code (linting)
flutter analyze

# Generate JSON serialization code (run after modifying `@JsonSerializable` models)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

The app uses **Redux** for state management (via `redux` + `flutter_redux` packages). State is immutable and flows unidirectionally.

### State Layer (`lib/states/`)
- `app_state.dart` — Defines `AppState` (holds `UserParameters` + `TrailViewModel`) and the singleton `AppStore`
- `app_action.dart` — Base `AppAction` class; combines reducers via `combineReducers`
- `trail_action.dart` — `TrailAction` subclasses (`AddSegmentAction`, `RemoveSegmentAction`, `ReplaceSegmentAction`, `ReorderSegmentAction`) and their reducers
- `user_parameters_action.dart` — Actions for updating user fitness/calculator settings
- `utils.dart` — `computeTrailView()`: recomputes the full `TrailViewModel` from a `Trail` + `UserParameters` (called by every trail reducer)

### Models (`lib/models/`)
- `trail.dart` — `TrailSegment` (hdist, dalt, MIDLevel), `Trail<T>`, `MIDLevel` enum; uses `json_serializable` (`.g.dart` files are generated)
- `user.dart` — `UserParameters` (fitness level + calculator ref), `FitnessLevel` enum
- `calculator.dart` — `TrailCalculator` abstract class; `StandardTrailCalculator` implements the core algorithm (Tobler-style formula combining horizontal distance and elevation change, corrected by M.I.D. and fitness factors)
- `geospatial.dart` — `Coordinates`, `WayPoint` models

### View Models (`lib/view-models/`)
- `trail.dart` — `TrailSegmentViewModel` (extends `TrailSegment` adding per-segment `duration`/`resting`) and `TrailViewModel` (extends `Trail` adding total `duration`/`resting`). Also has `Duration2Human` extension for display formatting.

### Routing (`lib/pages/router.dart`)
Uses `go_router`. Routes defined via `PagesRoutes` enum. Currently only one route: home (`/`).

### Localization (`lib/l10n/`)
Flutter's built-in `flutter_localizations` with ARB files for English (`app_en.arb`), Spanish (`app_es.arb`), and French (`app_fr.arb`). Config in `l10n.yaml`.

### Testing (`test/`)
- `test/helpers/pump_app.dart` — `pumpApp()` extension on `WidgetTester` that wraps widgets with localization support. Use this in widget tests instead of raw `pumpWidget`.

## Code Style

Linting via `very_good_analysis`. Notable rule overrides (in `analysis_options.yaml`):
- `always_use_package_imports: false` — relative imports are allowed within `lib/`
- `lines_longer_than_80_chars: false` — no line length limit
- `public_member_api_docs: false` — doc comments not required
- Generated files (`*.g.dart`, `*.json.dart`) are excluded from analysis

## Key Patterns

- All state mutations go through Redux actions — never mutate state directly
- Models that need JSON serialization use `@JsonSerializable()` and require running `build_runner` to regenerate `.g.dart` files
- `TrailCalculator` is designed for extension — new calculator types should subclass it and register in `TrailCalculatorJsonConverter.fromJson()`
- Responsive layout uses the `responsive_builder` package
