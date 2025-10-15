import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/app/pages/two_buttons/presenter/two_buttons_presenter_callbacks.dart';
import 'package:flutter_demo/domain/usecases/two_buttons/click_two_button_usecase.dart';

class TwoButtonsPresenter extends Presenter {
  ClickButtonOnNext? clickButtonOnNext;

  final ClickButtonUseCase _clickButtonUseCase;

  TwoButtonsPresenter(this._clickButtonUseCase);

  @override
  void dispose() {
    _clickButtonUseCase.dispose();
  }

  void clickButton(int clickedButtonIndex, {required bool clickedButtonIsOn}) {
    _clickButtonUseCase.execute(
      _TwoButtonsClickObserver(this),
      ClickButtonUseCaseParams(clickedButtonIndex, clickedButtonIsOn: clickedButtonIsOn),
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
  void onError(dynamic e) {
    // no op
  }

  @override
  void onNext(ClickButtonUseCaseResponse? response) {
    if (response == null) return;
    _presenter.clickButtonOnNext?.call(response);
  }
}
