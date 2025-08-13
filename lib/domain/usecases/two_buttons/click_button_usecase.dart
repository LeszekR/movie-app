import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_demo/domain/utils/utils.dart';

class ClickButtonUseCase extends UseCase<ClickButtonUseCaseResponse, ClickButtonUseCaseParams> {

  @override
  Future<Stream<ClickButtonUseCaseResponse?>> buildUseCaseStream(ClickButtonUseCaseParams? params) {
    return Future.value(sendInStream(
      payload: ClickButtonUseCaseResponse(
        params!.clickedButtonIndex,
        !params.clickedButtonIsOn,
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
