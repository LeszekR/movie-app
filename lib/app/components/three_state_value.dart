sealed class ThreeStateValue<T> {
  final T? value;
  final bool hasValue;

  const ThreeStateValue.value(this.value) : hasValue = true;

  const ThreeStateValue.none()
      : value = null,
        hasValue = false;
}

class ThreeStateInt extends ThreeStateValue<int> {
  const ThreeStateInt.value(super.value) : super.value();
  const ThreeStateInt.none() : super.none();
}
