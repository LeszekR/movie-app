import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/two_buttons/button_two_states.dart';

class TwoButtonsPage extends StatefulWidget {
  const TwoButtonsPage({super.key});

  @override
  TwoButtonsPageState createState() => TwoButtonsPageState();
}

class TwoButtonsPageState extends State<TwoButtonsPage> {
  final List<bool> _buttonIsOn = [true, false];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('2-state buttons'),
          centerTitle: true,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTwoStates(
                index: 0,
                isOn: _buttonIsOn[0],
                onChange: (bool isOn) => _onButtonValueChange(index: 0, isOn: isOn),
              ),
              const SizedBox(width: 8),
              ButtonTwoStates(
                index: 1,
                isOn: _buttonIsOn[1],
                onChange: (bool isOn) => _onButtonValueChange(index: 1, isOn: isOn),
              ),
            ],
          ),
        ),
      );

  void _onButtonValueChange({required int index, required bool isOn}) {
    final int indexOtherButton = (index + 1) % _buttonIsOn.length;

    _buttonIsOn[index] = isOn;
    _buttonIsOn[indexOtherButton] = !isOn;

    setState(() {});
  }
}
