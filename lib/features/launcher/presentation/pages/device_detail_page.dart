import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

class DeviceDetailPage extends StatefulWidget {
  final BluetoothDevice device;

  DeviceDetailPage({@required this.device}) : assert(device != null);
  @override
  PageState createState() => PageState();
}


  class PageState extends State<DeviceDetailPage> {

  bool loadingConnexion = false;
  bool loadingTime = false;
  bool isConnected = false;
  bool isProgress = false;
  BuildContext _buildContext;
  CeintureSensorRepository _ceintureSensorRepository;


  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    _ceintureSensorRepository = CeintureSensorRepository(device: widget.device);
    _ceintureSensorRepository.counterObservable.listen((event) {
      switch (event) {
        case 'message_command_fail':
        case 'message_time_update_success':
        case 'message_wifi_update_success':
        case 'message_wifi_password_update_success':
        case 'message_connection_success':
        case 'message_connection_server_success':
        case 'message_connection_wifi_success':
        case 'message_real_time_is_stop':
        case 'message_connection_fail':
          Toast.show("${translationsUtils.text(event)}", context,
              duration: 5, gravity: Toast.TOP);
          setState(() {
            isProgress = false;
          });
          break;
      }
    });

    return WillPopScope(
      /* onWillPop: () async {
        //disconnect(device.id);
        return true;
      },*/
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                    widget.device.name.toString() ?? "unknow",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
            ],
          ),
          actions: <Widget> [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingPage(device: widget.device)));
              },
            ),

          ],
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body: Center(
          child: StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              loadingConnexion = false;
              if (snapshot.data == BluetoothDeviceState.connected) {
                isConnected = true;
                //isProgress = false;
              } else {
                //isProgress = false;
                isConnected = false;
              }
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          color: (isConnected) ? selectMenuColor : primaryColor,
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
                                    (isConnected) ? 'Deconnexion' : "Connexion",
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
                      (isProgress)?Container(
                          child: AlertDialog(
                              content: new Row(
                                children: [
                                  CircularProgressIndicator(),
                                  Container(
                                      margin: EdgeInsets.all( 20),
                                      child: Text(
                                        "Veuillez patienter...",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ],
                              ))):Container(),


                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  void connectDevice(BuildContext context) async {
    loadingConnexion = true;
    setState(() {
      isProgress = true;
    });
    if (!isConnected) {
      await widget.device.connect().then((value) {
        setState(() {
          isProgress = false;
        });
      });
    } else {
      await widget.device.disconnect().then((value) {
        setState(() {
          isProgress = false;
        });
      });
    }
  }

}
