import 'package:equatable/equatable.dart';

import '../../../navigation/navigation_command.dart';

class TwoButtonState extends Equatable {
  final List<bool> buttonStates;
  final NavigationCommand? navCommand;

  const TwoButtonState({required this.buttonStates, this.navCommand}) : assert(buttonStates.length == 2);

  TwoButtonState copyWith({List<bool>? buttonStates, NavigationCommand? navCommand}) {
    return TwoButtonState(buttonStates: buttonStates ?? this.buttonStates, navCommand: navCommand);
  }

  @override
  List<Object?> get props => [buttonStates, navCommand];
}
