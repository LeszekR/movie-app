sealed class ThreeStateValue<T> {
  final T? value;
  const ThreeStateValue.value(this.value);
  const ThreeStateValue.none() : value = null;
}

class ThreeStateInt extends ThreeStateValue<int> {
 const ThreeStateInt.value(super.value) : super.value();
  const ThreeStateInt.none() : super.none();
}
