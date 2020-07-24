import 'dart:math';

import 'package:ceinture/core/utils/date_utils.dart';
import 'package:ceinture/core/utils/function_utils.dart';

// service  0000fff0-0000-1000-8000-00805f9b34fb

// car 0000fff6-0000-1000-8000-00805f9b34fb

class CeintureCommand {
  static final int CMD_GET_BATTERY_LEVEL = 0x13;
  static final int CMD_GET_DATA = 0x43;
  static final int CMD_GET_ACTIVITY = 0x26;
  static final int CMD_GET_ALARM = 0x24;
  static final int CMD_GET_SLEEP_RANGE = 0x5C;
  static final int CMD_GET_SLEEP_MODE_BY_PRESS = 0x5E;
  static final int CMD_GET_TIME = 0x41;
  static final int CMD_GET_TOTAL_ACTIVITY = 0x07;
  static final int CMD_VIBRATE = 0x36;
  static final int CMD_SET_ACTIVITY = 0x25;
  static final int CMD_SET_ALARM = 0x23;
  static final int CMD_SET_FOOTSTEP_GOAL = 0x0B;
  static final int CMD_SET_PERSONAL_DATA = 0x2;
  static final int CMD_SET_SLEEP_RANGE = 0x5B;
  static final int CMD_SET_SLEEP_MODE_BY_PRESS = 0x5D;
  static final int CMD_SET_TIME = 0x1;
  static final int CMD_SET_TIME_FORMAT = 0x37;
  static final int CMD_SET_UNIT_DISTANCE = 0x0F;
  static final int CMD_START_REAL_TIME = 0x09;
  static final int CMD_STOP_REAL_TIME = 0x0A;
  static final int UNIT_KM = 0;
  static final int UNIT_ML = 1;
  static final int FORMAT_12H = 0;
  static final int FORMAT_24H = 1;
  static final int GENDER_FEMALE = 0;
  static final int GENDER_MALE = 1;

  static List<int> getData(int day) {
    List<int> command = [
      CMD_GET_DATA,
      FunctionUtils.representIntInHex(day),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setUnitDistance(int unit) {
    List<int> command = [
      CMD_SET_UNIT_DISTANCE,
      FunctionUtils.representIntInHex(unit),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> getTime() {
    List<int> command = [
      CMD_GET_TIME,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> startRealTime() {
    List<int> command = [
      CMD_START_REAL_TIME,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> stopRealTime() {
    List<int> command = [
      CMD_STOP_REAL_TIME,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setTime() {
    var date = DateUtils.convertStringFromDate(
        dateTime: DateTime.now().millisecondsSinceEpoch,
        pattern: "yy/MM/dd/HH/mm/ss");
    var dateTab = date.split('/');
    List<int> command = [
      CMD_SET_TIME,
      FunctionUtils.representStringInHex(dateTab[0]),
      FunctionUtils.representStringInHex(dateTab[1]),
      FunctionUtils.representStringInHex(dateTab[2]),
      FunctionUtils.representStringInHex(dateTab[3]),
      FunctionUtils.representStringInHex(dateTab[4]),
      FunctionUtils.representStringInHex(dateTab[5]),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> vibrate() {
    List<int> command = [
      CMD_VIBRATE,
      FunctionUtils.representIntInHex(07),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> getBatteryLevel() {
    List<int> command = [
      CMD_GET_BATTERY_LEVEL,
      FunctionUtils.representIntInHex(07),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setFootstepGoal(int goal) {
    int goal_byte1_high = (goal / (256 * 256)).toInt();
    int goal_byte2_med = ((goal / 256) % 256).toInt();
    int goal_byte3_low = (goal % 256).toInt();

    List<int> command = [
      CMD_SET_FOOTSTEP_GOAL,
      FunctionUtils.representIntInHex(goal_byte1_high),
      FunctionUtils.representIntInHex(goal_byte2_med),
      FunctionUtils.representIntInHex(goal_byte3_low),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setPersonalData(
      int age, int height, int weight, int footstepWidth) {
    List<int> command = [
      CMD_SET_PERSONAL_DATA,
      FunctionUtils.representIntInHex(0),
      FunctionUtils.representIntInHex(age),
      FunctionUtils.representIntInHex(height),
      FunctionUtils.representIntInHex(weight),
      FunctionUtils.representIntInHex(footstepWidth),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setSleepModeByPress(bool enable) {
    List<int> command = [
      CMD_SET_SLEEP_MODE_BY_PRESS,
      FunctionUtils.representIntInHex((enable ? 1 : 0)),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setSleepPeriod(
      int startHour, int startMinute, int endHour, int endMinute) {
    List<int> command = [
      CMD_SET_SLEEP_RANGE,
      FunctionUtils.representIntInHex(startHour),
      FunctionUtils.representIntInHex(startMinute),
      FunctionUtils.representIntInHex(endHour),
      FunctionUtils.representIntInHex(endMinute),
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }
}
