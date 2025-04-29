import 'package:flutter_recruitment_task/utils/sorting/e_sort_direction.dart';
import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';

import 'column_sort_criteria.dart';

class SortableSorter<T extends Sortable> {

  // In case new data was received but sort criteria have not changed the new data will be sorted with the same order
  // as the last sorting order chosen by the user - it is saved here.
  List<SortCriteria>? _sortCriteriaList = [];

  void sortColumns(List<T>? listToSort, {final List<SortCriteria>? sortCriteriaList}) {
    if (listToSort == null || listToSort.isEmpty) return;

    _sortCriteriaList = sortCriteriaList;

    if (_sortCriteriaList == null) return;

    listToSort.sort(_compare);
  }

  int _compare(Sortable a, Sortable b) {
    int result;
    dynamic firstValue, secondValue;

    for (var sortCriteria in _sortCriteriaList!) {
      if (sortCriteria.sortDirection == ESortDirection.asc) {
        firstValue = a.getSortableFields()[sortCriteria.fieldIndex];
        secondValue = b.getSortableFields()[sortCriteria.fieldIndex];
      } else {
        firstValue = b.getSortableFields()[sortCriteria.fieldIndex];
        secondValue = a.getSortableFields()[sortCriteria.fieldIndex];
      }
      result = firstValue.compareTo(secondValue);
      if (result != 0) return result;
    }
    return 0;
  }
}
