import 'package:flutter/cupertino.dart';

import 'app_localizations/app_localizations.dart';

class Txt {
  late AppLocalizations _localizations;

  // Txt._();

  void setLanguage(final BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get get => _localizations;
}
