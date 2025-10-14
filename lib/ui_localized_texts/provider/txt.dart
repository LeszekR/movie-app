import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/ui_localized_texts/app_localizations/app_localizations.dart';

class Txt {
  static late AppLocalizations _localizations;

  Txt._();

  static void setLanguage(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  static AppLocalizations get get => _localizations;
}
