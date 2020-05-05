import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttoio/toio/toio_constant.dart';
import 'package:fluttoio/toio/toio_read_sensor.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("テスト画面")),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) {
                if (snapshot.data.where((data) => data.device.name == TOIO_NAME).length == 0) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Toio Device",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data.where((data) =>
                    data.device.name == TOIO_NAME).map((r) =>
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              r.device.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            StreamBuilder<List<BluetoothService>>(
                              stream:  Stream.periodic(Duration(seconds: 2)).asyncMap((_) => r.device.discoverServices()),
                              initialData: [],
                              builder: (c, snapshot) {
                                if(snapshot.data != null && snapshot.data.length != 0) {
                                  var toioData = snapshot.data.firstWhere((
                                    element) =>
                                  element.deviceId == r.device.id);
                                  if (toioData != null) {
                                    return RaisedButton(
                                      child: Text("情報取得"),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.0),
                                      ),
                                      onPressed: () async {
                                        var data = await toioData
                                          .characteristics[0].read();
                                        ToioReadSensor sensor = new ToioReadSensor();
                                        print(sensor.getValuesString(data));
                                      },
                                    );
                                  }
                                }
                                return Text("");
                              },
                            ),
                            StreamBuilder<List<int>>(
                              stream: Stream.periodic(Duration(milliseconds: 50)).asyncMap((_) {
                                var services = r.device.discoverServices();
                                var toioData = services.then((value) => value.firstWhere((element) => element.deviceId == r.device.id));
                                return toioData.then((value) {
                                  return value.characteristics[0].read();
                                });
                              }),
                              initialData: [],
                              builder: (c, snapshot){
                                if(snapshot.data != null) {
                                  ToioReadSensor sensor = new ToioReadSensor();
                                  return Text(
                                    sensor.getValuesString(snapshot.data),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  );
                                } else {
                                  return Text("");
                                }
                              }
                            ),
                            StreamBuilder<bool>(
                              stream: Stream.periodic(Duration(seconds: 2)).asyncMap((_) async {
                                var ret = false;
                                var ids = FlutterBlue.instance.connectedDevices.then((value) => value.map((e) => e.id));
                                await ids.then((value) {
                                   ret = value.contains(r.device.id) ? true : false;
                                });
                                return ret;
                              }),
                              initialData: false,
                              builder: (c, snapshot) {
                                if (snapshot.data == false) {
                                  return RaisedButton(
                                    child: Text("接続"),
                                    color: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () => r.device.connect()

                                  );
                                }else {

                                  return RaisedButton(
                                    child: Text("接続解除"),
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () => r.device.disconnect(),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                      )
                    ).toList()
                  );
                }
              }
            ),
            StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data) {
                    return GestureDetector(
                        onTap: () => FlutterBlue.instance.stopScan(),
                        child: Container(
                          child: Center(
                            child: Text(
                              "検索を止める",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          color: Colors.pink,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.only(bottom: 20.0),
                          width: double.infinity,
                          height: 100,
                        ));
                  } else {
                    return GestureDetector(
                        onTap: () => FlutterBlue.instance
                            .startScan(timeout: Duration(seconds: 4)),
                        child: Container(
                          child: Center(
                            child: Text(
                              "検索を始める",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          color: Colors.orange,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.only(bottom: 20.0),
                          width: double.infinity,
                          height: 100,
                        ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
