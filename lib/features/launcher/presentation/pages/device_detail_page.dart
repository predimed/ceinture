import 'package:ceinture/core/utils/centure_constants.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

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


  String resultDate="";
  String resultTime="";
   String resultDateHeure="";
  String resultServerIP="";
  CeintureSensorRepository _ceintureSensorRepository;



  @override
  void initState() {
        connectDevice(context);
super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isConnected!=false)
      {
        streamMetod(getDate);

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
        drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
        DrawerHeader(
        child: Text( widget.device.name.toString() ?? "unknow",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),),
          decoration: BoxDecoration(
            color: primaryColor,
          ),
        ),
        ListTile(
          title: Text('Mettre à jour la date'),
          onTap: () {

          },
        ),
        ],),
        ),
        appBar: AppBar(

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


        body: SingleChildScrollView(
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
                     return  Container(

                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                          Container(
                          child:Column(
                              children:<Widget>[
                              ListTile(
                              leading:(isConnected)  ? Icon(Icons.bluetooth_connected,
                                  color: Colors.green)
                              : Icon(Icons.bluetooth_disabled,
                                  color: Colors.red) ,
                       title: Text(
                           ' ${snapshot.data.toString().split('.')[1]}.'),
                      // subtitle: Text('${widget.device.id}'),
                       trailing: StreamBuilder<bool>(
                         stream: widget.device.isDiscoveringServices,
                         initialData: false,
                         builder: (c, snapshot) => IndexedStack(
                           index: snapshot.data ? 1 : 0,
                           children: <Widget>[
                             Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 RaisedButton.icon(
                                   icon:(isConnected) ? Icon(Icons.bluetooth_disabled):Icon(Icons.bluetooth_connected),
                                   color: (isConnected) ? Colors.deepOrange : Colors.green,
                                   label: Text((isConnected) ? "Déconnexion":"Connexion" ),
                                   onPressed: ()=>  connectDevice(context),
                                 ),

                               ],
                             ),
                           ],
                         ),),



                     ),
                      ],
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
                                context,Icons.devices_other, " Nom de ceinture  :",widget.device.name,null)
                                : Container(),
                            (isConnected)
                                ?Divider(): Container(),
                            (isConnected)
                                ?buildTitle(
                                context,  Icons.date_range," Date/Heure :",resultDateHeure ?? " ",showDate)
                                : Container(),
                            (isConnected)
                                ?Divider(): Container(),
                            (isConnected)
                                ? buildTitle(
                                context, Icons.info_outline, " Adress IP :",resultServerIP ?? "  ",showServerIpAddress)
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


        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SettingPage(device: widget.device , isConnected:isConnected)));
          },

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

  streamMetod( VoidCallback actionStream) async {
  Duration interval = Duration(seconds: 2);
  Stream<int> stream = Stream<int>.periodic(interval,(x) => x );
  await for(int i in stream) {
    await actionStream();
  }
  }
  void getDate() async {
     await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getTime(), isConnected);

  }
  void getServerIpAddres() async {
    await _ceintureSensorRepository.executeBleCommand(
        widget.device.id.id, CeintureCommand.getServerIpAddress(), isConnected);
    print("251");
    print(Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS);
  }



  Widget buildTitle(BuildContext context, IconData nameicon ,String title,String  value, VoidCallback actionMsj) {
     return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Icon(nameicon,
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
              '${value}',
              style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.black,fontStyle: FontStyle.italic),
              softWrap: true,
            ),
          ),

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
   int annee=Ceintureconstante.CEINTURE_TIME_LIST[1];
   int mois=Ceintureconstante.CEINTURE_TIME_LIST[2];
   int jours=Ceintureconstante.CEINTURE_TIME_LIST[3];
    int heure=Ceintureconstante.CEINTURE_TIME_LIST[4];
    int minute=Ceintureconstante.CEINTURE_TIME_LIST[5];
    int seconde=Ceintureconstante.CEINTURE_TIME_LIST[6];
      setState(() {
        resultTime= heure.toRadixString(16) +":"+minute.toRadixString(16)+":"+ seconde.toRadixString(16);

        resultDate= annee.toRadixString(16) +"/"+mois.toRadixString(16)+"/"+ jours.toRadixString(16);
        resultDateHeure=resultDate+" , "+resultTime;
      });
  }



  void showServerIpAddress() {

    setState(() {
      resultServerIP= Ceintureconstante.CEINTURE_SERVER_IP_ADDRESS[4].toRadixString(16).toString();
    });


  }




}

