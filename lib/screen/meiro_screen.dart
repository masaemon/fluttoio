import 'package:flutter/material.dart';
import 'package:fluttoio/parametric_curve/parametric_curve.dart';
import 'package:fluttoio/toio/toio_motor.dart';
import 'package:fluttoio/toio/toio_read_sensor.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:vector_math/vector_math.dart' as vector_math;

class MeiroScreen extends StatelessWidget {

  List<DrawingPoints> points = List();
  int a = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("曲線コントローラー")),
      body: FutureBuilder<List<BluetoothDevice>> (
        future: FlutterBlue.instance.connectedDevices,
        builder: (c, snapshot) => _Meiro(snapshot.data),
      ),
    );
  }

  Future<BluetoothCharacteristic> _getMotorService(BluetoothDevice device) async {
    if (device != null) {
      List<BluetoothService> toioServices = await device.discoverServices();
      List<BluetoothCharacteristic> toioCharacteristic = toioServices[0].characteristics;
      return toioCharacteristic[1];
    }

    return null;
  }

  Future<BluetoothCharacteristic> _getReadSensorService(BluetoothDevice device) async {
    if (device != null) {
      List<BluetoothService> toioServices = await device.discoverServices();
      List<BluetoothCharacteristic> toioCharacteristic = toioServices[0].characteristics;
      return toioCharacteristic[0];
    }

    return null;
  }

  Future<void> _drawCycroid(List<BluetoothDevice> devices) async {
  }

  Widget _Meiro(List<BluetoothDevice> devices) {
    if(devices != null && devices.length != 0) {
      return Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("迷路"),
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      await _drawCycroid(devices);
                    },
                  ),
                ],
              )
            )
          ),
          Container(
            width: 912,
            height: 648,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 4),
            ),
            child: StreamBuilder<List<DrawingPoints>>(
              stream: Stream.periodic(Duration(milliseconds: 10)).asyncMap((_) => points),
              initialData: [],
              builder: (c, snapshot) => CustomPaint(
                size: Size.infinite,
                painter: _Painter(pointsList: points),
              ),
            ),
          ),
        ],
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

