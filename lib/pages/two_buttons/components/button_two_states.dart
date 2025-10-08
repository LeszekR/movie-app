import 'package:flutter/material.dart';

class ButtonTwoStates extends StatefulWidget {
  static MaterialColor colorOn = Colors.green;
  static MaterialColor colorOff = Colors.red;

  final bool isOn;
  final int index;
  final ValueChanged<bool> onChange;

  const ButtonTwoStates({
    required this.index, required this.onChange, super.key,
    this.isOn = false,
  });

  @override
  ButtonTwoStatesState createState() => ButtonTwoStatesState();
}

class ButtonTwoStatesState extends State<ButtonTwoStates> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _toggleState,
        child: Container(
          width: 80.0,
          height: 56.0,
          color: _isOn ? ButtonTwoStates.colorOn : ButtonTwoStates.colorOff,
        ),
      );
  }

  void _toggleState() {
    _isOn = !_isOn;
    setState(() {});
    widget.onChange(_isOn);
  }
}
