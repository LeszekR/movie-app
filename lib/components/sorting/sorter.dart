
import 'package:flutter_demo/components/sorting/sortable.dart';

import 'e_sort_direction.dart';
import 'sort_criteria.dart';

class Sorter<T extends Sortable> {
  List<SortCriteria>? _sortCriteriaList = [];

  void sortColumns(List<T>? listToSort, final List<SortCriteria>? sortCriteriaList) {
    if (listToSort == null || listToSort.isEmpty) return;

    _sortCriteriaList = sortCriteriaList;

    if (_sortCriteriaList == null) return;
    if (_sortCriteriaList!.isEmpty) return;

    _validateCriteriaListLength(listToSort[0], sortCriteriaList!);
    _validateCriteriaUnique(listToSort[0], sortCriteriaList);

    listToSort.sort(_compare);
  }

  int _compare(Sortable a, Sortable b) {
    int result;
    dynamic firstValue, secondValue;

    for (var sortCriteria in _sortCriteriaList!) {
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

    String errorMsg = makeErrMsgTooManyCriteria(sortedElement, nSortableFields, nSortCriteria);
    assert(nSortCriteria <= nSortableFields, errorMsg);
  }

  void _validateCriteriaUnique(Sortable sortedElement, final List<SortCriteria> sortCriteriaList) {
    var sortedClassFieldNames = sortedElement.getSortableFieldsMap().keys;
    var sortCriteriaFieldNames = sortCriteriaList.map((entry) => entry.fieldKey).toList();

    List<String> absentFieldsList =
        sortCriteriaFieldNames.where((fieldName) => !sortedClassFieldNames.contains(fieldName)).toList();

    if (absentFieldsList.isEmpty) return;

    String absentFieldNames = absentFieldsList.reduce((result, fieldName) => '$result,$fieldName').toString();
    String errorMsg = makeErrMsgForeignKeys(sortedElement, absentFieldNames);
    assert(false, errorMsg);
  }

  String makeErrMsgTooManyCriteria(Sortable sortedElement, int nSortableFields, int nSortCriteria) =>
      'Forbidden attempt at sorting list of ${sortedElement.runtimeType.toString()}'
      ' having $nSortableFields sortable fields '
      'with $nSortCriteria sort criteria';

  String makeErrMsgForeignKeys(Sortable sortedElement, String foreignKeyNames) =>
      'Attempt to sort by fields: "$foreignKeyNames" which are absent in class ${sortedElement.runtimeType.toString()}';
}
