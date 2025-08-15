import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/utils/use_case_utils.dart';

class ClickTwoButtonUseCase extends UseCase<ClickButtonUseCaseResponse, ClickButtonUseCaseParams> {
  @override
  Future<Stream<ClickButtonUseCaseResponse?>> buildUseCaseStream(ClickButtonUseCaseParams? params) {
    var buttonIndex = params!.clickedButtonIndex;
    var newButtonState = !params.clickedButtonIsOn;

    return Future.value(sendInStream(
      payload: ClickButtonUseCaseResponse(
        buttonIndex,
        newButtonState,
      ),
    ));
  }
}

class ClickButtonUseCaseParams {
  final int clickedButtonIndex;
  final bool clickedButtonIsOn;

  const ClickButtonUseCaseParams(this.clickedButtonIndex, this.clickedButtonIsOn);
}

class ClickButtonUseCaseResponse {
  final int clickedButtonIndex;
  final bool clickedButtonIsOn;

  const ClickButtonUseCaseResponse(this.clickedButtonIndex, this.clickedButtonIsOn);
}
