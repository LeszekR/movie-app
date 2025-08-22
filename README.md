Intro
===================================================================

This file is here only for recruitment skills presentation. It would not exist in regular work task.
It explains most important decisions in the project.

I implemented this app in 4 versions which are in 4 branches of the repo

- **01_Riverpod_GoRouter_DotEnv_Mockito**
- **02_FlutterCleanArch_GetIt_BackgroundUseCase**
- **03_FlutterCleanArch_GetIt_GoRouter**
- **04_BLoC_GetIt_Navigator**

The first two deliver basic functionality. The last two deliver identical and full functionality -
with dialogs, progress indicators, dynamic language setting, additional page. They all differ in
used flutter packages - on purpose.

The last two allow for easy comparison of approaches - differences are only where forced by the FCA
or BLoC concepts - the rest is shared.

I keep the 02 branch only to demonstrate the use of `BackgroundUseCase` with factory pattern. Other
than that FCA with main isolate usecases only is fully exploited in the 03 branch.

## How to Run

- Flutter version: ^3.29.0
- Run: `flutter pub get`, then `flutter run` / `flutter test`

Branch: 03_FlutterCleanArch_GetIt_GoRouter
===================================================================

Overview
----------------------------------  

###

#### The defining external libraries

###

**branch-specific**

- `flutter_clean_architecture`
- `go_router`

###

**common for branches 03 and 04**

- `get_it`
- `flutter_localizations`
- `dotenv`
- `flutter_test`
- `integration_test`
- `mockito`

###

#### Features and choices

**Specific for this branch**

- decided on inside-class `GetIt` lookup pattern instead of constructor-injection- for reasons
  explained below
- introduced handling all exceptions by logging or rethrowing them to `Controllers` which then
  handle them
- attached `TwoButtonView` to navigation and refactored its logic to `flutter_clean_architecture`
- created `controllerTest` blueprinted on `blocTest` for easy testing `Controllers'`
  reactions to calls to their methods (commented further down)
- created tests of `MovieListController` covering all possible state transitions
- introduced localization and dynamic change of UI language via `MovieAppController`, app starts
  with language declared in dotenv
- sorting (see `Sorter` below) is run via `SortMoviesUseCase` ready for future implementation of
  dynamic sorting of the movie list

###

**Shared by both fully-implemented branches 03 and 04**

- extracted app navigation to hybrid pattern: local `MovieListNavigator`, global `AppNavigator` in
  order to separate navigation concern from UI and business logic and keep feature-local navigation
  separated from global navigation
- used navigation triggered by `Controllers` via `NavigationCommand` field in the `view`'s `state`
  as commented below
- `NavigationCommand` follows a single-use pattern to prevent multiple navigation triggers
- Introduced `restoreView` field in `MovieListState` to reduce the number of `Widget's` rebuilds to
  returns from navigation only
- used `ListView.builder` in `MovieListView` instead of `ListFiew.separated` to speed up the build
  of large lists (even though slightly slower for small lists as in this app)
- introduced 'dotenv' file with app parameters (`AppConfig`)
- introduced `CircularProgressIndicator` during async tasks, navigated to and from in `BlocListener`
  by global `AppNavigator`
- introduced proper `MessageDialog` class to communicate errors and messages to the user; the class
  uses custom `ButtonBuilder` and `DialogFactory` to create standardized buttons and
  case-specialised dialogs with only minimal amount of code
- introduced custom `Exceptions` that control specialized error-dialogs to separate business logic
  from UI and precisely identify and show to the user app's failures'  causes
- created multi-column, stable, generic sorting class (`Sorter`)
- put string literals in constant strings to prevent typos and enable intellisense (
  e.g. `navigation/go_router_const_strings.dart` and other)
- centralized Widget sizes in single class `AppSizes`, colors in `AppColors`, styles in `AppStyle`
  to control over the app's look from one place in the code
- switched colors of `ButtonTwoStates` - because unless this was intentional (project decision to be
  asked?) the colors were assigned counterintuitively for any user in our civilisation (**red** was
  **ON** - **green** was **OFF** - now it is the opposite)
- created a sample of unit tests (`Sorter` tests)
- created a sample of tests using mocked dependencies and localized strings (`MovieListPage`,
  `MovieDetailsPage`,' tests - created tests do NOT cover all functionality as they should in real
  life)
- created tests do NOT cover all that should be tested in the app - only because of sole skill
  presentation purpose of this project
- run FlutterDevTools and found jank in one frame of `ListView` build (from 20 to 100 ms) - since
  there is no jank during scrolling - used this one to demonstrate the use of FlutterDevTools even
  though jank in a single frame during a large rebuild on the user's demand is acceptable - hence
  optimized the code to speed up building movies list:
    - extracted calculation of rating strings into `MovieListController` async function run before
      build, (even though async overhead in this case makes it slightly slower it is ready for large
      lists that might cause new jank),
    - surrounded `ListView` with `RepaintBoundariy`,
    - replaced colored `Containers` serving as dividers with const `Dividers` ,
    - replaced `Column` used for each `MovieCard` + `Divider` with `Dividers` added as every odd
      element of the `ListView`,
    - replaced `Containers` with `SizedBoxes`,
    - only the one selected `MovieCard` builds surrounding `ColoredBox`,
    - used `const` constructors wherever possible
- created gitlab pipeline

#

------------------

Details
----------------------------------  

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
- I decided to create it as possibly the easiest and most consistent way to transfer tests
  between `BLoC` and `flutter_clean_architecture` implementations of the app

###

#### Additional params

The `controllerTest` has extra params to adjust to `flutter_clean_architecture`

- `asyncTicks`: total number of: `Futures`, `onNext(...)` calls and other `async`
  calls - between each two states of the controller
- `setMocks` - self explanatory

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
- This pattern maintains a clear separation between business logic and UI, and keeps
  the `Controller`
  testable and platform-independent.
- with this solution necessary for some routes I had to choose: keep the routing path consistent
  across the whole app? - do other navigation calls the same way, or call such routing directly in a
  button's `onTap` callback?
- I decided to keep the code consistent hence routing that is initiated by a `Widget` is done via
  the same chain - that is why navigation to `TwoButtonView` and back to `MovieDetailsView` is
  called this way
- it is also possible in `flutter_clean_architecture` to invoke UI elements directly from the
  `Controller` using `getState()`, yet I chose my approach for stricter adherence to Clean
  Architecture principles and easier testing. This solution is disputable though since it
  complicates the code making it more difficult to read, so the choice of one of those solutions
  would be the team's in a production project.

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

- It is standard in desktop UI lists that they are sortable by clicking column headers. With
  the `Sorter` class only minimum amount of code is necessary to implement it.
- 'SortableSorter' offers:
    - hierarchical sorting by multiple columns
    - sorting is stable for child-criteria within parent-criteria
    - maintaining last sorting criteria on data refresh

###

##### Error checks in SortableSorter

- `Sorter` throws if `sortCriteriaList` is longer than the number of sortable fields in the sorted
  type. This is to prevent unexpected behaviour when the same column is sorted twice making it
  difficult to debug the sorting result.
- `Sorter` throws on attempt to use `fieldKey` not existing in the `Sortable`
  implementation. One scenario when this may happen is dev's error while declaring initial sorting
  order by hand. This safe-check prevents debugging later.

###

### Const strings in place of hardcoded

I always use static const string instead of hardcoded string ids because:

- hardcoded string ids used in multiple code places WILL result in typo errors and waste of time for
  debugging them
- using variables in place of typing additionally allows using intellisense for them
