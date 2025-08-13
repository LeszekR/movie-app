import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../domain/usecases/two_buttons/click_button_usecase.dart';
import '../../../../bootstrap/get_it_model.dart';

class TwoButtonsPresenter extends Presenter {
  Function? clickButtonOnNext;

  final ClickButtonUseCase _clickButtonUseCase;

  TwoButtonsPresenter() : _clickButtonUseCase = getIt<ClickButtonUseCase>();

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
