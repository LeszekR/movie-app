import 'package:equatable/equatable.dart';

import 'e_sort_direction.dart';

class SortCriteria extends Equatable {
  final String fieldKey;
  final ESortDirection sortDirection;

  const SortCriteria(this.fieldKey, this.sortDirection);

  @override
  List<Object?> get props => [fieldKey, sortDirection];
}