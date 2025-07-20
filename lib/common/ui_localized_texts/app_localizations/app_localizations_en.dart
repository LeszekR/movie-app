// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get yes => 'YES!';

  @override
  String get no => 'Nooo...';

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
}
