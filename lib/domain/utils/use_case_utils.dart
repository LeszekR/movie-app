import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

/// Utility for main isolate UseCase creating main-isolate stream returning UseCase response to the Presenter.
Stream<T> sendInStream<T>({T? payload, Exception? exception}) {
  assert((payload == null) != (exception == null));

  StreamController<T> streamController = StreamController();

  if (payload != null) streamController.add(payload);
  if (exception != null) streamController.addError(exception);

  streamController.close();
  return streamController.stream;
}

/// Utility for BackgroundUseCase creating inter-isolate message returning UseCase response to the Presenter.
void sendToIsolate(BackgroundUseCaseParams<dynamic> params, dynamic e) {
  params.port.send(BackgroundUseCaseMessage(data: e));
}
