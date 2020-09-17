import 'package:ceinture/core/utils/centure_constants.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_setting_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/server_ip_adress_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/server_port_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/wifi_name_page.dart';
import 'package:ceinture/features/launcher/presentation/pages/wifi_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:toast/toast.dart';

import 'device_name_page.dart';
import 'hom_page.dart';

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
  final _formKey = GlobalKey<FormState>();
  String _wifiName;

  String resultDate="";
  String resultTime="";
   String resultWifiName="";
  String resultServerIP1="";
  String resultServerIP2="";
  String resultServerIP3="";



  @override
  void initState() {
        //connectDevice(context);

super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isConnected!=false)
      {
        //getDate();
       // streamMetod(getDate);

      }
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
        case 'message_get_name_device_success':

          Toast.show("${translationsUtils.text(event)}", context,
              duration: 5, gravity: Toast.TOP);
          setState(() {
            isProgress = false;
          });
          break;
        case'message_get_wifi_name_success':
          showWifiName();

          break;
        case 'message_get_server_ip_success':
          showServerIpAddress();
          break;
        case 'message_get_time_success':
          showDate();

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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SettingPage(device: widget.device , isConnected:isConnected)));
                },
                tooltip: "Modifier la ceinture",
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                    widget.device.name.toString() ?? "unknow",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22,color: Colors.white),
              )),
            ],
          ),

          backgroundColor: primaryColor,
          elevation: 0.0,
        ),


        body: Center(
            child: Container(
                child: Column(
                    children: <Widget>[

                StreamBuilder<BluetoothDeviceState>(
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
                     return  SingleChildScrollView(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                           // mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: <Widget>[
                           Container(
                             margin: EdgeInsets.only(left: 100, right: 100, top: 10, bottom: 10),

                             child:  ListTile(

                               leading:(isConnected)  ? Icon(Icons.bluetooth_connected,
                                   color: Colors.green)
                                   : Icon(Icons.bluetooth_disabled,
                                   color: Colors.red) ,
                               title: Text(
                                   ' ${snapshot.data.toString().split('.')[1]}.'),
                               // subtitle: Text('${widget.device.id}'),

                             ),

                           ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 100, right: 100, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: <Color>[
                                    primaryColor,
                                    selectMenuColor
                                  ]),
                                  shape:BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),

                              child:
                              MaterialButton(
                                shape: StadiumBorder(),
                                child:Row(
                                  children:<Widget>[

                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        height: 10,
                                        width: 10,
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
                              ),
                            ),
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
                            (isConnected)
                                ?Divider(): Container(),
                            (isConnected)
                                ? buildTitle(
                                context,Icons.devices_other, " Nom de la ceinture  :",widget.device.name,null)
                                : Container(),
                            (isConnected)
                                ?Divider(): Container(),
                            (isConnected)
                                ?buildTitle(
                                context,  Icons.date_range," Date/Heure :",resultTime?? " ",showDate)
                                : Container(),
                            (isConnected)
                                ?Divider(): Container(),
                            (isConnected)
                                ? buildTitle(
                                context, Icons.info_outline, " Adresse IP :",resultServerIP1 ?? "",showServerIpAddress)
                                : Container(),
                            (isConnected)
                                ? buildTitle(
                                context, Icons.wifi, " Nom de Wifi :",resultWifiName ?? "  ",showWifiName)
                                : Container(),
                          ],
                          ),
                     );
                    }
                    ),
                    ],
                      ),
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
       Navigator.push<void>(
            _buildContext,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()));
        setState(() {
          isProgress = false;
        });
      });
    }
  }

  //void streamMetod( VoidCallback actionStream) async {
 // Duration interval = Duration(seconds: 1);
 // Stream<int> stream = Stream<int>.periodic(interval,(x) => x );
 // await actionStream();
 // }
  void getDate() async {
     await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getTime(), isConnected);

  }
  void getWifiName() async{
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getWifiName(), isConnected);
  }

  void getServerIpAddress() async {
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getServerIpAddress(), isConnected);

  }



  Widget buildTitle(BuildContext context, IconData nameicon ,String title,String  value, VoidCallback actionMsj) {
     return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(nameicon,
            color: Colors.green),
     ),

          Text(title,
          textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.black,fontStyle: FontStyle.italic)),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic),
              softWrap: true,
            ),
          ),
          Spacer(flex: 1,),
            IconButton(
                icon: Icon(
                  Icons.autorenew,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                ),
                onPressed: () => {actionMsj()}
            ),


        ],
      ),
    );
  }

  void showDate() {
    getDate();
    String annee=Ceintureconstante.CEINTURE_TIME_LIST[1].toRadixString(16);
    String  mois=Ceintureconstante.CEINTURE_TIME_LIST[2].toRadixString(16);
    String  jours=Ceintureconstante.CEINTURE_TIME_LIST[3].toRadixString(16);
    String  heure=Ceintureconstante.CEINTURE_TIME_LIST[4].toRadixString(16);
    String  minute=Ceintureconstante.CEINTURE_TIME_LIST[5].toRadixString(16);
    String  seconde=Ceintureconstante.CEINTURE_TIME_LIST[6].toRadixString(16);
    setState(() {
      resultTime=annee+"/"+ mois+"/"+jours+"   ;    "+heure+":"+minute+":"+seconde ;
    });
  }

  void showWifiName() {

    getWifiName();
    String index1=Ceintureconstante.CEINTURE_WIFI_NAME[1].toRadixString(16);
    String  index2=Ceintureconstante.CEINTURE_WIFI_NAME[2].toRadixString(16);
    String  index3=Ceintureconstante.CEINTURE_WIFI_NAME[3].toRadixString(16);
    String  index4=Ceintureconstante.CEINTURE_WIFI_NAME[4].toRadixString(16);
    String  index5=Ceintureconstante.CEINTURE_WIFI_NAME[5].toRadixString(16);
    String  index6=Ceintureconstante.CEINTURE_WIFI_NAME[6].toRadixString(16);
    setState(() {
      resultWifiName=index1+ index2+index3+index4+index5+index6 ;
    });

  }


  void showServerIpAddress() {
    getServerIpAddress();
    resultServerIP1=transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1);

    setState(() {
      if (Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1.isEmpty) {
        resultServerIP1 = transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1);
      }
      else if((Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1.isEmpty)&&
          (Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2.isEmpty))
        {
          resultServerIP1 = " TR1"+transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1)
                           +" TR2"+transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2);

        }
      else if((Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1.isEmpty)&&
          (Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2.isEmpty) &&
          (Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2 != null && !Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS3.isEmpty))
      {
        resultServerIP1 = " TR1"+transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS1)
                        +" TR2"+transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS2)
                        +" TR2"+transformIpAddress(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS3);

      }
    });


  }

  void updateDate() async {
    setState(() {
      isProgress = true;
    });
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.setTime(), isConnected);
  }

  Widget btnCommand(BuildContext context, String title,
      VoidCallback actionComman) {
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




  void stopRealTime() async {
    setState(() {
      isProgress = true;
    });
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.stopRealTime(), isConnected);
  }



  void wifiStatus() async {
    setState(() {
      isProgress = true;
    });
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getConnectionStatus(),
        isConnected);
  }

  void updateWifiPassword() async {
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                WifiPasswordPage(
                  device: widget.device,
                  isConnected: isConnected,
                )));
  }

  void serverIpAddress() async {
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                ServerIpAdressPage(
                  device: widget.device,
                  isConnected: isConnected,
                )));
  }

  void serverPort() async {
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                ServerPortPage(
                  device: widget.device,
                  isConnected: isConnected,
                )));
  }

  void deviceName() async {
    await Navigator.push<void>(
        _buildContext,
        MaterialPageRoute(
            builder: (context) =>
                DeviceNamePage(
                  device: widget.device,
                  isConnected: isConnected,
                )));
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
                WifiNamePage(
                  device: widget.device,
                  isConnected: isConnected,
                )));
  }

  void updateWifiNameValidate() async {
    //String name = "didierccccccccccccccc";
    if (_wifiName.length <= 14) {
      await _ceintureSensorRepository.executeBleCommand(widget.device.id.id,
          CeintureCommand.setWifiNameLessThan14(_wifiName), isConnected);
    } else {
      await _ceintureSensorRepository.executeBleCommand(widget.device.id.id,
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
                padding: EdgeInsets.all(20),
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
              child: Text(
                "Nous sommes en chemin...",
                style: TextStyle(fontSize: 12),
              )),
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

String transformIpAddress(List<int> ceintureServerIpAddress) {
  String index1=String.fromCharCode(ceintureServerIpAddress[3]);
  String index2=String.fromCharCode(ceintureServerIpAddress[4]);
  String index3=String.fromCharCode(ceintureServerIpAddress[5]);
  String index4=String.fromCharCode(ceintureServerIpAddress[6]);
  String index5=String.fromCharCode(ceintureServerIpAddress[7]);
  String index6=String.fromCharCode(ceintureServerIpAddress[8]);
  String index7=String.fromCharCode(ceintureServerIpAddress[9]);
  String index8=String.fromCharCode(ceintureServerIpAddress[10]);
  String index9=String.fromCharCode(ceintureServerIpAddress[11]);
  String index10=String.fromCharCode(ceintureServerIpAddress[12]);
  String index11=String.fromCharCode(ceintureServerIpAddress[13]);
  String index12=String.fromCharCode(ceintureServerIpAddress[14]);

  var resultServerIP = index1  + index2 + index3+ index4 + index5 + index6 + index7 + index8 + index9+index10+index11+index12 ;
return resultServerIP;
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

