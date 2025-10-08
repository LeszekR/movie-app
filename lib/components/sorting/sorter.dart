import 'package:flutter_demo/components/sorting/e_sort_direction.dart';
import 'package:flutter_demo/components/sorting/sort_criteria.dart';
import 'package:flutter_demo/components/sorting/sortable.dart';

class Sorter<T extends Sortable> {
  List<SortCriteria>? _sortCriteriaList = [];

  List<T>? sortColumns(List<T>? listToSort, List<SortCriteria>? sortCriteriaList) {
    if (listToSort == null || listToSort.isEmpty) return null;

    _sortCriteriaList = sortCriteriaList;

    if (_sortCriteriaList == null) return listToSort;
    if (_sortCriteriaList!.isEmpty) return listToSort;

    _validateCriteriaListLength(listToSort[0], sortCriteriaList!);
    _validateCriteriaUnique(listToSort[0], sortCriteriaList);

    listToSort.sort(_compare);

    return listToSort;
  }

  int _compare(Sortable a, Sortable b) {
    int result;
    Comparable<dynamic> firstValue;
    Comparable<dynamic> secondValue;

    for (final sortCriteria in _sortCriteriaList!) {
      if (sortCriteria.sortDirection == ESortDirection.asc) {
        firstValue = a.getSortableFieldsMap()[sortCriteria.fieldKey]!;
        secondValue = b.getSortableFieldsMap()[sortCriteria.fieldKey]!;
      } else {
        firstValue = b.getSortableFieldsMap()[sortCriteria.fieldKey]!;
        secondValue = a.getSortableFieldsMap()[sortCriteria.fieldKey]!;
      }

      result = firstValue.compareTo(secondValue);
      if (result != 0) return result;
    }
    return 0;
  }

  void _validateCriteriaListLength(Sortable sortedElement, List<SortCriteria> sortCriteriaList) {
    final nSortableFields = sortedElement.getSortableFieldsMap().length;
    final nSortCriteria = sortCriteriaList.length;

    final errorMsg = makeErrMsgTooManyCriteria(sortedElement, nSortableFields, nSortCriteria);
    assert(nSortCriteria <= nSortableFields, errorMsg);
  }

  void _validateCriteriaUnique(Sortable sortedElement, List<SortCriteria> sortCriteriaList) {
    final sortedClassFieldNames = sortedElement.getSortableFieldsMap().keys;
    final sortCriteriaFieldNames = sortCriteriaList.map((entry) => entry.fieldKey).toList();

    final List<String> absentFieldsList =
        sortCriteriaFieldNames.where((fieldName) => !sortedClassFieldNames.contains(fieldName)).toList();

    if (absentFieldsList.isEmpty) return;

    final String absentFieldNames = absentFieldsList.reduce((result, fieldName) => '$result,$fieldName');
    final String errorMsg = makeErrMsgForeignKeys(sortedElement, absentFieldNames);
    assert(false, errorMsg);
  }

  String makeErrMsgTooManyCriteria(Sortable sortedElement, int nSortableFields, int nSortCriteria) =>
      'Forbidden attempt at sorting list of ${sortedElement.runtimeType}'
      ' having $nSortableFields sortable fields '
      'with $nSortCriteria sort criteria';

  String makeErrMsgForeignKeys(Sortable sortedElement, String foreignKeyNames) =>
      'Attempt to sort by fields: "$foreignKeyNames" which are absent in class ${sortedElement.runtimeType}';
}
