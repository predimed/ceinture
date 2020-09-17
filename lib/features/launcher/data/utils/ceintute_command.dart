import 'dart:math';

import 'package:ceinture/core/utils/date_utils.dart';
import 'package:ceinture/core/utils/function_utils.dart';

// service  0000fff0-0000-1000-8000-00805f9b34fb

// car 0000fff6-0000-1000-8000-00805f9b34fb

class CeintureCommand {
  static const int CMD_GET_SERVER_IP_ADDRESS=0x10;
  static const int CMD_SET_DEVICE_NAME =0x3D;
  static const int CMD_GET_DEVICE_NAME =0x3E ;
  static const int CMD_SET_WIFI_NAME = 0x06;
  static const int CMD_GET_WIFI_NAME = 0x18;

  static const int CMD_SET_WIFI_PASSWORD = 0x07;
  static const int CMD_SET_SERVER_IP_ADDRESS = 0x09;
  static const int CMD_SET_SERVER_PORT = 0x0a;
  static const int CMD_GET_DATA = 0x43;
  static const int CMD_GET_TIME = 0x41;
  static const int CMD_VIBRATE = 0x36;
  static const int CMD_SET_TIME = 0x01;
  static const int CMD_GET_CONNECTION_STATUS = 0x18;
  static const int CMD_SET_TIME_FORMAT = 0x37;
  static const int CMD_REAL_TIME = 0x11;


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
    print('la conversion de char======================== ========= ${command}');

    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }
  static List<int> getWifiName() {
    List<int> command = [
      CMD_GET_WIFI_NAME,
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

  static List<int> getConnectionStatus() {
    List<int> command = [
      CMD_GET_CONNECTION_STATUS,
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


  static List<int> setWifiNameLessThan14(String name) {
    List<int> command = [];
    command.add(CMD_SET_WIFI_NAME);
    int cpt=14;
    for (int i = 0; i < name.length; i++) {
      print('la conversion de char======================== ${name[i]}========= ${name.codeUnitAt(i)}');
      command.add((name.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-name.length); i++) {
      command.add(0);
    }
    command.add(FunctionUtils.getChecksum(command, 15));
    //command.add(FunctionUtils.representIntInHex(71));
    return command;
  }


  static List<int> setWifiPassword(String name) {
    List<int> command = [];
    command.add(CMD_SET_WIFI_PASSWORD);

    for (int i = 0; i < name.length; i++) {
      command.add((name.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-name.length); i++) {
      command.add(0);
    }
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setDeviceName(String name) {
    List<int> command = [];
    command.add(CMD_SET_DEVICE_NAME);

    for (int i = 0; i < name.length; i++) {
      command.add((name.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-name.length); i++) {
      command.add(0);
    }
    command.add(FunctionUtils.getChecksum(command, 15));
    return command;
  }


  static List<int> setWifiNameGreatThan14s(String name) {
    List<int> command = [];
    //
    command.add(CMD_SET_WIFI_NAME);
    command.add(00);
    command.add(FunctionUtils.representIntInHex(name.length));
    int cpt=14;
    for (int i = 0; i < cpt; i++) {
      command.add(FunctionUtils.representIntInHex(name.codeUnitAt(i)));
    }
    //
    command.add(FunctionUtils.getChecksum(command, 17));

    //
    List<int> command2 = [];
    //
    command2.add(CMD_SET_WIFI_NAME);
    command2.add(01);
    command2.add(FunctionUtils.representIntInHex(name.length));
    for (int i = 14; i < (name.length); i++) {
      command2.add(FunctionUtils.representIntInHex(name.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-(name.length-14)); i++) {
      command2.add(0);
    }
    command2.add(FunctionUtils.getChecksum(command, 17));

    //
    command.addAll(command2);
    return command;
  }


  static List<List<int>> setWifiNameGreatThan14(String name) {
    List<List<int>> commandFinal = [];
    List<int> command = [];
    //
    command.add(CMD_SET_WIFI_NAME);
    command.add(00);
    command.add(FunctionUtils.representIntInHex(name.length));
    int cpt=14;
    for (int i = 0; i < cpt; i++) {
      command.add(FunctionUtils.representIntInHex(name.codeUnitAt(i)));
    }
    //
    command.add(FunctionUtils.getChecksum(command, 17));

    //
    List<int> command2 = [];
    //
    command2.add(CMD_SET_WIFI_NAME);
    command2.add(01);
    command2.add(FunctionUtils.representIntInHex(name.length));
    for (int i = 14; i < (name.length); i++) {
      command2.add(FunctionUtils.representIntInHex(name.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-(name.length-14)); i++) {
      command2.add(0);
    }
    command2.add(FunctionUtils.getChecksum(command, 17));

    //
    commandFinal.add(command);
    commandFinal.add(command2);
    return commandFinal;
  }


  /**
   * bon a savoir
   */
  //https://www.scadacore.com/tools/programming-calculators/online-checksum-calculator/
  static List<int> setServerIpAdress(String ipAdress) {
    List<int> command = [];
    command.add(CMD_SET_SERVER_IP_ADDRESS);
    int cpt=14;
    for (int i = 0; i < ipAdress.length; i++) {
      command.add((ipAdress.codeUnitAt(i)));
    }
    //
    for (int i = 0; i < (14-ipAdress.length); i++) {
      command.add(00);
    }
    command.add((0x100)-FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> setServerPort(String port) {
    List<int> command = [];
    command.add(CMD_SET_SERVER_PORT);
    command.add(port.length);
    int cpt=13;
    for (int i = 0; i < port.length; i++) {
      command.add((int.parse(port[i])));
    }
    //
    for (int i = 0; i < (13-port.length); i++) {
      command.add(00);
    }
    command.add((0x100)-FunctionUtils.getChecksum(command, 15));
    return command;
  }

  static List<int> getServerIpAddress() {
    List<int> command = [
      CMD_GET_SERVER_IP_ADDRESS,
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
      CMD_REAL_TIME,
      FunctionUtils.representIntInHex(0),
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
}
