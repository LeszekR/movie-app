import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/navigation/app_nav_commands.dart';
import 'package:flutter_demo/pages/two_buttons/bloc/two_button_state.dart';

class TwoButtonCubit extends Cubit<TwoButtonState> {

  TwoButtonCubit(super.initialState);

  void toggleOn(int buttonIndex){
    final prevButtonStates = state.buttonStates;
    final buttonStates = [
      if (buttonIndex == 0) !prevButtonStates[0] else prevButtonStates[0],
      if (buttonIndex == 1) !prevButtonStates[1] else prevButtonStates[1],
    ];
    emit(state.copyWith(buttonStates: buttonStates));
  }

  void showMovieList(BuildContext context) {
    emit(state.copyWith(navCommand: NavMovieList()));
  }
}
