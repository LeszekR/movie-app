import 'package:equatable/equatable.dart';

sealed class DialogParams extends Equatable {
  final String? title;
  final String text;

  const DialogParams(this.text, [this.title]);

  @override
  List<Object?> get props => [title, text];
}

class DialogParamsOk extends DialogParams {
  const DialogParamsOk(super.text, [super.title]);
}

class DialogParamsYesNo extends DialogParams {
  const DialogParamsYesNo(super.text, [super.title]);
}

class DialogParamsOkCancel extends DialogParams {
  const DialogParamsOkCancel(super.text, [super.title]);
}
