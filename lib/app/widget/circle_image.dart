import 'package:cached_network_image/cached_network_image.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:dispatch/utils/object_utils.dart';
import 'package:flutter/material.dart';

typedef LoadingErrorWidgetBuilder = Widget Function();

class CircleNetworkImage extends StatelessWidget {
  const CircleNetworkImage({
    super.key,
    required this.imagePath,
    required this.radius,
    this.errorWidget,
    this.placeholderColor,
  });

  final String imagePath;

  final double radius;

  final LoadingErrorWidgetBuilder? errorWidget;

  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imagePath,
        httpHeaders: HttpHeaders.baseHttpHeaders,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (_, __) => Container(
          decoration: BoxDecoration(
            color: placeholderColor,
            shape: BoxShape.circle,
          ),
        ),
        errorWidget: (_, __, ___) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: placeholderColor,
              shape: BoxShape.circle,
            ),
            width: radius * 2,
            height: radius * 2,
            child: errorWidget.safeLet((it) => it()),
          );
        },
      ),
    );
  }
}
