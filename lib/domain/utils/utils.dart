import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

Stream<T> sendInStream<T>({T? payload, Exception? exception}) {
  assert((payload == null) != (exception == null));

  StreamController<T> streamController = StreamController();

  if (payload != null) streamController.add(payload);
  if (exception != null) streamController.addError(exception);

  streamController.close();
  return streamController.stream;
}

void sendToIsolate(BackgroundUseCaseParams<dynamic> params, dynamic e) {
  params.port.send(BackgroundUseCaseMessage(data: e));
}
