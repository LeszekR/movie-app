import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_sizes.dart';

class ButtonBuilder {
  void Function()? _onTap;
  Key? _key;
  double _width = AppSizes.buttonWidth;
  double _height = AppSizes.buttonHeight;
  String? _caption;
  IconData? _iconData;
  List<LogicalKeyboardKey>? _shortcutKey;

  ButtonBuilder();

  ButtonBuilder onTap(void Function() onTap) {
    _onTap = onTap;
    return this;
  }

  ButtonBuilder keyString(String keyString) {
    assert(_key == null, 'Cant assign keyString - Key has already been declared');
    _key = Key(keyString);
    return this;
  }

  ButtonBuilder key(Key key) {
    assert(_key == null, 'Cant assign Key - keyString has already been declared and the Key created');
    _key = key;
    return this;
  }

  ButtonBuilder text(String text) {
    _caption = text;
    return this;
  }

  ButtonBuilder shortcutKey(List<LogicalKeyboardKey> shortcut) {
    _shortcutKey = shortcut;
    return this;
  }

  ButtonBuilder iconData(IconData iconData) {
    _iconData = iconData;
    return this;
  }

  ButtonBuilder width(double width) {
    _width = width;
    return this;
  }

  ButtonBuilder height(double height) {
    _height = height;
    return this;
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: _width,
      height: _height,
      child: ElevatedButton(
        key: _key,
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: _onTap,
        child: _caption != null ? Text(_caption!) : Icon(_iconData!),
      ),
    );
  }

  Shortcuts _wrapWithShortcuts(List<LogicalKeyboardKey> keyList, Widget child) {
    return Shortcuts(
      shortcuts: Map.fromIterable(keyList, key: (k) => k, value: (_) => const ActivateIntent()),
      // TU PRZERWAŁEM
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) => _onTap!(),
          )
        },
        child: _buildButton(),
      ),
    )
  }

  Widget build() {
    assert(_onTap != null);
    assert((_caption == null) != (_iconData == null));
    if (_shortcutKey != null) {
      return _buildButton();
    } else {
      return _wrapWithShortcuts(_buildButton());
    }
  }
}
