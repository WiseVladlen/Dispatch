import 'package:flutter/material.dart';

extension ConnectionStateExtension on ConnectionState {
  bool get isNone => this == ConnectionState.none;
  bool get isDone => this == ConnectionState.done;
}
