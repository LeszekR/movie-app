import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/config/app_sizes.dart';

class ButtonBuilder {
  void Function()? _onTap;
  double _width = AppSizes.buttonWidth;
  double _height = AppSizes.buttonHeight;
  String? _caption;
  IconData? _iconData;

  ButtonBuilder();

  ButtonBuilder onTap(void Function() onTap) {
    _onTap = onTap;
    return this;
  }

  ButtonBuilder text(String text) {
    _caption = text;
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

  Widget build() {
    assert (_onTap != null);
    assert((_caption == null) != (_iconData == null));
    return SizedBox(
      width: _width,
      height: _height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: _onTap,
        child: _caption != null ? Text(_caption!) : Icon(_iconData!),
      ),
    );
  }
}
