Intro
===================================================================

This file is here only for recruitment purposes. It would not exist in regular work task. It
explains most important decisions in the project.

I implemented this app in 4 versions which are in 4 branches of the repo

- **01_Riverpod_GoRouter_DotEnv_Mockito**
- **02_FlutterCleanArch_GetIt_BackgroundUseCase**
- **03_FlutterCleanArch_GetIt_fully_implemented**
- **04_BLoC_GetIt_Navigator**

The first two deliver basic functionality. The last two deliver identical and full functionality -
with dialogs, progress indicators, dynamic language setting, additional page. They all differ in
used flutter packages - on purpose.

The last two allow for easy comparison of approaches - differences are only where forced by the FCA
or BLoC concepts - the rest is shared.

I keep the 02 branch only to shows the use of `BackgroundUseCase` with factory pattern. Other than
that FCA with main isolate usecases only is fully exploited in the 03 branch.

Branch: 03_FlutterCleanArch_GetIt_fully_implemented
===================================================================

Overview
----------------------------------  

###

#### The defining external libraries

- `flutter_clean_architecture`
- `get_it`
- `go_router`
- `flutter_localizations`
- `dotenv`
- `flutter_test`
- `integration_test`
- `mockito`

###

#### Features and choices

- decided on inside-class `GetIt` lookup pattern instead of constructor-injection- for reasons
  explained below
- introduced handling all exceptions by logging or rethrowing them to `Controllers` which then
  handle them
- Introduced `restoreView` field in `MovieListState` to reduce the number of `Widget's` rebuilds to
  returns from navigation only
- attached `TwoButtonView` to navigation and refactored its logic to `flutter_clean_architecture`
- used navigation triggered by `Controllers` via `NavigationCommand` field in the `view`'s `state`
  as commented below
- used `ListView.builder` in `MovieListView` instead of `ListFiew.separated` to speed up the build
- introduced 'dotenv' file with app parameters (`AppConfig`)
- introduced localization and dynamic change of UI language via `MovieAppController`
- app starts with language declared in dotenv
- created multi-column, stable, generic sorting class (`Sorter`) run via `SortMoviesUseCase` ready
  for future implementation of dynamic sorting of the movie list
- put string literals in constant strings to prevent typos and enable intellisense (
  e.g. `navigation/go_router_const_strings.dart` and other)
- created `controllerTest` blueprinted on `blocTest` for easy testing `Controllers'`
  reactions to calls to their methods (commented further down)
- created gitlab pipeline

#

------------------

Details
----------------------------------  

###

### Dependency injection via in-class `getIt` lookup

###

#### Available options

- DI via constructors
- DI via `GetIt` lookup calls inside classes
- hybrid mix of both

There are reasons to use each of those choices. I decided on the last since.  
Whether it is the right choice it can be discussed. For presentation purposes used it here although
just as well one might decide on any other - depending on given app architecture decisions.

#### DI via `GetIt` lookup calls inside classes is best for

- Small apps, prototypes, or solo projects where speed > ceremony.
- Well-isolated feature modules where you accept global DI for convenience.
- Read-mostly services (e.g., config, logging) with simple lifecycles.

###

#### Benefits of `GetIt` lookups inside classes

- Widget/class signatures stay small and stable over time.
- Low boilerplate - no constructor threading

###

#### Downsides of `GetIt` lookups inside classes

- Harder to test/mock
- Hidden dependencies - require a look into the constructor implementation

###

### Triggering navigation through a `Controller`

- since a `Controller` exists outside UI layer then to keep clear separation of responsibilities
  routing should not be called from there
- but in many cases the `Controller` actually must call routing
- hence routing from `MovieListView` to `MovieDetailsView` or any dialog is done with the use of
  its `Controller.state.navCommand` field, which then triggers navigation from inside the `Widget`
  using `postFrameCallback`
- This pattern maintains a clear separation between business logic and UI, and keeps the Controller
  testable and platform-independent.
- with this solution necessary for some routes I had to choose: keep the routing path consistent
  across the whole app? - do other navigation calls the same way, or call such routing directly in a
  button's `onTap` callback?
- I decided to keep the code consistent hence routing that is initiated by a `Widget` is done via
  the same chain - that is why navigation to `TwoButtonView` and back to `MovieDetailsView` is
  called this way
- it is also possible in **flutter_clean_architecture** to invoke UI elements directly from the
  `Controller` using `getState()`, yet I chose my approach for stricter adherence to Clean
  Architecture principles and easier testing this solution is disputable though since it complicates
  the code making it more difficult to read, so the choice of one of those solutions would be the
  team's in a production project then to be followed by the dev

###

### Function `controllerTest` blueprinted on `blocTest`

###

Packages:

- `test/test_tools/test_runner`
- `test/app/pages/movie_list/controller`

###

#### Inspired by blocTest:

- Like `blocTest` my `controllerTest` offers declarative test helper for FCA Controllers.
- Sets mocks, registers seed state, builds controller, performs act, skips states to be ignored,
  asserts expected states and verifications.
- I decided it was possibly easiest and most consistent way to transfer tests between `BLoC`
  and `flutter_clean_architecture` implementations of the app

###

#### Additional params

The `controllerTest` has extra params to adjust to `flutter_clean_architecture`

- `asyncTicks` - `asyncTicks`: total number of: `Futures`, `onNext(...)` calls and other `async`
  calls - between each two states of the controller
- `setMocks` - self explanatory

###

### Separate files for GoRouter and routing const strings

Package: `app/navigation`

I prefer const strings as keys/ids/etc instead of hardcoded string literals for reasons explained
further down this file.

- Two files separating `GoRouter` and its navigation string literals make `GoRouter` a bit easier to
  maintain.
- Reason: having 2 separate files while editing a growing number of routes allows the dev to just
  toggle between two files, each scrolled to the relevant piece of code. With single file the dev
  has to scroll up and down between the string declarations and currently implemented route code.
  Impractical. Slow. Quicker to Ctrl+Tab between the 2 files.
- (Scrolling will became necessary with just a few more routes.)

###

### Sorting by multiple columns (class fields)

Package: `domain/services/sorting`

- Simplest sorting in single line of code would satisfy the task's basic requirement.
- But it is standard in desktop UI lists that they are sortable by clicking column headers. To
  achieve that the simple sorting would have to be refactored. Implementing it right away reduces
  overall work intensity of the project.
- Additionally 'SortableSorter' offers:
    - hierarchical sorting by multiple columns
    - sorting is stable for child-criteria within parent-criteria
    - maintaining last sorting criteria on data refresh

###

##### Error checks in SortableSorter

- `Sorter` throws if `sortCriteriaList` is longer than the number of sortable fields in the
  sorted type. This is to prevent unexpected behaviour when the same column is sorted twice making
  it difficult to debug the sorting result.
- `Sorter` throws on attempt to use `fieldKey` not existing in the `Sortable`
  implementation. One scenario when this may happen is dev's error while declaring initial sorting
  order by hand. This safe-check prevents debugging later.

###

### Const strings in place of hardcoding strings

I always use static const string instead of hardcoded string ids because:

- hardcoded string ids used in multiple code places WILL result in typo errors and waste of time for
  debugging them
- using variables in place of typing additionally allows using intellisense for them
