import 'package:flutter/widgets.dart';

abstract class Tool {
  Function floatActionButtonStateChanged;
  void selected();
  Widget floatingActionButton(BuildContext context);
  void onPanStart(DragStartDetails details, Offset local);
  void onPanUpdate(DragUpdateDetails details, Offset local);
  void onPanEnd(DragEndDetails details);
}

