import 'package:ceinture/core/helpers/ble/ble_device_connector.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rxdart/rxdart.dart';

class CeintureSensorRepository {
  BleDeviceConnector bleDeviceConnector;
  bool isConnected = false;
  BluetoothDevice device;
  BehaviorSubject<String> _subjectCounter;
  String initialCount = "label_init";

  CeintureSensorRepository(
      {this.bleDeviceConnector, this.isConnected, this.device}) {
    _subjectCounter = BehaviorSubject<String>.seeded(this.initialCount);
  }

  Stream<String> get counterObservable => _subjectCounter.stream;

  Future<List<int>> executeCommand(String deviceId, List<int> command) async {
    List<int> finalData;
    //if (_bleDeviceConnector.connection != null) {
    if (1 == 1) {
      try {
        final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
            characteristicId:
                Uuid.parse("0000fff6-0000-1000-8000-00805f9b34fb"),
            deviceId: deviceId);
        await bleDeviceConnector.ble
            .writeCharacteristicWithResponse(characteristic, value: command);
        // await Future.delayed(new Duration(milliseconds: 3000));

        final characteristicNoti = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
            characteristicId:
                Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
            deviceId: deviceId);

        await bleDeviceConnector.ble
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
    } else {
      print("connexion null");
    }
  }

  Future<bool> executeBleCommand(
      String deviceId, List<int> command, bool isConnected,
      {List<List<int>> commandList}) async {
    try {
      if (isConnected) {
        print("commande lancé ==========================================");
        Future.delayed(new Duration(milliseconds: 2000));
        List<BluetoothService> services = await device.discoverServices();
        try {
          services.forEach((service) async {
            if (service.uuid ==
                new Guid("0000fff0-0000-1000-8000-00805f9b34fb")) {
              print("service lancé ==========================================");

              BluetoothCharacteristic cWrite = service.characteristics
                  .firstWhere((element) =>
                      element.uuid ==
                      new Guid("0000fff6-0000-1000-8000-00805f9b34fb"));
              print("carac lancé ==========================================");
              try {
                if (commandList != null && !commandList.isEmpty) {
                  commandList.forEach((elementCommand) async {
                    await cWrite.write(elementCommand);
                  });
                } else {
                  await cWrite.write(command);
                }
              } catch (e, s) {
                print(s);
                _subjectCounter.sink.add("message_command_fail");
              }
              //
              BluetoothCharacteristic cNotif = service.characteristics
                  .firstWhere((element) =>
                      element.uuid ==
                      new Guid("0000fff7-0000-1000-8000-00805f9b34fb"));
              await Future.delayed(new Duration(milliseconds: 2000));
              await cNotif.setNotifyValue(true);
              cNotif.value.listen((value) {
                // do something with new value
                return actionTodoWithCommandReult(command, value);
              });
              //
              return false;
            }
          });
        } catch (e, s) {
          print(s);
          //_subjectCounter.sink.add("message_command_fail");
        }
      } else {
        print(
            "connexion error ###########################========================");
      }
    } catch (e) {
      print("message_command_fail========================");
      //_subjectCounter.sink.add("message_command_fail");
    }
  }

  bool actionTodoWithCommandReult(List<int> command, List<int> data) {
    if (data != null && !data.isEmpty) {
      print(
          "voici les entete commande  en hexa  que je veux ####################### :   ${data[0]}");
      switch ((data[0])) {
        case CeintureCommand.CMD_VIBRATE:
          data.forEach((element) {
            print(
                "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
          });
          break;

        case CeintureCommand.CMD_GET_CONNECTION_STATUS:
          print(
              "voici le resultat avant controle=====================  :   ${data.toString()}");
          if (data != null &&
              !data.isEmpty &&
              data[1].toRadixString(16) == 01.toRadixString(16)) {
            print(
                "voici le resultat=====================  :   ${data.toString()}");
            data.forEach((element) {
              print(
                  "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
            });
            _subjectCounter.sink.add("message_connection_success");
          }else{
            _subjectCounter.sink.add("message_connection_fail");
          }
          break;

        case CeintureCommand.CMD_SET_TIME:
          print(
              "voici le resultat=====================  :   ${data.toString()}");
          data.forEach((element) {
            print(
                "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
          });
          _subjectCounter.sink.add("message_time_update_success");
          return true;
          break;

        case CeintureCommand.CMD_SET_WIFI_NAME:
          if (data != null &&
              !data.isEmpty &&
              data.first.toRadixString(16) != 26.toRadixString(16)) {
            print(
                "voici le resultat=====================  :   ${data.toString()}");
            data.forEach((element) {
              print(
                  "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
            });
            //Toast.show("", context)
            _subjectCounter.sink.add("message_wifi_update_success");
            return true;
          }
          break;

        case CeintureCommand.CMD_SET_WIFI_PASSWORD:
          if (data != null &&
              !data.isEmpty &&
              data.first.toRadixString(16) == 07.toRadixString(16)) {
            print(
                "voici le resultat=====================  :   ${data.toString()}");
            data.forEach((element) {
              print(
                  "voici les changement  en hexa  que je veux  :   ${element.toRadixString(16)}");
            });
            //Toast.show("", context)
            _subjectCounter.sink.add("message_wifi_password_update_success");
            return true;
          }
          break;
      }
    }

    return false;
  }

  Future<List<int>> getTime(String deviceId) async {
    var x = await executeCommand(deviceId, CeintureCommand.getTime());
    //await Future.delayed(new Duration(milliseconds: 8000));
    final characteristicNoti = QualifiedCharacteristic(
        serviceId: Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb"),
        characteristicId: Uuid.parse("0000fff7-0000-1000-8000-00805f9b34fb"),
        deviceId: deviceId);

    await bleDeviceConnector.ble
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

    await bleDeviceConnector.ble
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

    await bleDeviceConnector.ble
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
