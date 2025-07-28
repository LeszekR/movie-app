import 'package:bloc/bloc.dart';
import 'package:flutter_demo/features/two_buttons/bloc/two_button_state.dart';

import '../../../navigation/nav_commands_common.dart';

class TwoButtonCubit extends Cubit<TwoButtonState> {

  TwoButtonCubit(super.initialState);

  void toggleOn(int buttonIndex){
    var prevButtonStates = state.buttonStates;
    var buttonStates = [
      buttonIndex == 0 ? !prevButtonStates[0] : prevButtonStates[0],
      buttonIndex == 1 ? !prevButtonStates[1] : prevButtonStates[1],
    ];
    emit(state.copyWith(buttonStates: buttonStates));
  }

  void showMovieList() {
    emit(state.copyWith(navCommand: MovieListNav()));
  }
}