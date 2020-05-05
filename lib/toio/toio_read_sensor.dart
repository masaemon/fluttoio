import 'dart:math';
import 'package:fluttoio/toio/toio_constant.dart';

class ToioReadSensor {

  String getValuesString(List<int> values) {
    switch(values[0]) {
      case 1:
        return this.PositionAnglesString(values);
      case 2:
        return this.UniqueValuesString(values);
      case 3:
        return "読み取れませんでした";
      case 4:
        return "読み取れませんでした";
      default:
        return "読み取れませんでした";
    }
  }


  ToioReadSensorValues getValues(List<int> values) {
    ToioReadSensorPosition position;
    ToioReadSensorStandard standard;

    switch(values[0]) {
      case 1:
        position = getPosition(values);
        break;
      case 2:
        standard = getStandardValue(values);
        break;
      default:
        break;
    }

    return ToioReadSensorValues(
      position: position,
      standard: standard
    );

  }

  ToioReadSensorPosition getPosition (List<int> values) {
    int centerCubeX = values[2] * pow(2, 8) + values[1];
    int centerCubeY = values[4] * pow(2, 8) + values[3];
    int angles = values[6] * pow(2, 8) + values[5];
    int sensorCubeX = values[8] * pow(2, 8) + values[7];
    int sensorCubeY = values[10] * pow(2, 8) + values[9];
    int sensorAngles = values[12] * pow(2, 8) + values[11];
    return ToioReadSensorPosition(
      centerCubeX: centerCubeX - 98,
      centerCubeY: centerCubeY - 142,
      cubeAngle: angles,
      sensorCubeX: sensorCubeX - 98,
      sensorCubeY: sensorCubeY - 142,
      sensorCubeAngle: sensorAngles
    );
  }

  ToioReadSensorStandard getStandardValue (List<int> values) {
    int sensorID = values[4] * pow(2, 8*3) + values[3] * pow(2, 8*2) + values[2] * pow(2, 8) + values[1];
    int angles = values[6] * pow(2, 8) + values[5];
    String uniqueStandardID = STANDARDID[sensorID.toString()];
    return ToioReadSensorStandard(
      standardID: sensorID,
      angles: angles,
      standardValue: uniqueStandardID
    );
  }

  String PositionAnglesString(List<int> values) {
    int cubeX = values[2] * pow(2, 8) + values[1];
    int cubeY = values[4] * pow(2, 8) + values[3];
    int angles = values[6] * pow(2, 8) + values[5];
    return "X: ${cubeX.toString()}, Y: ${cubeY.toString()}, cubeAngles: ${angles.toString()}";
  }

  String UniqueValuesString(List<int> values) {
    int sensorID = values[4] * pow(2, 8*3) + values[3] * pow(2, 8*2) + values[2] * pow(2, 8) + values[1];
    int angles = values[6] * pow(2, 8) + values[5];
    String uniqueStandardID = STANDARDID[sensorID.toString()];
    return "StandardID: ${uniqueStandardID}, cubeAngles: ${angles.toString()}";
  }
}

class ToioReadSensorValues {
  ToioReadSensorPosition position;
  ToioReadSensorStandard standard;
  ToioReadSensorValues({
    this.standard,
    this.position
  });
}

class ToioReadSensorPosition {
  int centerCubeX;
  int centerCubeY;
  int cubeAngle;
  int sensorCubeX;
  int sensorCubeY;
  int sensorCubeAngle;
  ToioReadSensorPosition({
    this.centerCubeX,
    this.centerCubeY,
    this.cubeAngle,
    this.sensorCubeX,
    this.sensorCubeY,
    this.sensorCubeAngle
  });
}

class ToioReadSensorStandard {
  int standardID;
  String standardValue;
  int angles;
  ToioReadSensorStandard({
    this.standardID,
    this.standardValue,
    this.angles
  });
}
