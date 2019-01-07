import 'package:flutter/painting.dart';

abstract class Operation {
  void paint(Canvas canvas, Size size);
  // return true when this Operation has no more
  // undo's available.
  bool undo();
}

