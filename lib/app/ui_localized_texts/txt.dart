import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';

class Txt {
  late AppLocalizations _localizations;

  void setLanguage(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get get => _localizations;
}
