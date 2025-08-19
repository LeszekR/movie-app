import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'app_localizations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @ok.
  ///
  /// In pl, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In pl, this message translates to:
  /// **'TAK!'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pl, this message translates to:
  /// **'Niee...'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @dialog_title_error.
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get dialog_title_error;

  /// No description provided for @movie_list_title.
  ///
  /// In pl, this message translates to:
  /// **'Przeglądarka filmów'**
  String get movie_list_title;

  /// No description provided for @budget.
  ///
  /// In pl, this message translates to:
  /// **'Budżet'**
  String get budget;

  /// No description provided for @revenue.
  ///
  /// In pl, this message translates to:
  /// **'Przychody'**
  String get revenue;

  /// No description provided for @should_i_watch_today.
  ///
  /// In pl, this message translates to:
  /// **'Czy mam to dziś obejrzeć?'**
  String get should_i_watch_today;

  /// No description provided for @search_prompt.
  ///
  /// In pl, this message translates to:
  /// **'szukaj...'**
  String get search_prompt;

  /// No description provided for @error_get_movie.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać filmu.\n\n'**
  String get error_get_movie;

  /// No description provided for @error_get_searched_movies.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać listy szukanych filmów.\n\n'**
  String get error_get_searched_movies;

  /// No description provided for @error_http.
  ///
  /// In pl, this message translates to:
  /// **'Błąd HTTP: '**
  String get error_http;

  /// No description provided for @error_other.
  ///
  /// In pl, this message translates to:
  /// **'Błąd serwera.'**
  String get error_other;

  /// No description provided for @no_such_movie.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono wybranego filmu w bazie danych.'**
  String get no_such_movie;

  /// No description provided for @no_searched_movies.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono filmów o podobnym tytule'**
  String get no_searched_movies;

  /// No description provided for @no_movie_chosen.
  ///
  /// In pl, this message translates to:
  /// **'Nie wybrano żadnego filmu'**
  String get no_movie_chosen;

  /// No description provided for @goto_two_buttons.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż Dwa Przyciski'**
  String get goto_two_buttons;

  /// No description provided for @goto_movie_list.
  ///
  /// In pl, this message translates to:
  /// **'Pokaż listę filmów'**
  String get goto_movie_list;

  /// No description provided for @two_button_view_title.
  ///
  /// In pl, this message translates to:
  /// **'Guziki o dwóch stanach'**
  String get two_button_view_title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
