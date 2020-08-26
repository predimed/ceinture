
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/data/repositories/centure_sensor_repository.dart';
import 'package:ceinture/features/launcher/data/utils/ceintute_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

class WifiPasswordPage extends StatefulWidget {

  final BluetoothDevice device;
  final isConnected;
  WifiPasswordPage({@required this.device, this.isConnected}) : assert(device != null);

  @override
  PageState createState() => PageState();
}

class PageState extends State<WifiPasswordPage> {
  List<bool> selectionList = List.generate(2, (_) => false);
  final _formKey = GlobalKey<FormState>();
  String _wifiName;
  BuildContext _buildContext;
  BuildContext _dialogContext;
  bool isProgress = false;

  CeintureSensorRepository _ceintureSensorRepository;

  @override
  void initState() {
    _ceintureSensorRepository = CeintureSensorRepository(device: widget.device);
    _ceintureSensorRepository.counterObservable.listen((event) {
      switch (event) {
        case 'message_command_fail':
        case 'message_wifi_password_update_success':
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


  void updateWifiPassword() async {
    setState(() {
      isProgress = true;
    });
    await _ceintureSensorRepository.executeBleCommand(widget.device.id.id,
        CeintureCommand.setWifiPassword(_wifiName), widget.isConnected);
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
                    "Configuration du WIFI !",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                MyTextFormField(
                  hintText: 'Mot de passe du wifi',
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
                      //showLoaderDialog();
                      updateWifiPassword();
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

  showLoaderDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _dialogContext = context;
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Veuillez patienterok..."),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                )
              ],
            ),
          );
        });

    //Navigator.of(context).pop();


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
        keyboardType: isEmail ? TextInputType.emailAddress : (isNumber?TextInputType.number:TextInputType.text),
      ),
    );
  }
}
