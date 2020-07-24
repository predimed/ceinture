import 'package:ceinture/core/helpers/ble/ble_device_connector.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class CeintureSensorRepository {
  BleDeviceConnector _bleDeviceConnector;

  CeintureSensorRepository(this._bleDeviceConnector);

  Future<List<int>> executeCommand(String deviceId, List<int> command) async {

    List<int> finalData;
    //if (_bleDeviceConnector.connection != null) {
    if (1==1) {
      try {
        final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
            characteristicId:
                Uuid.parse("0000fff6-0000-1000-8000-00805f9b34fb"),
            deviceId: deviceId);
        await _bleDeviceConnector.ble
            .writeCharacteristicWithResponse(characteristic, value: command);
       // await Future.delayed(new Duration(milliseconds: 3000));

        final characteristicNoti = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
            characteristicId:
                Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
            deviceId: deviceId);

        await _bleDeviceConnector.ble
            .subscribeToCharacteristic(characteristicNoti)
            .listen((data) {
              //action to do
          actionTodoWithCommandReult(command, data);
        }, onError: (dynamic error) {
          print("Error chanfgement from a device: $error");
        });
      } on Exception catch (e, _) {
        print("Error writing from a device: $e");
      }
      return finalData;
    }else{
      print("connexion null");
    }
  }

  actionTodoWithCommandReult(List<int> command, List<int> data) {
    if (command[0] == CeintureCommand.CMD_VIBRATE) {
      print("command result vibrate ============================================");
    } else if (command[0] == CeintureCommand.CMD_GET_TIME) {
      print("command result get time");
    } else if (command[0] == CeintureCommand.CMD_GET_DATA) {
      print("command result");
    } else if (command[0] == CeintureCommand.CMD_SET_TIME) {
      print("command result set time");
    }
  }



  Future<List<int>> getTime(String deviceId) async {
    var x = await executeCommand(deviceId, CeintureCommand.getTime());
    //await Future.delayed(new Duration(milliseconds: 8000));
    final characteristicNoti = QualifiedCharacteristic(
        serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
        characteristicId: Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
        deviceId: deviceId);

    await _bleDeviceConnector.ble
        .subscribeToCharacteristic(characteristicNoti)
        .listen((data) {
      data.forEach((element) {
        print(
            "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
      });
    }, onError: (dynamic error) {
      print("Error chanfgement from a device: $error");
    });
  }

  Future<List<int>> setTime(String deviceId) async {
    var x = await executeCommand(deviceId, CeintureCommand.setTime());
    //await Future.delayed(new Duration(milliseconds: 3000));
    final characteristicNoti = QualifiedCharacteristic(
        serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
        characteristicId: Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
        deviceId: deviceId);

    await _bleDeviceConnector.ble
        .subscribeToCharacteristic(characteristicNoti)
        .listen((data) {
      data.forEach((element) {
        print(
            "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
      });
    }, onError: (dynamic error) {
      print("Error chanfgement from a device: $error");
    });
  }

  Future<List<int>> vibrate(String deviceId) async {
    var x = await executeCommand(deviceId, CeintureCommand.vibrate());
    //await Future.delayed(new Duration(milliseconds: 8000));
    final characteristicNoti = QualifiedCharacteristic(
        serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
        characteristicId: Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
        deviceId: deviceId);

    await _bleDeviceConnector.ble
        .subscribeToCharacteristic(characteristicNoti)
        .listen((data) {
      data.forEach((element) {
        print(
            "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
      });
    }, onError: (dynamic error) {
      print("Error chanfgement from a device: $error");
    });
  }



}
