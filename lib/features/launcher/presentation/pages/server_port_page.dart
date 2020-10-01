import 'dart:async';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/function_utils.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';
import 'package:ceinture/core/utils/preference.dart';

class ServerPortPage extends StatefulWidget {

  final BluetoothDevice device;
  final isConnected;
  ServerPortPage({@required this.device, this.isConnected}) : assert(device != null);

  @override
  PageState createState() => PageState();
}

class PageState extends State<ServerPortPage> {
  List<bool> selectionList = List.generate(2, (_) => false);
  final _formKey = GlobalKey<FormState>();
  String serverPort;
  BuildContext _buildContext;
  BuildContext _dialogContext;
  StreamSubscription<int> subscription;
  String eventCeinture='message_command_fail';
  bool isProgress = false;
  AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
  String defaultServerPort='';


  CeintureSensorRepository _ceintureSensorRepository;
  var textController = new TextEditingController();

  @override
  void initState() {
    _ceintureSensorRepository = CeintureSensorRepository(device: widget.device);
    _ceintureSensorRepository.counterObservable.listen((event) {
      eventCeinture=event;
      print("39event");
      print(event);
      switch (event) {
        case 'message_command_fail':
        case 'message_server_port_update_success':
        //Navigator.pop(_buildContext);
        //Navigator.of(_buildContext).pop();
        setState(() {
          isProgress = false;
        });
          Toast.show("${translationsUtils.text(event)}", _buildContext,
              duration: 4, gravity: Toast.TOP);

          break;
      }
    });
    super.initState();
  }


  updateServerPortValidate(){
  print("63event");
  print(eventCeinture);
   if(eventCeinture!='message_server_port_update_success') {
     //Future.delayed(Duration(seconds: 1));
     var counterStream = FunctionUtils.timedCounter(const Duration(seconds: 1), 15);
     subscription = counterStream.listen((int counter) {
       updateServerPort();
       print("eventC");
       print(eventCeinture);
       if (eventCeinture=='message_server_port_update_success') {
         subscription.pause(Future.delayed(Duration(minutes: 10)));
         subscription.cancel();
         print("eventCancel");
       }
     });
   }
}
  void updateServerPort() async {

    setState(() {
      isProgress = true;
    });
   if(defaultServerPort != serverPort)
    {
      _appSharedPreferences.setServerPort(serverPort);
    }
   if(serverPort.length <= 14){
        await _ceintureSensorRepository.executeBleCommand(widget.device.id.id,
            CeintureCommand.setServerPort(serverPort), widget.isConnected);
    }
  }

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context);
    _buildContext = context;

    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: Text("Ceinture", style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center)),
          backgroundColor: selectMenuColor,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white30,
          padding:EdgeInsets.all(5),
          child: new SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Configuration du Serveur !",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),

                FutureBuilder(
                  future:  _appSharedPreferences.getServerPort(),
                  builder: (context,  AsyncSnapshot<String> snapshot) {
                    if(snapshot.hasData && snapshot.connectionState== ConnectionState.done){
                      defaultServerPort = snapshot?.data;
                      textController.text=defaultServerPort;
                      return MyTextFormField(
                        hintText: 'Port du serveur',
                        controller: textController ,
                        validator: (String value) {
                          if (value.length < 1) {
                            return "Veuillez renseigner votre ce champs";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value) {
                          serverPort = value;
                        },
                      );
                    }else{
                      return MyTextFormField(
                        hintText: 'Nom du wifi',
                        controller: textController,
                        validator: (String value) {
                          if (value.length < 1) {
                            return "Veuillez renseigner votre ce champs";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value) {
                          serverPort = value;
                        },
                      );
                    }

                  },
                ),

                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    //setState(() {
                    if (_formKey.currentState.validate()) {
                      //showLoaderDialog();
                      updateServerPortValidate();
                      // updateServerPortValidate();
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
                        ))):Container()
              ],
            ),
            ),
          ),
        ));
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
  final TextEditingController controller;

    MyTextFormField({
    this.controller,
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
        controller: controller,
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        initialValue: initialValue,
        keyboardType: isEmail ? TextInputType.emailAddress : (isNumber?TextInputType.number:TextInputType.text),
      ),
    );
  }

}
