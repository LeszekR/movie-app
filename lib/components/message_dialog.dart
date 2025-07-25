import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';
import 'package:flutter_demo/components/button_builder.dart';
import 'package:flutter_demo/navigation/app_navigator.dart';

import '../common/ui_localized_texts/txt.dart';

enum EButtonSet { ok, yesNo, okCancel }

class MessageDialog extends StatelessWidget {
  final AppNavigator _appNavigator;
  final EButtonSet _buttonSet;
  final String? _title;
  final String _text;

  const MessageDialog(
    this._appNavigator, {
    required String text,
    required buttonSet,
    String? title,
    super.key,
  })  : _buttonSet = buttonSet,
        _title = title,
        _text = text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppSizes.dialogMaxWidth,
          maxHeight: AppSizes.dialogContentMaxHeight,
        ),
        child: Scaffold(
          appBar: _title == null
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(_title!),
                ),
          body:
              // TODO apply color from AppColors
              Center(
            child: Text(
              _text,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            padding: EdgeInsets.all(AppSizes.padding),
            child: _makeButtonsRow(context),
          ),
        ),
      ),
    );
  }

  Row _makeButtonsRow(BuildContext context) {
    return Row(
      children: switch (_buttonSet) {
        EButtonSet.ok => [
            AppSizes.spaceFiller(),
            ButtonBuilder(() => _appNavigator.popIfPossible(context)).text(Txt.get.ok).build(),
          ],
        EButtonSet.okCancel => [
            AppSizes.spaceFiller(),
            ButtonBuilder(() => _appNavigator.popIfPossible(context)).text(Txt.get.ok).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => _appNavigator.popIfPossible(context)).text(Txt.get.cancel).build(),
          ],
        EButtonSet.yesNo => [
            AppSizes.spaceFiller(),
            ButtonBuilder(() => _appNavigator.popIfPossible(context)).text(Txt.get.yes).build(),
            AppSizes.horizontalSeparator(),
            ButtonBuilder(() => _appNavigator.popIfPossible(context)).text(Txt.get.no).build(),
          ],
      },
    );
  }
}
