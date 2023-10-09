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
    for (var (index, element) in indexed) {
      if (test(element)) return (index, element);
    }
    return orElse();
  }

  /// Creates a new lazy Iterable with all elements that satisfy the predicate [test].
  ///
  /// The matching elements have the same order in the returned iterable as they have in iterator.
  ///
  /// This method returns a view of the mapped elements modified by [toElement].
  Iterable<E> mapWhere(
    bool Function(E element) test, {
    required E Function(E e) toElement,
  }) sync* {
    for (var value in this) {
      if (test(value)) {
        yield toElement(value);
        continue;
      }
      yield toElement(value);
    }
  }
}
