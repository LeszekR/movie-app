import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';

class ButtonBuilder {
  BuildContext context;
  void Function(BuildContext context)? _onTap;
  Key? _key;
  double _width = AppSizes.buttonWidth;
  double _height = AppSizes.buttonHeight;
  String? _text;
  IconData? _iconData;

  ButtonBuilder(this.context);

  ButtonBuilder onTap(void Function(BuildContext context) onTap) {
    assert(_onTap == null, "Can't set onTap more than once");
    _onTap = onTap;
    return this;
  }

  ButtonBuilder keyString(String keyString) {
    assert(_key == null, "Can't set key more than once");
    _key = Key(keyString);
    return this;
  }

  ButtonBuilder key(Key key) {
    assert(_key == null, "Can't set key more than once");
    _key = key;
    return this;
  }

  ButtonBuilder text(String text) {
    assert(_text == null, "Can't set text more than once");
    _text = text;
    return this;
  }

  ButtonBuilder iconData(IconData iconData) {
    assert(_iconData == null, "Can't set iconData more than once");
    _iconData = iconData;
    return this;
  }

  ButtonBuilder width(double width) {
    assert(_width == AppSizes.buttonWidth, "Can't set width more than once");
    _width = width;
    return this;
  }

  ButtonBuilder height(double height) {
    assert(_height == AppSizes.buttonHeight, "Can't set height more than once");
    _height = height;
    return this;
  }

  Widget build() {
    assert(_onTap != null);
    assert((_text == null) != (_iconData == null));
    return _buildButton();
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: _width,
      height: _height,
      child: ElevatedButton(
        key: _key,
        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
        onPressed: () => _onTap!(context),
        child: _text != null ? Text(_text!) : Icon(_iconData),
      ),
    );
  }
}
