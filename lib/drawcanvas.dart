import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'dart:typed_data';

import 'operation.dart';
import 'tool.dart';
import 'pencil.dart';


class DrawPainter extends ChangeNotifier implements CustomPainter {

  List<Operation> operations = List<Operation>();
  Function stateUpdated;
  Tool tool;

  DrawPainter() {
    tool = PencilTool(this, color: Color(0xff000000), width: 5);
  }

  void notify() {
    notifyListeners();
  }

  void clear() {
    operations.clear();
    notifyListeners();
  }

  void undo() {
    if ( operations.length > 0 ) {
      if ( operations.last.undo() ) {
        operations.removeLast();
      }
    }
    notifyListeners();
  }

  bool hitTest(Offset position) => null;

  Size _lastSize;

  @override
  void paint(Canvas canvas, Size size) {

    _lastSize = size;
    var rect = Offset.zero & size;
    Paint fillPaint = new Paint();
    fillPaint.color = Color(0xffffffff);
    fillPaint.style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    for ( Operation operation in operations) {
      operation.paint(canvas, size);
    }

  }

  Future<ByteData> toByteData() {
    final recorder = new PictureRecorder();
    final Canvas canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0,0.0), Offset(_lastSize.width, _lastSize.height)));
    paint(canvas, _lastSize);
    final picture = recorder.endRecording();
    final img = picture.toImage(_lastSize.width.toInt(), _lastSize.height.toInt());
    return img.toByteData(format: ImageByteFormat.png);
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // TODO: implement semanticsBuilder
  @override
  SemanticsBuilderCallback get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return false;
  }
}


class DrawCanvasWidget extends StatefulWidget {

  final DrawPainter _painter;
  DrawCanvasWidget(this._painter, {Key key}) : super(key: key);

  @override
  DrawCanvasWidgetState createState() {
    return DrawCanvasWidgetState(_painter);
  }

}

class DrawCanvasWidgetState extends State<DrawCanvasWidget> {
  static DrawCanvasWidgetState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<DrawCanvasWidgetState>());

  final DrawPainter _painter;

  DrawCanvasWidgetState(this._painter);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect( child: CustomPaint(
      painter: _painter,
      child: GestureDetector(
        onPanStart: (DragStartDetails details) {
          RenderBox getBox = context.findRenderObject();
          _painter.tool.onPanStart(details, getBox.globalToLocal(details.globalPosition));
        },
        onPanUpdate: (DragUpdateDetails details) {
          RenderBox getBox = context.findRenderObject();
          _painter.tool.onPanUpdate(details, getBox.globalToLocal(details.globalPosition));
        },
        onPanEnd: _painter.tool.onPanEnd,

      )
    )
    );
  }

}
