import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';

import '../../common/ui_localized_texts/txt.dart';
import 'dialog_params.dart';

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
            child: Row(children: _makeButtonsRow(context)),
          ),
        ),
      ),
    );
  }

  List<Widget> _makeButtonsRow(BuildContext context) {
    if (_params is DialogParamsOk) {
      return [
        AppSizes.filler(),
        ButtonBuilder().onTap(() => Navigator.of(context).pop()).text(_txt.get.ok).build(),
      ];
    }
    if (_params is DialogParamsOkCancel) {
      return [
        AppSizes.filler(),
        ButtonBuilder()
            .onTap(() => _popAndThrow(context, "Dialog Ok-Cancel buttons' callbacks not implemented"))
            .text(_txt.get.ok)
            .build(),
        AppSizes.horizontalSeparator(),
        ButtonBuilder()
            .onTap(() => _popAndThrow(context, "Dialog Ok-Cancel buttons' callbacks not implemented"))
            .text(_txt.get.cancel)
            .build(),
      ];
    }
    if (_params is DialogParamsYesNo) {
      return [
        AppSizes.filler(),
        ButtonBuilder()
            .onTap(() => _popAndThrow(context, 'Dialog Yes-No buttons callbacks not implemented'))
            .text(_txt.get.yes)
            .build(),
        AppSizes.horizontalSeparator(),
        ButtonBuilder()
            .onTap(() => _popAndThrow(context, 'Dialog Yes-No buttons callbacks not implemented'))
            .text(_txt.get.no)
            .build(),
      ];
    }
    throw UnimplementedError();
  }

  void _popAndThrow(BuildContext context, String msg) {
    Navigator.of(context).pop();
    throw UnimplementedError(msg);
  }
}
