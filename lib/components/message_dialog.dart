import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';

import '../common/ui_localized_texts/txt.dart';

enum EButtonSet { ok, yesNo, okCancel }

class MessageDialog extends StatelessWidget {
  final DialogParams params;

  const MessageDialog(
    this.params, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppSizes.dialogMaxWidth,
          maxHeight: AppSizes.dialogContentMaxHeight,
        ),
        child: Scaffold(
          appBar: params.title == null
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(params.title!),
                ),
          // TODO apply color from AppColors
          backgroundColor: Colors.amber.shade100,
          body: Center(
            child: Text(
              params.text,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            padding: EdgeInsets.all(AppSizes.paddingForWidget),
            child: _makeButtonsRow(context),
          ),
        ),
      ),
    );
  }

  Row _makeButtonsRow(BuildContext context) {
    return Row(
      children: switch (params.buttonSet) {
        EButtonSet.ok => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(Txt.get.ok).build(),
          ],
        EButtonSet.okCancel => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(Txt.get.ok).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(Txt.get.cancel).build(),
          ],
        EButtonSet.yesNo => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(Txt.get.yes).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(Txt.get.no).build(),
          ],
      },
    );
  }
}

class DialogParams {
  final EButtonSet buttonSet;
  final String? title;
  final String text;

  const DialogParams(this.buttonSet, this.title, this.text);
}
