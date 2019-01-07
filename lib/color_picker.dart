import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ColorPickerPopup extends StatefulWidget {

  final Color color;

  ColorPickerPopup(this.color, {Key key}) : super(key: key);

  static Future<Color> getColor(BuildContext context, Color color) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ColorPickerPopup(color);
        }
    );
  }

  @override
  ColorPickerState createState() {
    return ColorPickerState(color);
  }

}

class ColorPickerState extends State<ColorPickerPopup> {

  Color color;

  ColorPickerState(this.color);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: color,
          onColorChanged: (Color c) {
            color = c;
          },
          enableLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),

      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Got it'),
          onPressed: () {
            Navigator.of(context).pop(color);
          },
        ),
      ],
    );
  }

}
