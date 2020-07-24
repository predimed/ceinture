import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetailPage extends StatefulWidget {
  final BluetoothDevice device;

  DeviceDetailPage({@required this.device}) : assert(device != null);

  @override
  PageState createState() => PageState();
}

class PageState extends State<DeviceDetailPage> {
  bool loadingConnexion = false;
  bool loadingTime = false;
  BluetoothDeviceState _bluetoothDeviceState;

  @override
  initState(){

  }

  CeintureSensorRepository _ceintureSensorRepository;

  @override
  Widget build(BuildContext context) {
    widget.device.state.listen((event) {
      setState(() {
        _bluetoothDeviceState = event;
      });
    });

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
                widget.device.id.toString() ?? "unknow",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
            ],
          ),
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  color: (_bluetoothDeviceState == BluetoothDeviceState.connected)
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
                          child: Text( 'Connexion',
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
        ),
      ),
    );
  }

  void connectDevice(BuildContext context)async {
    // setState(() {
    loadingConnexion = true;
    await widget.device.connect().then((value) {
      print("ou suis je...");
    });

    // });

  }

  void updateDate() {

  }
}
