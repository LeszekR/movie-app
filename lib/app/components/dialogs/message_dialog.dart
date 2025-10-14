import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/app/components/buttons/button_builder.dart';
import 'package:flutter_demo/app/components/dialogs/dialog_params.dart';
import 'package:flutter_demo/app/config/app_colors.dart';
import 'package:flutter_demo/app/config/app_sizes.dart';
import 'package:flutter_demo/app/config/app_style.dart';
import 'package:flutter_demo/app/ui_localized_texts/app_localizations/app_localizations.dart';

class MessageDialog extends StatelessWidget {
  final DialogParams _params;

  const MessageDialog(
    this._params, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.numpadEnter):
            kIsWeb ? const ButtonActivateIntent() : const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const CancelIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyC): const CancelIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyO): const OkIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyY): const YesIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyN): const NoIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _onOk(context),
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) => _onOk(context),
          ),
          OkIntent: CallbackAction<OkIntent>(
            onInvoke: (_) => _onOk(context),
          ),
          CancelIntent: CallbackAction<CancelIntent>(
            onInvoke: (_) => _onCancel(context),
          ),
          YesIntent: CallbackAction<YesIntent>(
            onInvoke: (_) => _onYes(context),
          ),
          NoIntent: CallbackAction<NoIntent>(
            onInvoke: (_) => _onNo(context),
          ),
        },
        child: Focus(
          autofocus: true,
          child: _buildDialogContent(context),
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.dialogMaxWidth,
          maxHeight: AppSizes.dialogContentMaxHeight,
        ),
        child: Scaffold(
          appBar: _params.title == null
              ? null
              : AppBar(
                  backgroundColor: AppColors.appBarBackground,
                  automaticallyImplyLeading: false,
                  title: Text(_params.title!),
                ),
          backgroundColor: AppColors.dialogBackground,
          body: Center(
            child: Text(
              _params.text,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          bottomNavigationBar: Container(
            height: AppSizes.dialogBottomBarHeight,
            padding: const EdgeInsets.all(AppSizes.paddingForWidget),
            child: Row(children: _makeButtonsRow(context)),
          ),
        ),
      ),
    );
  }

  List<Widget> _makeButtonsRow(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_params is DialogParamsOk) {
      return [
        AppStyle.filler(),
        ButtonBuilder(context).onTap(_onOk).text(localizations.ok).build(),
      ];
    }
    if (_params is DialogParamsOkCancel) {
      return [
        AppStyle.filler(),
        ButtonBuilder(context).onTap(_onOk).text(localizations.ok).build(),
        AppStyle.horizontalSeparator(),
        ButtonBuilder(context).onTap(_onCancel).text(localizations.cancel).build(),
      ];
    }
    if (_params is DialogParamsYesNo) {
      return [
        AppStyle.filler(),
        ButtonBuilder(context).onTap(_onYes).text(localizations.yes).build(),
        AppStyle.horizontalSeparator(),
        ButtonBuilder(context).onTap(_onNo).text(localizations.no).build(),
      ];
    }
    if (_params is DialogParamsYesNoCancel) {
      return [
        AppStyle.filler(),
        ButtonBuilder(context).onTap(_onYes).text(localizations.yes).build(),
        AppStyle.horizontalSeparator(),
        ButtonBuilder(context).onTap(_onNo).text(localizations.no).build(),
        AppStyle.horizontalSeparator(),
        ButtonBuilder(context).onTap(_onCancel).text(localizations.cancel).build(),
      ];
    }
    throw UnimplementedError();
  }

  void _popAndThrow(BuildContext context, String msg) {
    Navigator.of(context).pop();
    throw UnimplementedError(msg);
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onOk(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onYes(BuildContext context) {
    _popAndThrow(context, 'Dialog Yes button - callback not implemented');
  }

  void _onNo(BuildContext context) {
    _popAndThrow(context, 'Dialog No button - callback not implemented');
  }
}

class CancelIntent extends Intent {
  const CancelIntent();
}

class OkIntent extends Intent {
  const OkIntent();
}

class YesIntent extends Intent {
  const YesIntent();
}

class NoIntent extends Intent {
  const NoIntent();
}
