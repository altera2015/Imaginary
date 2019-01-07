import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'operation.dart';
import 'tool.dart';
import 'drawcanvas.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';

import 'width_picker.dart';
import 'color_picker.dart';

class PencilOperation implements Operation {

  List<List<Offset>> _paths;
  final Paint _paint;

  PencilOperation._internal(this._paint) {
    _paths = List<List<Offset>>();
  }

  bool matches( Color color, int width ) {
    return _paint.color == color && _paint.strokeWidth.toInt() == width;
  }

  factory PencilOperation(Color color, int width) {
    Paint strokePaint = new Paint();
    strokePaint.color = color;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeWidth = width.toDouble();
    strokePaint.strokeCap = StrokeCap.round;
    return PencilOperation._internal(strokePaint);
  }

  void start(Offset position) {
    _paths.add([position]);
  }

  void add(Offset position) {
    _paths.last.add(position);
  }

  void paint(Canvas canvas, Size size) {
    for (var path in _paths) {
      Path strokePath = new Path();
      strokePath.addPolygon(path, false);
      canvas.drawPath(strokePath, _paint);
    }
  }

  bool undo() {
    _paths.removeLast();
    return _paths.length == 0;
  }
}


class PencilTool implements Tool {
  DrawPainter _painter;
  Color color;
  int width;
  Function floatActionButtonStateChanged;

  PencilTool(this._painter, {this.color, this.width});

  void _pickWidth(BuildContext context) async {
    int w = await WidthPickerPopup.getWidth(context, width);
    if ( w != null ) {
      width = w;
    }
  }

  void _pickColor(BuildContext context) async {
    Color c = await ColorPickerPopup.getColor(context, color);
    if ( c != null ) {
      color = c;
      if ( floatActionButtonStateChanged !=null ) {
        floatActionButtonStateChanged();
      }
    }
  }

  PencilOperation _getCurrent() {

    if (_painter.operations.length > 0) {
      Operation op = _painter.operations.last;
      if (op is PencilOperation) {
        PencilOperation pop = op;
        if ( pop.matches(color, width)) {
          return op;
        }
      }
    }

    Operation operation = PencilOperation(color, width);
    _painter.operations.add(operation);
    return operation;
  }

  void selected() {
  }

  Widget floatingActionButton(BuildContext context) {

    HSLColor c = HSLColor.fromColor(color);
    double h = c.hue + 180.0;
    if ( h>360.0 ) {
      h -= 360.0;
    }
    double l = c.lightness;
    if ( l > .75 ) {
      l = 0.25;
    } else if ( l < 0.25 ) {
      l = 1 - l;
    }
    double s = c.saturation;
    if ( s < 0.25 ) {
      s = 1 - s;
    }

    HSLColor c2 = HSLColor.fromAHSL(1.0, h, s, l);

    // print("$color, ${c2.toColor()}, $c");

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      // onOpen: () => print('OPENING DIAL'),
      // onClose: () => print('DIAL CLOSED'),
      // tooltip: 'Speed Dial',
      // heroTag: 'speed-dial-hero-tag',
      foregroundColor: c2.toColor(),
      backgroundColor: color,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.color_lens),
          foregroundColor: c2.toColor(),
          backgroundColor: color,
          label: 'Color Picker',
          onTap: (){
            _pickColor(context);
          }
        ) ,
        SpeedDialChild(
          child: Icon(Icons.brush),
          foregroundColor: c2.toColor(),
          backgroundColor: color,
          label: 'Brush Size',
          onTap: () {
            _pickWidth(context);
          },
        ),
      ],
    );
  }

  void onPanStart(DragStartDetails details, Offset local) {
    _getCurrent().start(local);
    _painter.notify();
  }

  void onPanUpdate(DragUpdateDetails details, Offset local) {
    _getCurrent().add(local);
    _painter.notify();
  }

  void onPanEnd(DragEndDetails details) {
  }

}
