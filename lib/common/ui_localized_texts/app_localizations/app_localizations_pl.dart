// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get yes => 'TAK!';

  @override
  String get no => 'Niee...';

  @override
  String get cancel => 'Anuluj';

  @override
  String get dialog_title_error => 'Błąd';

  @override
  String get movie_list_title => 'Przeglądarka filmów';

  @override
  String get budget => 'Budżet';

  @override
  String get revenue => 'Przychody';

  @override
  String get should_i_watch_today => 'Czy mam to dziś obejrzeć?';

  @override
  String get search_prompt => 'szukaj...';

  @override
  String get error_get_movie => 'Nie udało się pobrać filmu.\n\n';

  @override
  String get error_get_searched_movies => 'Nie udało się pobrać listy szukanych filmów.\n\n';

  @override
  String get error_http => 'Błąd HTTP: ';

  @override
  String get error_other => 'Błąd serwera.';

  @override
  String get no_such_movie => 'Nie znaleziono wybranego filmu w bazie danych.';

  @override
  String get no_searched_movies => 'Nie znaleziono filmów o podobnym tytule';

  @override
  String get no_movie_chosen => 'Nie wybrano żadnego filmu';

  @override
  String get goto_two_buttons => 'Pokaż Dwa Przyciski';

  @override
  String get goto_movie_list => 'Pokaż listę filmów';

  @override
  String get two_button_view_title => 'Guziki o dwóch stanach';
}
