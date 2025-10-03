import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:flutter_demo/domain/usecases/two_buttons/click_two_button_usecase.dart';
import 'package:flutter_demo/bootstrap/get_it_model.dart';

class TwoButtonsPresenter extends Presenter {
  Function? clickButtonOnNext;

  final ClickTwoButtonUseCase _clickButtonUseCase;

  TwoButtonsPresenter() : _clickButtonUseCase = getIt<ClickTwoButtonUseCase>();

  @override
  void dispose() {
    _clickButtonUseCase.dispose();
  }

  void clickButton(int clickedButtonIndex, bool clickedButtonIsOn) {
    _clickButtonUseCase.execute(
      _TwoButtonsClickObserver(this),
      ClickButtonUseCaseParams(clickedButtonIndex, clickedButtonIsOn),
    );
  }
}

class _TwoButtonsClickObserver extends Observer<ClickButtonUseCaseResponse> {
  final TwoButtonsPresenter _presenter;

  _TwoButtonsClickObserver(this._presenter);

  @override
  void onComplete() {
    // no op
  }

  @override
  void onError(e) {
    // no op
  }

  @override
  void onNext(ClickButtonUseCaseResponse? response) {
    _presenter.clickButtonOnNext?.call(response);
  }
}
