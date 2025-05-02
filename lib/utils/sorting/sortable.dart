abstract class Sortable {
  /* Return list of the class fields that are to be used as sort criteria in table of such objects.
  * Do NOT put here fields that are never to serve as sorting criteria.
  * */
  Map<String, dynamic> getSortableFieldsMap();
}
