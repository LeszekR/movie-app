import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../domain/usecases/two_buttons/click_button_usecase.dart';
import '../../../../get_it_model.dart';

class TwoButtonsPresenter extends Presenter {
  Function? clickButtonOnNext;
  Function? clickButtonOnComplete;
  Function? clickButtonOnError;

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
    _presenter.clickButtonOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.clickButtonOnError?.call(e);
  }

  @override
  void onNext(ClickButtonUseCaseResponse? response) {
    _presenter.clickButtonOnNext?.call(response);
  }
}
