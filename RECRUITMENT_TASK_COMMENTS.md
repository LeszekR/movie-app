Intro
===================================================================

This file is here only for recruitment purposes. It would not exist in regular work task. It explains most important decisions in the project.

Overview
----------------------------------  

###

#### External libraries

- `flutter_clean_architecture`
- `get_it`
- `GoRouter`

###

#### Features and choices

- decided on inside-class `GetIt` lookup pattern instead of constructor-injection- for reasons
  explained below
- introduced handling all exceptions by logging or rethrowing them to `Controllers` which then
  handle them
- Introduced `restoreView` field in `MovieListState` to reduce the number of `Widget's` rebuilds to
  returns from navigation only
- attached `TwoButtonView` to navigation and refactored its logic to `flutter_clean_architecture`
- used two types of call chain for navigation:
    - triggered by `Controllers` via `NavigationCommand`
      field in the `view`'s `state`,
    - triggered by the `View` via direct call to its `<PageName>Navigator`
      object
- introduced localization to prepare the app for dynamic change of UI language
- introduced '.env' file with app parameters (`AppConfig`)
- created multi-column, stable, generic sorting class (`Sorter`)
- put string literals in constant strings to prevent typos and enable intellisense (
  e.g. `lib/routing/go_router_const_strings.dart` and other)
- created `controllerTest` blueprinted on `controllerTest` for easy testing `Controller.state` reactions
  to calls to their methods
- created gitlab pipeline

#

------------------

Details
----------------------------------  

###

### Dependency injection via in-class `getIt` lookup

#### Available options

- DI via constructors
- DI via `GetIt` lookup calls inside classes
- hybrid mix of both

There are reasons to use each of those choices.   
I decided on the last since.  
Whether it is the right choice it can be discussed. For presentation purposes used it here although
just as well one might decide on any other - depending on given app architecture decisions.

#### DI via `GetIt` lookup calls inside classes is best for

- Small apps, prototypes, or solo projects where speed > ceremony.
- Well-isolated feature modules where you accept global DI for convenience.
- Read-mostly services (e.g., config, logging) with simple lifecycles.

#### Benefits of `GetIt` lookups inside classes

- Low boilerplate: No constructor threading; quick to wire small/medium features.
- Late binding: Resolve at use-site; easy to swap registrations centrally.
- Global reach: Access anywhere (including deep widgets without extra params).
- Constructor stability: Widget/class signatures stay small and stable over time.
- Incremental adoption: You can retrofit DI into legacy code without wide refactors.

#### Downsides of `GetIt` lookups inside classes

- Hidden dependencies: Not visible in constructor; harder to read/review & reason about.
- Tighter coupling to locator: Classes aren’t portable without GetIt present (service‑locator
  anti‑pattern).
- Harder testing/mocking: Must prime/reset the global container; tests become order‑dependent;
  parallel tests risky.
- Lifecycle ambiguity: Who owns/disposes instances? Easy to leak streams/controllers if not
  carefully scoped.
- Init order traps: Using a service before it’s registered causes runtime failures; async init is
  especially tricky.
- Multiple instance pitfalls: If you mix factories/singletons, you may accidentally get different
  instances across code paths.
- Refactor friction: IDE “find usages” won’t reveal consumers; dependencies are discovered only at
  runtime.
- Implicit singletons: Encourages using singletons where a scoped instance would be safer (e.g., per
  screen).
- Hot reload surprises: Re-registration/state carryover can yield stale or duplicated singletons.
- Boundary blur: Domain layer silently depends on app layer if it pulls from GetIt, weakening
  architecture boundaries.

###

##### Triggering navigation through a `Controller`

- since a `Controller` exists outside UI layer then to keep clear separation of responsibilities
  routing should not be called from there
- but in many cases the `Controller` actually must call routing
- hence routing from `MovieListView` to `MovieDetailsView` or any dialog is done with the use of
  its `Controller.state.navCommand` field, which then triggers navigation from inside the `Widget`
- with this solution necessary for some routes I had to choose: keep the routing path consistent
  across the whole app? - what forces other navigation calls to be done the same way, or call
  routing directly in a button's `onTap` callback?
- I decided to keep the code as simple as possible hence routing that is initiated by a `Widget` is
  called directly from there
- that is why navigation to `TwoButtonView` and back to `MovieDetailsView` is called this simpler
  way
- this solution is disputable though since it breaks consistency of the architecture; so if the
  priority is strict architectural rules it should be changed to passing all navigation through the
  related `Controller`'s `state.navCommand`

#

------------------

Details
----------------------------------  

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

(Package: `lib/utils/sorting`)

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

- SortableSorter throws if `sortCriteriaList` is longer than the number of sortable fields in the
  sorted type. This is to prevent unexpected behaviour when the same column is sorted twice making
  it difficult to debug the sorting result.
- SortableSorter throws on attempt to use `fieldKey` not existing in the `Sortable`
  implementation. One scenario when this may happen is dev's error while declaring initial sorting
  order by hand. This safe-check prevents debugging later.

###

##### Const strings in place of hardcoding strings

I always use static const string instead of hardcoded string ids because:

- hardcoded string ids used in multiple code places WILL result in typo errors and waste of time for
  debugging them
- using variables in place of typing allows using intellisense for them
