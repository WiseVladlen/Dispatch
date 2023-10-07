extension ObjectExtension<T> on T {
  /// Calls the specified function block with this value as its argument and returns its result.
  R let<R>(R Function(T it) operation) => operation(this);
}

extension NullableObjectExtension<T> on T? {
  /// Calls the specified function block with this value as its argument
  /// and returns its result if the value is not null.
  R? safeLet<R>(R Function(T it) operation) {
    final value = this;
    return value != null ? operation(value) : null;
  }
}
