import 'package:flutter_demo/domain/services/sorting/e_sort_direction.dart';

class SortCriteria {
  final String fieldKey;
  final ESortDirection sortDirection;

  const SortCriteria(this.fieldKey, this.sortDirection);
}
