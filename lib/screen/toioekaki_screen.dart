import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttoio/toio/toio_read_sensor.dart';
import 'package:fluttoio/toio/toio_constant.dart';


class ToiOekakiScreen extends StatelessWidget {

  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  double opacity = 1.0;
  bool isDrawing = false;
  List<DrawingPoints> points = List();
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("トイオエカキ")),
      body: FutureBuilder<List<BluetoothDevice>> (
        future: FlutterBlue.instance.connectedDevices,
        builder: (c, snapshot) => _Toioekaki(snapshot.data),
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

  Widget _Toioekaki(List<BluetoothDevice> devices) {

    if(devices != null && devices.length != 0) {
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
          if(values.position != null) {
            if(isDrawing == false) {
              isDrawing = true;
            }
            print("x: ${values.position.centerCubeX}, y: ${values.position.centerCubeY}");
            var x = values.position.centerCubeX.toDouble() * 3;
            var y = values.position.centerCubeY.toDouble() * 3;
            points.add(DrawingPoints(
              points: Offset(x, y),
              paint: Paint()
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth
            )
            );
          } else {
            if (isDrawing == true) {
              isDrawing = false;
              points.add(null);
            }
          }

          if(values.standard != null) {
            switch(values.standard.standardValue) {
              case "0":
                strokeWidth = 3.0;
                break;
              case "1":
                strokeWidth = 6.0;
                break;
              case "2":
                strokeWidth = 9.0;
                break;
              case "6":
                selectedColor = Colors.red;
                break;
              case "7":
                selectedColor = Colors.green;
                break;
              case "8":
                selectedColor = Colors.blue;
                break;
              case "C":
                selectedColor = Colors.yellow;
                break;
              case "D":
                selectedColor = Colors.orange;
                break;
              case "E":
                selectedColor = Colors.black;
                break;
              case "I":
                selectedColor = Colors.white;
                break;
              case "O":
                points.clear();
                break;
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 70,
                color: Colors.white,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "selectedColors: ",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        color: selectedColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "strokeWidth: ${strokeWidth}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 912,
                height: 648,
                key: Key("drawingArea"),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 4),
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _Painter(pointsList: points),
                )
              ),
            ],
          );
        });
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
