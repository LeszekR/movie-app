// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get yes => 'YES!';

  @override
  String get no => 'Nooo...';

  @override
  String get cancel => 'Anuluj';

  @override
  String get dialog_title_error => 'Error';

  @override
  String get movie_list_title => 'Movie Browser';

  @override
  String get budget => 'Budget';

  @override
  String get revenue => 'Revenue';

  @override
  String get should_i_watch_today => 'Should I watch it today?';

  @override
  String get search_prompt => 'Search...';

  @override
  String get error_get_movie => 'Failed to fetch movie from web.\n\n';

  @override
  String get error_get_searched_movies => 'Failed to fetch searched movies.\n\n';

  @override
  String get error_http => 'HTTP error: ';

  @override
  String get no_such_movie => 'Chosen movie details have not been found in the database.';
}
