# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Kilian is a Flutter app that estimates trekking trail durations. Users describe a hike as a list of segments (horizontal distance, elevation delta, M.I.D. difficulty level) and Kilian computes per-segment and total hiking/resting times based on the user's fitness level. Runs on Android, iOS, and web (deployed at https://kilian-app.web.app/).

Flutter SDK is pinned to `>=3.10.0 <3.11.0` and Dart SDK `>=2.18.0 <3.0.0` (see `pubspec.yaml`) — the repo uses the pre–Dart 3 null-safety dialect, no records/patterns.

## Common commands

```bash
flutter pub get                         # install deps
flutter run -d chrome                   # run the web build locally
flutter run                             # run on a connected device/emulator
flutter test                            # run all tests
flutter test test/widget_test.dart      # run a single test file
flutter test --name "pattern"           # run tests matching a name
flutter analyze                         # lint (uses very_good_analysis + overrides in analysis_options.yaml)
flutter gen-l10n                        # regenerate AppLocalizations from lib/l10n/arb/*.arb (config in l10n.yaml)
dart run build_runner build --delete-conflicting-outputs   # regenerate *.g.dart JSON serialization
```

`*.g.dart` and `*.json.dart` files are generated and excluded from analysis — re-run `build_runner` after editing any `@JsonSerializable` class in `lib/models/`.

## Architecture

### State management — Redux (mid-migration to BLoC)

The app uses **Redux** via `redux: ^5.0.0` + `flutter_redux: ^0.10.0`. `bloc`/`flutter_bloc` are already listed in `pubspec.yaml` but not yet wired in.

Redux wiring:

- `lib/states/app_state.dart` — `AppState` holds `UserParameters` + `TrailViewModel`. A single `AppStore` singleton (`AppStore.instance`) is created from `AppState.initial()` and injected at the root via `StoreProvider` in `lib/main.dart`.
- `lib/states/app_action.dart` — `AppAction` base class and the combined root `appStateReducer`, composed from `TypedReducer`s per feature.
- `lib/states/trail_action.dart`, `lib/states/user_parameters_action.dart` — feature actions (`AddSegmentAction`, `RemoveSegmentAction`, `ReplaceSegmentAction`, `ReorderSegmentAction`, `ChangeFitnessAction`) and their reducers. Reducers are pure and always rebuild `TrailViewModel` through `utils.computeTrailView` so derived durations stay in sync with the segment list and user parameters.
- Pages dispatch directly via `AppStore.instance.dispatch(...)` (see `lib/pages/home_page.dart`) and read state via `StoreBuilder<AppState>`.

Any new Redux action must: extend `AppAction` (or a feature subclass), add a branch to the relevant feature reducer, and — if it affects segments or parameters — route its result through `computeTrailView` so `TrailViewModel.duration` / `resting` remain consistent.

### Domain model

- `lib/models/trail.dart` — `TrailSegment` (horizontal distance, elevation delta, `MIDLevel`), `Trail<T extends TrailSegment>` (generic container with aggregate getters `distance`, `hdist`, `dplus`, `dminus`), and the `MIDLevel` enum (`easy`…`extreme`) used as a difficulty multiplier.
- `lib/models/calculator.dart` — `TrailCalculator` interface + `StandardTrailCalculator`. The standard calculator uses fixed speeds (4 km/h flat, +400 m/h up, −600 m/h down), a flat-threshold (`±50 m/km`), and multiplies the base time by per-`MIDLevel` and per-`FitnessLevel` factor tables. Resting time is 10 min per hiked hour, bucketed into 5-minute slots. `TrailCalculatorJsonConverter` switches on a `type` discriminator so the calculator is serializable inside `UserParameters`.
- `lib/models/user.dart` — `UserParameters` (fitness + calculator) and `FitnessLevel` enum.
- `lib/view-models/trail.dart` — `TrailSegmentViewModel` / `TrailViewModel` extend the plain models and carry computed `duration` / `resting` fields. `computeTrailView` in `lib/states/utils.dart` is the single place that derives them: it accumulates a "remainder" of sub-10-minute rests across segments and rounds the final resting duration to 5-minute slots — edit it carefully, the reducers all call it.

### UI layers

- `lib/pages/` — `HomePage` (summary + reorderable segment list + add/edit dialog) and `SettingsPage`. Navigation uses `go_router` configured in `lib/pages/router.dart` (single `home` route; `GoRouterExtended` provides `goReplacementNamed` / `pushReplacementNamed` helpers that wrap `Router.neglect`).
- `lib/widgets/` — reusable widgets split by concern (`trail.dart`, `user.dart`, `form_fields.dart`, `basic.dart`, `painting.dart`, `responsive.dart`, `theme.dart`). `responsive.dart` exports `kMinWidthTablet`; layouts constrain content to this width and use `responsive_builder` for breakpoint logic.
- Segment reordering: tiles become draggable only while the position index is pressed (see recent commit `446006b`); `HomePage._buildDragTarget` inserts thin `DragTarget<int>` bands between tiles and dispatches `ReorderSegmentAction(oldPos, newPos)`, where the reducer adjusts the insert index when moving forward.

### Localization

ARB files live in `lib/l10n/arb/` (template `app_en.arb`). `l10n.yaml` drives `flutter gen-l10n` to produce `AppLocalizations`, which is re-exported via `lib/l10n/l10n.dart` and accessed in widgets as `context.l10n.<key>`. Add a new string by editing every `app_*.arb` and re-running `flutter gen-l10n`.

## Conventions enforced by `analysis_options.yaml`

Base ruleset is `very_good_analysis`, with the following relaxed locally (don't re-introduce them in PRs):

- `new` and repeated `const` keywords are allowed and used throughout the codebase — keep the style consistent.
- Relative imports within `lib/` are allowed (`always_use_package_imports: false`); both relative and `package:kilian/...` imports appear — match the surrounding file.
- `final` parameters are allowed (and widely used on reducer/helper signatures).
- Lines may exceed 80 chars; local variable type annotations are not required; constructors do not need to be declared first.
- `implicit-casts` and `implicit-dynamic` are off — be explicit with types.
- Generated files (`lib/**.g.dart`, `lib/**.json.dart`) are excluded from analysis.

## Tests

The codebase does NOT currently contain any actual tests.
