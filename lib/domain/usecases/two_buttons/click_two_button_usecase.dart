import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/utils/use_case_utils.dart';

class ClickButtonUseCase extends UseCase<ClickButtonUseCaseResponse, ClickButtonUseCaseParams> {
  @override
  Future<Stream<ClickButtonUseCaseResponse?>> buildUseCaseStream(ClickButtonUseCaseParams? params) {
    final buttonIndex = params!.clickedButtonIndex;
    final newButtonState = !params.clickedButtonIsOn;

    return Future.value(sendInStream(
      payload: ClickButtonUseCaseResponse(
        buttonIndex,
        clickedButtonIsOn:newButtonState,
      ),
    ),);
  }
}

class ClickButtonUseCaseParams {
  final int clickedButtonIndex;
  final bool clickedButtonIsOn;

  const ClickButtonUseCaseParams(this.clickedButtonIndex, {required this.clickedButtonIsOn});
}

class ClickButtonUseCaseResponse {
  final int clickedButtonIndex;
  final bool clickedButtonIsOn;

  const ClickButtonUseCaseResponse(this.clickedButtonIndex, {required this.clickedButtonIsOn});
}
