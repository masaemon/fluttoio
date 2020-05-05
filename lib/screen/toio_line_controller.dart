import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttoio/toio/toio_read_sensor.dart';
import 'package:fluttoio/toio/toio_motor.dart';

class ToioLineControllerScreen extends StatefulWidget {
  @override
  _ToioLineControllerScreenState createState() => _ToioLineControllerScreenState();
}

class _ToioLineControllerScreenState extends State<ToioLineControllerScreen> {

  int toioX = 30;
  int toioY = 30;
  bool isToioStartLines = false;
  bool isOnToioMat = false;
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  double opacity = 1.0;
  List<DrawingPoints> points = List();
  List<_ToioPosition> toioPositions = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("といおらいんじぇすちゃーこんとろーらー")),
      body: FutureBuilder<List<BluetoothDevice>> (
        future: FlutterBlue.instance.connectedDevices,
        builder: (c, snapshot) => _ToioLineController(snapshot.data),
      ),
    );
  }

  Future<BluetoothCharacteristic> _getReadSensorService(BluetoothDevice device) async {
    if (device != null) {
      List<BluetoothService> toioServices = await device.discoverServices();
      List<BluetoothCharacteristic> toioCharacteristic = toioServices[0].characteristics;
      return toioCharacteristic[0];
    }

    return null;
  }

  Widget _ToioLineController(List<BluetoothDevice> devices) {

    if (devices != null && devices.length != 0) {
      var toioDevice = devices[0];

      return StreamBuilder<List<int>>(
        stream: Stream.periodic(Duration(milliseconds: 2)).asyncMap((_) async {
          var readSensor = await _getReadSensorService(toioDevice);
          var readValue = await readSensor.read();
          return readValue != null ? readValue : [255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        }),
        initialData: [255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        builder: (context, snapshot) {
          ToioReadSensor readSensor = new ToioReadSensor();
          ToioReadSensorValues values = readSensor.getValues(snapshot.data);

          if (values.position != null) {
            print(values.position.centerCubeX);
            print(values.position.centerCubeY);
            if (this.isOnToioMat == false) {

            }
          }

          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 70,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("クリア"),
                      color: Colors.orange,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        points.clear();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 912,
                height: 648,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 4),
                ),
                child: GestureDetector(
                  onPanStart: (details) {
                    RenderBox renderBox = context.findRenderObject();
                    points.add(DrawingPoints(
                      points: details.localPosition,
                      paint: Paint()
                        ..isAntiAlias = true
                        ..color = selectedColor.withOpacity(opacity)
                        ..strokeWidth = strokeWidth
                    ));
                  },
                  onPanUpdate: (details) {
                    RenderBox renderBox = context.findRenderObject();
                    print(details.localPosition);
                    if (0 <= details.localPosition.dx && details.localPosition.dx <= 908 &&
                        0 <= details.localPosition.dy && details.localPosition.dy <= 644) {
                      toioPositions.add(_ToioPosition(x: (details.localPosition.dx~/3).toInt(), y: (details.localPosition.dy~/3).toInt()));
                      points.add(DrawingPoints(
                        points: details.localPosition,
                        paint: Paint()
                          ..isAntiAlias = true
                          ..color = selectedColor.withOpacity(opacity)
                          ..strokeWidth = strokeWidth
                      ));
                    }
                  },
                  onPanEnd: (details) async {
                    points.add(null);

                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _Painter(pointsList: points),
                  ),
                ),
              ),
            ],
          );
        }
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Not Connect Toio Device",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
  }
}

class _ToioPosition {
  int x;
  int y;
  _ToioPosition({this.x, this.y});
}

class _Painter extends CustomPainter {

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  _Painter({ this.pointsList });

  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i < pointsList.length-1; i++) {
      if (pointsList[i] != null && pointsList[i+1] != null) {
        canvas.drawLine(
          pointsList[i].points,
          pointsList[i+1].points,
          pointsList[i].paint
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(Offset(pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => true;

}


class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}
