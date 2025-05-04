import 'package:flutter_recruitment_task/utils/sorting/e_sort_direction.dart';
import 'package:flutter_recruitment_task/utils/sorting/sortable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sort_criteria.dart';

class Sorter<T extends Sortable> {
  List<SortCriteria>? _sortCriteriaList = [];

  void sortColumns(List<T>? listToSort, {final List<SortCriteria>? sortCriteriaList}) {
    if (listToSort == null || listToSort.isEmpty) return;

    _sortCriteriaList = sortCriteriaList;

    if (_sortCriteriaList == null) return;

    _validateCriteriaListLength(listToSort[0], sortCriteriaList!);

    listToSort.sort(_compare);
  }

  int _compare(Sortable a, Sortable b) {
    int result;
    dynamic firstValue, secondValue;

    for (var sortCriteria in _sortCriteriaList!) {
      _validateCriteriaKey(a, sortCriteria);

      if (sortCriteria.sortDirection == ESortDirection.asc) {
        firstValue = a.getSortableFieldsMap()[sortCriteria.fieldKey];
        secondValue = b.getSortableFieldsMap()[sortCriteria.fieldKey];
      } else {
        firstValue = b.getSortableFieldsMap()[sortCriteria.fieldKey];
        secondValue = a.getSortableFieldsMap()[sortCriteria.fieldKey];
      }

      result = firstValue.compareTo(secondValue);
      if (result != 0) return result;
    }
    return 0;
  }

  void _validateCriteriaListLength(Sortable sortedElement, final List<SortCriteria> sortCriteriaList) {
    var nSortableFields = sortedElement.getSortableFieldsMap().length;
    var nSortCriteria = sortCriteriaList.length;
    var sortedElementType = sortedElement.runtimeType.toString();
    assert(
        nSortCriteria <= nSortableFields,
        'Forbidden attempt at sorting list of $sortedElementType'
        ' having $nSortableFields sortable fields'
        ' with $nSortCriteria sort criteria');
  }

  void _validateCriteriaKey(Sortable sortedElement, SortCriteria sortCriteria) {
    var fieldKey = sortCriteria.fieldKey;
    var isKeyPresent = sortedElement.getSortableFieldsMap().keys.contains(fieldKey);
    assert(isKeyPresent, 'Key $fieldKey does not exist in ${sortedElement.runtimeType.toString()}');
  }
}

// Riverpod fails to create generic class providers from annotation
Provider<Sorter<T>> createSortableSorterProvider<T extends Sortable>() {
  return Provider<Sorter<T>>((ref) {
    return Sorter<T>();
  });
}
