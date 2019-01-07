import 'package:flutter/material.dart';


class WidthPickerPopup extends StatefulWidget {

  final int width;

  WidthPickerPopup(this.width, {Key key}) : super(key: key);

  static Future<int> getWidth(BuildContext context, int width) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WidthPickerPopup(width);
      }
    );
  }

  @override
  WidthPickerState createState() {
    return WidthPickerState(width);
  }

}

class WidthPickerState extends State<WidthPickerPopup> {

  int width;

  WidthPickerState(this.width);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Pick a brush width"),
        content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Slider(
                    min: 1.0,
                    max: 50,
                    divisions: 50,
                    value: width.toDouble(),
                    onChanged: (double value) {
                      setState((){
                        width = value.toInt();
                      });
                    },
                  )
                ),
                Container(
                  width:50.0,
                  alignment: Alignment.center,
                  child:  Text(width.toString(), style: Theme.of(context).textTheme.display1),
                )
            ]
            )
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(width);
            },
          ),
        ]

    );
  }

}
