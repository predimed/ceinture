import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:ceinture/features/launcher/presentation/pages/wifi_name_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/wifi_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

class DeviceDetailPage extends StatelessWidget {
  final BluetoothDevice device;

  DeviceDetailPage({@required this.device}) : assert(device != null);

  bool loadingConnexion = false;
  bool loadingTime = false;
  bool isConnected = false;
  BluetoothDeviceState _bluetoothDeviceState;
  CeintureSensorRepository _ceintureSensorRepository;
  final _formKey = GlobalKey<FormState>();
  BuildContext _buildContext;
  String _wifiName;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    _ceintureSensorRepository = CeintureSensorRepository(device: device);
    _ceintureSensorRepository.counterObservable.listen((event) {
      switch (event) {
        case 'message_command_fail':
        case 'message_time_update_success':
        case 'message_wifi_update_success':
        case 'message_wifi_password_update_success':
        case 'message_connection_success':
        case 'message_connection_fail':
          Toast.show("${translationsUtils.text(event)}", context,
              duration: 5, gravity: Toast.BOTTOM);
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
                device.name.toString() ?? "unknow",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
            ],
          ),
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body: Center(
          child: StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              loadingConnexion = false;
              if (snapshot.data == BluetoothDeviceState.connected) {
                isConnected = true;
              } else {
                isConnected = false;
              }
              return Column(
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
                  btnCommand(context, "Mettre à jour la date", updateDate),
                  btnCommand( context, "Mettre à jour le nom du WIFI", updateWifiName),
                  btnCommand(context, "Mettre à jour le mot de passe du WIFI", updateWifiPassword),
                  btnCommand(context, "Etat du WIFI", wifiStatus),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget btnCommand(
      BuildContext context, String title, VoidCallback actionComman) {
    return GestureDetector(
      onTap: () => actionComman(),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                '${title}',
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
    );
  }

  void connectDevice(BuildContext context) async {
    loadingConnexion = true;
    if (!isConnected) {
      await device.connect().then((value) {});
    } else {
      await device.disconnect().then((value) {});
    }
  }

  void updateDate() async {
    await _ceintureSensorRepository.executeBleCommand(
        device.id.id, CeintureCommand.setTime(), isConnected);
  }

  void wifiStatus() async {
    await _ceintureSensorRepository.executeBleCommand(
        device.id.id, CeintureCommand.getConnectionStatus(), isConnected);
  }

  void updateWifiPassword() async {
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                WifiPasswordPage(device: device, isConnected: isConnected,)));
  }

  void updateWifiName() async {
    /*Navigator.of(_buildContext).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) =>
            WifiNamePage(device: device, isConnected: isConnected,)));*/
    //showWifiNameForm();
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                WifiNamePage(device: device, isConnected: isConnected,)));
  }

  void updateWifiNameValidate() async {
    //String name = "didierccccccccccccccc";
    if (_wifiName.length <= 14) {
      await _ceintureSensorRepository.executeBleCommand(device.id.id,
          CeintureCommand.setWifiNameLessThan14(_wifiName), isConnected);
    } else {
      await _ceintureSensorRepository.executeBleCommand(device.id.id,
          CeintureCommand.setWifiNameLessThan14(_wifiName), isConnected,
          commandList: CeintureCommand.setWifiNameGreatThan14(_wifiName));
    }
  }

  showWifiNameForm() {
    showModalBottomSheet(
      context: _buildContext,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.all( 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Configuration du WIFI !",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      MyTextFormField(
                        hintText: 'Nom du wifi',
                        initialValue: '',
                        validator: (String value) {
                          if (value.length < 1) {
                            return "Veuillez renseigner votre ce champs";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value) {
                          _wifiName = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          //setState(() {
                          if (_formKey.currentState.validate()) {
                            showLoaderDialog(context);
                            updateWifiNameValidate();
                          }
                          //});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: <Color>[
                                primaryColor,
                                selectMenuColor
                              ]),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 6,
                                child: Text(
                                  "Valider",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Nous sommes en chemin...", style: TextStyle(fontSize: 12),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;
  final bool isNumber;

  MyTextFormField({
    this.hintText,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : (isNumber ? TextInputType.number : TextInputType.text),
      ),
    );
  }
}
