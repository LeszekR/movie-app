import 'package:flutter_demo/app/navigation/navigation_command.dart';

class TwoButtonsState {
  final List<bool> buttonStates = [true, true];
  NavigationCommand<dynamic>? navCommand;

  void update({
    ButtonState? buttonState,
    NavigationCommand<dynamic>? navCommand,
  }) {
    if (buttonState != null) buttonStates[buttonState.buttonIndex] = buttonState.isOn;
    this.navCommand = navCommand;
  }
}

class ButtonState {
  final int buttonIndex;
  final bool isOn;

  const ButtonState(this.buttonIndex, {required this.isOn});
}
