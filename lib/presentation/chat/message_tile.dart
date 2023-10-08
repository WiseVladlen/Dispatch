import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/utils/date_utils.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.isSentByMe,
    required this.message,
  });

  final ShortMessageModel message;
  final bool isSentByMe;

  @override
  Widget build(BuildContext context) {
    final double leftContainerPadding = isSentByMe ? 12 : 6;
    final double rightContainerPadding = isSentByMe ? 6 : 12;

    final double leftContainerMargin = isSentByMe ? 72 : 8;
    const double topContainerMargin = 4;
    final double rightContainerMargin = isSentByMe ? 8 : 72;
    const double bottomContainerMargin = 4;

    final containerAlignment = isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start;

    final double leftBorderRadius = isSentByMe ? 20 : 6;
    final double rightBorderRadius = isSentByMe ? 6 : 20;

    return Container(
      margin: EdgeInsets.only(
        left: leftContainerMargin,
        top: topContainerMargin,
        right: rightContainerMargin,
        bottom: bottomContainerMargin,
      ),
      child: Row(
        mainAxisAlignment: containerAlignment,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(leftContainerPadding, 6, rightContainerPadding, 6),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(leftBorderRadius),
                  right: Radius.circular(rightBorderRadius),
                ),
                border: Border.all(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(message.content.text)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.dispatchTime.toTimeOfDay(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (isSentByMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: switch (message.status) {
                            MessageStatus.sent => const Icon(Icons.access_time, size: 14),
                            MessageStatus.delivered => const Icon(
                                Icons.done,
                                size: 14,
                                color: Colors.blue,
                              ),
                            MessageStatus.read => const Icon(
                                Icons.done_all,
                                size: 14,
                                color: Colors.blue,
                              ),
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
