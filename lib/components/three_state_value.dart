import 'package:equatable/equatable.dart';

sealed class ThreeStateValue<T> extends Equatable{
  final T? value;
  final bool hasValue;

  const ThreeStateValue.value(this.value) : hasValue = true;

  const ThreeStateValue.none()
      : value = null,
        hasValue = false;

  @override
  List<Object?> get props => [value, hasValue];
}

class ThreeStateInt extends ThreeStateValue<int> {
  const ThreeStateInt.value(super.value) : super.value();
  const ThreeStateInt.none() : super.none();
}
