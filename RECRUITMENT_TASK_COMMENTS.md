Intro
===================================================================

- This file is here only for recruitment purposes. It would not exist in regular work task.
- It explains some of my decisions in the project.
- I suggest you read it before reading the code.

Reservations
----------------------------------  

1. On 02.05.2025 feature implementation is completed but the whole task is not - remaining issues
   are mentioned here and all are listed in issues in GitLab repo - the solution is still under
   work.
2. One of the missing parts is tests. Until they are created some functionalities may have bugs.
   (E.g. `SortableSorter` error checks and others.)
3. With current tiny size of the project some of my solutions are an overkill. But they prepare the
   project for smooth codebase growth.
4. I am not sure whether navigation in `MovieListPage._onOpenMovieDetailsTap()` is correct. I
   implemented solution that prevents the use of `BuildContext` over async gap but probably in this
   case this is unnecessary. If so then I will refactor and simplify the code.

#

Implementation choices
====================================================================

#

Navigation
----------------------------------  

####

#### Package go_router

I used `GoRouter` in place of `Navigator` for the benefits it provides

- (TODO)
- (TODO)

####

#### Separate files for GoRouter and routing const strings

(Package: `lib/utils/routing`)

I prefer const strings as keys/ids/etc instead of hardcoded string literals for reasons explained
further down this file.

- Two files separating `GoRouter` and its navigation string literals make `GoRouter` a bit easier to
  maintain.
- Reason: having 2 separate files while editing a growing number of routes allows the dev to just
  toggle between two files, each scrolled to the relevant piece of code. With single file the dev
  has to scroll up and down between the string declarations and currently implemented route code.
  Impractical. Slow. Quicker to Ctrl+Tab between the 2 files.
- (Scrolling will became necessary with just a few more routes.)

#

Sorting
----------------------------------  

###

#### Sorting by multiple columns (class fields)

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

#### Error checks in SortableSorter

- SortableSorter throws if `sortCriteriaList` is longer than the number of sortable fields in the
  sorted type. This is to prevent unexpected behaviour when the same column is sorted twice making
  it difficult to debug the sorting result.
- SortableSorter throws on attempt to use `fieldKey` not existing in the `Sortable`
  implementation. One scenario when this may happen is dev's error while declaring initial sorting
  order by hand. This safe-check prevents debugging later.

#

Code style
====================================================================

####

### Const strings in place of hardcoding strings

I always use static const string instead of hardcoded string ids because:

- hardcoded string ids used in multiple code places WILL result in typo errors and waste of time for
  debugging them
- using variables in place of typing allows using intellisense for them

###

### Naming

##### Prefixes

Rationale:

- you can use intellisense quicker if name groups are prefixed with chars / words reducing
  intellisense list.
- code becomes this bit more readable with enums and interfaces immediately showing their genre

Approach:

- variable names prefixed with identyfying word (e.g.: `route...`, `param...`, 'key...')
- enum names: preceded by letter "E"
- interface names: preceded by letter "I"

###

##### Postfixes

- I prefer to add postfix to variables of type `List`, `Map`, etc.
- It makes it easier for me to clearly see what variable I am looking at in any corner of the code.
  
- This approach reduces variable-type dictionary otherwise necessary to be kept in dev's mind for
  them to remember what hides behind the var name. Alternately it saves time on checking var
  declarations.

Examples: `sortCriteriaList`, `getSortableFieldsMap`.

###

### Argument and variable names consistency

- I prefer to use the same name for a variable over its entire passage from one
  object/method to another. This approach improves code readability.
- Example: I changed originally declared `MovieListPage.... apiService.searchMovies(text)` to `apiService.searchMovies(query)` to keep the
  arg `query` consistent with API arg name in `searchMovies(String query)`.
