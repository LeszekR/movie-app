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

Branch: 04_BLoC_GetIt_Navigator
===================================================================

Overview
----------------------------------  

###

#### External libraries

- `flutter_bloc`
- 
- `get_it`
- `flutter_localizations`
- `dotenv`
- `flutter_test`
- `integration_test`
- `mockito`

###

#### Features and choices

**Specific for this branch**

- decided on constructor-injection pattern instead of inside-class `GetIt` lookup - for reasons
  explained below
- introduced handling all exceptions by logging or rethrowing them to `Bloc` which then handle them
- attached `TwoButtonView` to navigation and refactored its logic to `fluttter_bloc` architecture
- created tests of `MovieListBloc` covering all possible state transitions
- introduced localization and dynamic change of UI language via `MovieAppCubit`, app starts with
  language declared in dotenv

###

**Shared by both fully-implemented branches 03 and 04**

- extracted app navigation to hybrid pattern: local `MovieListNavigator`, global `AppNavigator` in
  order to separate navigation concern from UI and business logic and keep feature-local navigation
  separated from global navigation
- used navigation triggered by `Controllers` via `NavigationCommand` field in the `view`'s `state`
  as commented below
- `NavigationCommand` follows single-use pattern to prevent unnecessary rebuilds
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
- introduced custom `Exceptions` that control specialized error-dialogs to separate business
  logic from UI and precisely identify and show to the user app's failures'  causes
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
- created gitlab pipeline

#

------------------

Details
----------------------------------  

###

### Dependency injection via constructors

#### Available options

- DI via constructors
- DI via `GetIt` lookup calls inside classes
- hybrid mix of both

There are reasons to use each of those choices.   
I decided on the last since.  
Whether it is the right choice it can be discussed. For presentation purposes used it here although
just as well one might decide on any other - depending on given app architecture decisions.

- DI via constructors is best for large, easily scalable, multi-team, large-codebase projects. Or in
  other wards - real-life commercial projects. The rationale for this is just below.
- objects created with `GetIt` factory must not be dependecies of singletons because this will lead
  to different object returned by `GetIt` while building the singleton and new objects of the type
  injected where the factory provides them at rebuilds of `Widgets` that consume them

#### Benefits of constructors DI:

- Explicit dependencies – you know exactly what the class relies on
- Great for testability without relying on global state
- Makes classes pure and portable (can be reused in non-get_it environments)
- Encourages immutability and decoupling
- Easier for static analysis / code review / documentation

#### Downsides of constructors DI:

- Verbose, especially for deep trees (dependencies need to be thread through layers)
- Constructor signatures grow
- Negative result: oversized boilerplate for small apps or features

###

##### Separate files for GoRouter and routing const strings

(Package: `lib/routing`)

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

##### Sorting by multiple columns (class fields)

(Package: `components/sorting`)

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
- using variables in place of typing allows using intellisense for them

