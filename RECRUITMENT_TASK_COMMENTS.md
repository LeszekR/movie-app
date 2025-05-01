# Racruitment task comments

- This file is here only for recruitment purposes. I would not exist in regular work task
- It explains some of my decisions in the project.
- I suggest you read it before reading the code.

## GoRouter

### go_router package

I used it in place of ```Navigator``` for the benefits it provides

### const strings in place of hardcoding strings

I always use static const string instead of hardcoded string ids because:

- hardcoded string ids used in multiple code places WILL result in typo errors and waste of time for
  debugging them
- using variables in place of typing allows using intellisense for those ids
- in case of key-strings like ```static String keyId = 'movieId'``` I prefixed them with class id to
  prevent accidental wrong use

### Separate files for GoRouter and routing const strings

Package: ```lib/utils/routing```
With growing number of routes such solution allows the dev to just toggle between two files each
scrolled to the relevant piece of code. With the const strings and the router in single file the dev
has to scroll between the string declarations and currently implemented route code. Impractical.
Slow. Quicker to Ctrl+Tab between the 2 files.

With current tiny size of the project this is an overkill. But add 2 more routes and you start
scrolling. This prepares the project for codebase growth.

###### Sorting

### Sorting by multiple columns (class fields)

Package: ```lib/utils/sorting```
Simplest sorting in single line of code would satisfy the task's basic requirement. But it would
have to be refactored to offer the user standard sorting functionality they will find in any other
app.

Hence I implemented sorting

- by multiple columns - any number of them
- stable within sorting criteria
- saved and restored on data refresh
- ready to implement sorting triggered by the user, e.g. by clicking column headers

### Error check in SortableSorter

SortableSorter

- throws if ```sortCriteriaList``` is longer than the number of sortable fields in the sorted type.
  This is to prevent unexpected behaviour since if the number were greater then the same column
  would have to be sorted twice making it difficult to debug the sorting result.
- will throw on attempt to sort by column index out of bounds of sorted fields list - but this will
  be taken care by dart // TODO make sure it is true, implement the assert if not

###### Code style

### Naming

Rationale:

- you can use intellisense quicker if name groups are prefixed with chars / words reducing
  intellisense list.
- code becomes this bit more readable with enums and interfaces immediately showing their genre

I try to achieve this with the following naming approach:

- variable names prefixed with identyfying word (e.g.: ```route...```, ```param...```)
- enum names: preceded by letter "E"
- interface names: preceded by letter "I"

#### Miscellaneous

- changed ```apiService.searchMovies(text)``` to ```apiService.searchMovies(query)``` to keep the
  arg ```query``` consistent with API arg name (readability)
-

### ??? MovieDetailsPage refactored to StatelessWidget ???

yyyy

1. zzzz.

2. qqqq

```
flutter pub run build_runner build --delete-conflicting-outputs
```

