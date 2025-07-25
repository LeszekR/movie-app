import 'package:flutter/material.dart';
import 'package:flutter_demo/components/message_dialog.dart';

import '../common/ui_localized_texts/txt.dart';
import '../common/utils/utils.dart';
import '../get_it_model.dart';

class AppNavigator {

  void progress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
  }

  void dialogError(BuildContext context, Exception e) {
    showDialog(
      context: context,
      builder: (context) {
        return MessageDialog(
            getit<AppNavigator>(),
            buttonSet: EButtonSet.ok,
            title: Txt.get.dialog_title_error,
            text: errorMessage(e),
        );
      },
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
  }

  void popIfPossible(BuildContext context) {
    var nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }
}
