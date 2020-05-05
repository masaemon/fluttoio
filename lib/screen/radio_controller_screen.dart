import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttoio/toio/toio_constant.dart';
import 'package:fluttoio/toio/toio_motor.dart';

class RadioControllerScreen extends StatefulWidget {
  @override
  _RadioControllerScreenState createState() => _RadioControllerScreenState();
}

class _RadioControllerScreenState extends State<RadioControllerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ラジコン")),
      body: FutureBuilder<List<BluetoothDevice>> (
        future: FlutterBlue.instance.connectedDevices,
        builder: (c, snapshot) => _RadioControl(snapshot.data),
      )
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


  Widget _RadioControl(List<BluetoothDevice> devices) {
    if(devices != null && devices.length != 0) {
      var toioDevice = devices[0];
      var toioMotor = new ToioMotor();
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "ボタンを押すと動くよ",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () async {
              BluetoothCharacteristic motor = await _getMotorService(toioDevice);
              toioMotor.MotorForward(motor);
            },
            child: Container(
              width: 300,
              height: 70,
              color: Colors.orange,
                child: Center(
                  child: Text(
                    "うえ",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  BluetoothCharacteristic motor = await _getMotorService(toioDevice);
                  toioMotor.MotorLeft(motor);
                },
                child: Container(
                  width: 300,
                  height: 70,
                  color: Colors.orange,
                  child: Center(
                    child: Text(
                      "ひだり",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  BluetoothCharacteristic motor = await _getMotorService(toioDevice);
                  toioMotor.MotorRight(motor);
                },
                child: Container(
                  width: 300,
                  height: 70,
                  color: Colors.orange,
                  child: Center(
                    child: Text(
                      "みぎ",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              BluetoothCharacteristic motor = await _getMotorService(toioDevice);
              toioMotor.MotorBack(motor);
            },
            child: Container(
              width: 300,
              height: 70,
              color: Colors.orange,
              child: Center(
                child: Text(
                  "した",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
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
