import 'package:flutter_recruitment_task/utils/sorting/e_sort_direction.dart';
import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';

import 'column_sort_criteria.dart';

class SortableSorter<T extends Sortable> {
  List<SortCriteria>? _sortCriteriaList = [];

  void sortColumns(List<T>? listToSort, {final List<SortCriteria>? sortCriteriaList}) {
    if (listToSort == null || listToSort.isEmpty) return;

    _sortCriteriaList = sortCriteriaList;

    if (_sortCriteriaList == null) return;

    validateSortCriteria(listToSort[0], sortCriteriaList!);

    listToSort.sort(_compare);
  }

  int _compare(Sortable a, Sortable b) {
    int result;
    dynamic firstValue, secondValue;

    for (var sortCriteria in _sortCriteriaList!) {
      if (sortCriteria.sortDirection == ESortDirection.asc) {
        firstValue = a.getSortableFields()[sortCriteria.fieldKey];
        secondValue = b.getSortableFields()[sortCriteria.fieldKey];
      } else {
        firstValue = b.getSortableFields()[sortCriteria.fieldKey];
        secondValue = a.getSortableFields()[sortCriteria.fieldKey];
      }
      result = firstValue.compareTo(secondValue);
      if (result != 0) return result;
    }
    return 0;
  }

  void validateSortCriteria(Sortable listToSortElement, final List<SortCriteria> sortCriteriaList) {
    var nSortableFields = listToSortElement.getSortableFields().length;
    var nSortCriteria = sortCriteriaList.length;
    var sortedType = listToSortElement.runtimeType.toString();
    assert(nSortCriteria <= nSortableFields,
        "Forbidden attempt at sorting list of $sortedType"
            " having $nSortableFields sortable fields"
            " with $nSortCriteria sort criteria");
  }
}
