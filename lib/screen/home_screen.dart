import 'package:flutter/material.dart';
import 'package:fluttoio/screen/test_screen.dart';
import 'package:fluttoio/screen/radio_controller_screen.dart';
import 'package:fluttoio/screen/toioekaki_screen.dart';
import 'package:fluttoio/screen/toio_line_controller.dart';
import 'package:fluttoio/screen/parametric_curve_screen.dart';

class HomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("FLUTTOIO")
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Container(
                  height: 50,
                  width: 300,
                  child: RaisedButton(
                    child: Text("TOIO接続"),
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TestScreen();
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                height: 50,
                width: 300,
                child: RaisedButton(
                  child: Text("ラジコン"),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RadioControllerScreen();
                      }),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                height: 50,
                width: 300,
                child: RaisedButton(
                  child: Text("おえかき"),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ToiOekakiScreen();
                      }),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                height: 50,
                width: 300,
                child: RaisedButton(
                  child: Text("ラインコントロール"),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ToioLineControllerScreen();
                      }),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                height: 50,
                width: 300,
                child: RaisedButton(
                  child: Text("曲線コントローラー"),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ParametricCurveScreen();
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
}

