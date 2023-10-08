extension ListExtension<E> on List<E> {
  /// The first indexed element that satisfies the given predicate [test].
  ///
  /// Iterates through the elements and returns the first result
  /// satisfying the predicate [test] in the record format (index, element).
  ///
  /// If no element satisfies [test], the result of calling the [orElse] function is returned.
  (int index, E?) firstIndexedWhere(
    bool Function(E element) test, {
    required (int index, E?) Function() orElse,
  }) {
    var index = 0;
    for (var element in this) {
      if (test(element)) return (index, element);
      index++;
    }
    return orElse();
  }

  /// Iterates through the elements in search of the first element with the status [MessageStatus.sent],
  /// that satisfies the parameters [email] and [messageContent].
  ///
  /// If such an element is found, it is map according to the [toElement] function,
  /// otherwise the [orElse] function is executed.
  ///
  /// Returns a modified list.
  List<E> mapWhere(
    bool Function(E element) test, {
    required E Function(E e) toElement,
  }) {
    for (var element in this) {
      if (test(element)) toElement(element);
    }
    return this;
  }
}
