import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_controller.dart';
import 'package:flutter_demo/app/pages/two_buttons/two_button_navigation/two_button_navigator.dart';

import '../../../../get_it_model.dart';
import 'components/button_two_states.dart';

class TwoButtonsView extends CleanView {
  static var movieListButtonKey = Key("movieListButtonKey");
  static var button1Key = Key('button1Key');
  static var button2Key = Key('button2Key');

  final TwoButtonNavigator _twoButtonNavigator;

  TwoButtonsView({super.key})
      : _twoButtonNavigator = getIt<TwoButtonNavigator>();

  @override
  TwoButtonsViewState createState() => TwoButtonsViewState();
}

class TwoButtonsViewState extends CleanViewState<TwoButtonsView, TwoButtonsController> {
  final List<bool> _buttonIsOn = [true, false];

  TwoButtonsViewState() : super(getIt<TwoButtonsController>());

  @override
  Widget get view {
    return ControlledWidgetBuilder(
        builder: (context, controller) {
          return Scaffold(
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
                    // TU PRZERWAŁEM
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
        }
    );
  }
}
// void _onButtonValueChange({required int index, required bool isOn}) {
//   final int indexOtherButton = (index + 1) % _buttonIsOn.length;
//
//   _buttonIsOn[index] = isOn;
//   _buttonIsOn[indexOtherButton] = !isOn;
//
//   setState(() {});
// }
