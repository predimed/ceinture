import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as fl;

class HomePage extends StatefulWidget {
  @override
  PageState createState() => PageState();
}

class PageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<fl.ScanResult> _scanresultList = [];

  fl.FlutterBlue flutterBlue = fl.FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[primaryColor, primaryColor]),
                        shape: BoxShape.circle),
                    height: 150,
                    child: Icon(Icons.home),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
              ),
              Expanded(
                  flex: 10,
                  child: Text(
                    translationsUtils.text("app_name"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  )),
            ],
          ),
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView(
                  children: _scanresultList.map(
                    (device) {
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DeviceDetailPage(
                                      device: device.device)));
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.grey[200],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                color: Colors.grey[400],
                                padding: EdgeInsets.all(5),
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    device.device.type.toString(),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(Icons.bluetooth),
                                          )),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text('${device.device.id}'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.cloud_off),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: _startScanning,
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
        ));
  }

  _displaySnackBar(BuildContext context, message) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _startScanning() {
    _scanresultList.clear();
    _displaySnackBar(context, "Recherche encours ...");
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var subscription = flutterBlue.scanResults.listen((results) {
      for (fl.ScanResult r in results) {
        _scanresultList.add(r);
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

// Stop scanning
    flutterBlue.stopScan();
    setState(() {

    });
  }
}
