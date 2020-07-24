import 'package:ceinture/core/helpers/ble/ble_device_connector.dart';
import 'package:ceinture/core/helpers/ble/ble_scanner.dart';
import 'package:ceinture/core/helpers/ble/ble_status_monitor.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class DeviceDetailScreen extends StatefulWidget {
  final DiscoveredDevice device;

  DeviceDetailScreen({@required this.device}) : assert(device != null);

  @override
  PageState createState() => PageState();
}

class PageState extends State<DeviceDetailScreen> {
  BleScanner bleScanner;

  bool loadingConnexion = false;
  bool loadingTime = false;

  BleStatusMonitor bleStatusMonitor;

  BleDeviceConnector bleDeviceConnector;

  DeviceConnectionState connectionState;

  CeintureSensorRepository _ceintureSensorRepository;

  @override
  Widget build(BuildContext context) {
    bleScanner = Provider.of<BleScanner>(context, listen: true);
    bleStatusMonitor = Provider.of<BleStatusMonitor>(context, listen: true);
    bleDeviceConnector = Provider.of<BleDeviceConnector>(context, listen: true);


    return WillPopScope(
      onWillPop: () async {
        //disconnect(device.id);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                widget.device.name ?? "unknow",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
            ],
          ),
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body: Consumer2<BleDeviceConnector, ConnectionStateUpdate>(
            builder: (_, deviceConnector, connectionStateUpdate, __) {
              print('connection etat  ${connectionStateUpdate.connectionState}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    color: (connectionStateUpdate.connectionState == DeviceConnectionState.connected)
                        ? selectMenuColor
                        : primaryColor,
                    child: MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: (loadingConnexion)
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    )
                                  : Container(),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              (connectionState ==
                                      DeviceConnectionState.connected)
                                  ? 'Deconnexion'
                                  : 'Connexion',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => connectDevice(context),
                    )),
                GestureDetector(
                  onTap: () => updateDate(),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    height: 50,
                    alignment: Alignment.center,
                    color: primaryColor,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: (!loadingTime)
                                ? Container()
                                : CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            'Mettre à jour la date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  void connectDevice(BuildContext context) {
    // setState(() {
    loadingConnexion = true;
    // });
    bleDeviceConnector.ble
        .connectToDevice(id: "${widget.device.id}")
        .listen((event) async {
      setState(() {
        loadingConnexion = false;
        connectionState = event.connectionState;
        print('connection etat ================================================= ${connectionState}');
        print(
            "tentative de conneion mon didier =============================$event");
        if (connectionState == DeviceConnectionState.connected) {
          Toast.show("Connected to ${widget.device.name}", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // await _pedometerSensorRepository.executeCommand( "${element.macAddress}", PedometerCommand.getData(0));
        }
      });
    });
  }

  void updateDate() {
    if (connectionState == DeviceConnectionState.connected) {
      print("commande mon didier ==========================================");
      Future.delayed(new Duration(milliseconds: 2000));
      if (_ceintureSensorRepository == null) {
        _ceintureSensorRepository =
            new CeintureSensorRepository(bleDeviceConnector);
      }
      _ceintureSensorRepository.executeCommand(
          "${widget.device.id}", CeintureCommand.getTime());
      loadingTime = false;
    }
  }
}
