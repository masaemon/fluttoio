import 'package:fluttoio/toio/toio_constant.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ToioMotor {
  void MotorForward(BluetoothCharacteristic motor) async {
    List<int> motorOrder = [1, 1, 1, 20, 2, 1, 20];
    await motor.write(motorOrder, withoutResponse: true);
  }

  void MotorBack(BluetoothCharacteristic motor) async {
    List<int> motorOrder = [1, 1, 2, 20, 2, 2, 20];
    await motor.write(motorOrder, withoutResponse: true);
  }

  void MotorLeft(BluetoothCharacteristic motor) async {
    List<int> motorOrder = [1, 1, 2, 20, 2, 1, 20];
    await motor.write(motorOrder, withoutResponse: true);
  }

  void MotorRight(BluetoothCharacteristic motor) async {
    List<int> motorOrder = [1, 1, 1, 20, 2, 2, 20];
    await motor.write(motorOrder, withoutResponse: true);
  }

  Future<void> ToioPositionMoveMoter(BluetoothCharacteristic motor, int x, int y) async {
    int x0 = x & 0xff;
    int x1 = x >> 8;
    int y0 = y & 0xff;
    int y1 = y >> 8;
    List<int> motorOrder = [3, 0, 3, 0, 80, 0, 0, x0, x1, y0, y1, 0, 160];
    await motor.write(motorOrder, withoutResponse: true);
  }

  Future<void> ToioSomePositionMoveMoter(BluetoothCharacteristic motor, List<int> data) async {
    List<int> motorOrder = [4, 0, 20, 0, 50, 0, 0, 1];
    motorOrder.addAll(data);
    await motor.write(motorOrder, withoutResponse: true);
  }

  Future<void> SendRowMoter(BluetoothCharacteristic motor, List<int> data) async {
    await motor.write(data, withoutResponse: true);
  }

  Future<bool> ToioMotorMoveFinished(BluetoothCharacteristic motor) async {
    await motor.setNotifyValue(true);
    bool ret = false;
    motor.value.listen((value) {
      if (value != null && value[0] == 131 && (value[2] == 0 || value[2] == 2)) ret = true;
      else ret = false;
      print(value);
    });

    return ret;
  }
}
