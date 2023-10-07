import 'package:dispatch/domain/model/message_model.dart';

extension MessageListExtension<E extends ShortMessageModel> on List<E> {
  /// Iterates through the elements in search of the first element with the status [MessageStatus.sent],
  /// that satisfies the parameter [email].
  ///
  /// Returns an entry in the format (index, element) if such an element is found,
  /// otherwise it returns the function [OrElse].
  (int index, E?) firstIndexedUnreadMessage({
    required String email,
    required (int index, E?) Function() orElse,
  }) {
    E element;
    for (int index = this.length - 1; index > 0; index--) {
      element = this[index];
      if (element.sender.email == email) return orElse();
      if (element.sender.email != email && !element.status.isRead) {
        while (index > 0) {
          element = this[--index];
          if (element.status.isRead) return (index, element);
        }
      }
    }
    return orElse();
  }

  /// Iterates through the elements in search of the first element with the status [MessageStatus.sent],
  /// that satisfies the parameters [email] and [content].
  ///
  /// If such an element is found, it is map according to the [toElement] function,
  /// otherwise the [orElse] function is executed.
  ///
  /// Returns a modified list.
  List<E> mapFirstSentMessage({
    required String email,
    required MessageContent content,
    required E Function(E e) toElement,
    required List<E> Function(List<E> list) orElse,
  }) {
    E element;
    for (int index = length - 1; index > 0; index--) {
      element = this[index];
      if (element.sender.email == email && element.status.isSent) {
        while (index > 0) {
          if (element.content == content) {
            toElement(element);
            return this;
          }
          element = this[--index];
        }
      }
    }
    return orElse(this);
  }
}
