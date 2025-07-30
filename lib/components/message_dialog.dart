import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';

import '../common/ui_localized_texts/txt.dart';

enum EButtonSet { ok, yesNo, okCancel }

class MessageDialog extends StatelessWidget {
  final Txt _txt;
  final DialogParams _params;

  const MessageDialog(
    this._txt,
    this._params, {
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
          appBar: _params.title == null
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(_params.title!),
                ),
          // TODO apply color from AppColors
          backgroundColor: Colors.amber.shade100,
          body: Center(
            child: Text(
              _params.text,
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
      children: switch (_params.buttonSet) {
        EButtonSet.ok => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(_txt.get.ok).build(),
          ],
        EButtonSet.okCancel => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(_txt.get.ok).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(_txt.get.cancel).build(),
          ],
        EButtonSet.yesNo => [
            AppSizes.filler(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(_txt.get.yes).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => Navigator.of(context).pop()).text(_txt.get.no).build(),
          ],
      },
    );
  }
}

class DialogParams extends Equatable {
  final EButtonSet buttonSet;
  final String? title;
  final String text;

  const DialogParams(this.buttonSet, this.title, this.text);

  @override
  List<Object?> get props => [buttonSet, title, text];
}
