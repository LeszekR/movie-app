import 'package:flutter/material.dart';

class ButtonTwoStates extends StatefulWidget {
  final bool isOn;
  final int index;
  final ValueChanged<bool> onChange;

  const ButtonTwoStates({
    super.key,
    this.isOn = false,
    required this.index,
    required this.onChange,
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
  Widget build(BuildContext context) => InkWell(
        onTap: _toggleState,
        child: Container(
          width: 80.0,
          height: 56.0,
          color: _isOn ? Colors.red : Colors.green,
        ),
      );

  void _toggleState() {
    _isOn = !_isOn;
    setState(() {});
    widget.onChange(_isOn);
  }
}
