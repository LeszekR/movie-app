import 'package:flutter_demo/app/navigation/navigation_command.dart';

class TwoButtonsState {
  final List<bool> buttonStates = [true, true];
  NavigationCommand? navCommand;

  void update({
    ButtonState? buttonState,
    NavigationCommand? navCommand,
  }) {
    if (buttonState != null) buttonStates[buttonState.buttonIndex] = buttonState.isOn;
    this.navCommand = navCommand;
  }
}

class ButtonState {
  final int buttonIndex;
  final bool isOn;

  const ButtonState(this.buttonIndex, this.isOn);
}
