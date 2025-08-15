import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/two_buttons/controller/two_buttons_state.dart';
import 'package:flutter_demo/app/pages/two_buttons/presenter/two_buttons_presenter.dart';
import 'package:flutter_demo/domain/usecases/two_buttons/click_two_button_usecase.dart';

import '../../../../bootstrap/get_it_model.dart';

class TwoButtonsController extends Controller {
  final TwoButtonsState state;
  final TwoButtonsPresenter _presenter;

  TwoButtonsController()
      : state = getIt<TwoButtonsState>(),
        _presenter = getIt<TwoButtonsPresenter>();

  @override
  void initListeners() {
    _presenter.clickButtonOnNext = _setButtonsState;
  }

  void clickButton(int buttonIndex) {
    _presenter.clickButton(buttonIndex, state.buttonStates[buttonIndex]);
  }

  _setButtonsState(ClickButtonUseCaseResponse r) {
    state.update(buttonState: ButtonState(r.clickedButtonIndex, r.clickedButtonIsOn));
    refreshUI();
  }
}
