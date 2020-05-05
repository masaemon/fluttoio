import 'package:flutter/material.dart';
import 'package:fluttoio/screen/home_screen.dart';

void main() {
  runApp(Fluttoio());
}

class Fluttoio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }

}
