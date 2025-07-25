import 'package:flutter/material.dart';

import '../common/ui_localized_texts/txt.dart';

class AppNavigator {
  void dialogError(BuildContext context, Exception e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          actions: <Widget>[
            ElevatedButton(
              child: Text(Txt.get.ok),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
  }

  void progressIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
  }

}