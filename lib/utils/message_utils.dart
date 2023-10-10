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
    for (int index = 0; index < length; index++) {
      element = this[index];
      if (element.sender.email == email) return orElse();
      if (element.sender.email != email && !element.status.isRead) {
        while (index > 0) {
          element = this[++index];
          if (element.status.isRead) return (index, element);
        }
      }
    }
    return orElse();
  }
}

extension MessageExtension<T extends ShortMessageModel> on T {
  bool dayEquals(T message) => dispatchTime.day == message.dispatchTime.day;

  int compareDateTo(T message) => dispatchTime.compareTo(message.dispatchTime);
}
