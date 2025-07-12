Intro
===================================================================

1. This file is here only for recruitment purposes. It would not exist in regular work task.
2. On **02.05.2025** feature implementation is completed but the solution is still under works -
   remaining issues are listed in issues in GitLab repo.
4. With current tiny size of the project some of my solutions are an overkill. But they prepare the
   project for smooth codebase growth.

## Implementation stages

- STAGE 1: At this stage all the task requirements were fulfilled with addition some additional
  features. They have already been presented to the recruitment team and the original comments to
  them are located at the end of this file.

- STAGE 2: Now next elements have been implemented following directions received from the
  recruitment team

# STAGE 2

Overview
----------------------------------  
New features and refactoring

- introduced `flutter_clean_architecture` package and refactored the whole project to its directives
  and API
- introdueced `get_it`'`

#

------------------

Details
----------------------------------  

###

##### Using `flutter_clean_architecture`

- using `BackgroundUseCase` may be an overkill - I did it only for practise and skill presentation,
  although such a query might indeed be heavy

##### Using `get_it` alongside `riverpod`

- I mixed the use of `riverpod` and `get_it` only for skill presentation - normally only
  one of them would be used to keep the project clean

#    

------------------

# STAGE 1

Overview
----------------------------------  

Additional features  
(apart recruitment task requirements, features essential for any project):

- introduced `GoRouter`
- introduced `Riverpod` for state management and DI (first used `Provider` then refactored)
- created multi-column, stable, generic sorting class (`Sorter`)
- separated business logic from `Widget` ui-concerned code (classes: `MovieListController`
  , `MovieDetailsController`)
- wrapped web requests with error-handling (`ApiService`)
- refactored string literals to constant strings to prevent typos and enable intellisense (
  e.g. `lib/routing/go_router_const_strings.dart` and other)
- introduced localization to prepare the app for dynamic change of UI language
- introduced '.env' file with app parameters (`AppConfig`)
- created some unit tests (`Sorter` tests)
- created some tests using mocked dependencies and localized strings (`MovieListPage`
  , `MovieDetailsPage`,' tests - created tests do NOT cover all functionality as they should in real
  life)
- created gitlab pipeline

#

------------------

Details
----------------------------------  

###

##### Widget state preserved on navigation in `MovieListPage`

Noticed that navigating back from MovieDetails cleared movie list.

To solve this I:

- introduced `Riverpod` to preserve the state of `MovieListPage`
- added `TextEditingController` to `SearchBox`
- added `ScrollController` to `ListView`
- store state of them all in `MovieListState`

This way on navigation back the following UI elements restore their last state:

- list of movies: contents
- list of movies: scrolling
- list of movies: selection
- search box: text

###

##### Error handling in `ApiService`

- Added error handling there
- this needs to be complemented with custom exceptions
- the exceptions should both: log errors (for devs) and show error dialogs (for the user to know
  what and why happened).

###

##### `MovieDetails` as `StatelessWidget`

- Since for now this page does not need `State` and it seems to me its task will not call for it in
  the future - refactored to `StatelessWidget` to simplify the code.
- Also extracted this page's logic to separate class. This is consistent with my approach
  to `MovieListPage` and done for the same reasons.

###

##### Package go_router

I used `GoRouter` in place of `Navigator` for the benefits it provides

I am not sure whether navigation in `MovieListPage._onOpenMovieDetailsTap()` is correct. I
implemented solution that prevents the use of `BuildContext` over async gap but probably in this
case this is unnecessary. If so then I will refactor and simplify the code.

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

###

##### Naming - prefixes

Rationale:

- you can use intellisense quicker if name groups are prefixed with chars / words reducing
  intellisense list.
- code becomes this bit more readable with enums and interfaces immediately showing their genre

Approach:

- variable names prefixed with identyfying word (e.g.: `route...`, `param...`, 'key...')
- enum names: preceded by letter "E"
- interface names: preceded by letter "I"

###

##### Naming - suffixes

- I prefer to add suffix to variables of type `List`, `Map`, etc.
- It makes it easier for me to clearly see what variable I am looking at in any corner of the code.
- This approach reduces variable-type dictionary otherwise necessary to be kept in dev's mind for
  them to remember what hides behind the var name. Alternately it saves time on checking var
  declarations.
- Examples: `sortCriteriaList`, `getSortableFieldsMap`.

