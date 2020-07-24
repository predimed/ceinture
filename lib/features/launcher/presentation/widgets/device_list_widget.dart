import 'package:ceinture/core/helpers/ble/ble_scanner.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/core/utils/utils.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DeviceListWidget extends StatefulWidget {
  const DeviceListWidget(
      {@required this.scannerState,
      @required this.startScan,
      @required this.stopScan})
      : assert(scannerState != null),
        assert(startScan != null),
        assert(stopScan != null);

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  PageState createState() => PageState();
}

class PageState extends State<DeviceListWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    //requestLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    widget.stopScan();
    dispose();
    super.dispose();
  }

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
                  children: widget.scannerState.discoveredDevices.map(
                    (device) {
                      return GestureDetector(
                        onTap: () async {
                          widget.stopScan();
                          await Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DeviceDetailScreen(
                                      device: device)));
                        },
                        child: Container(
                          margin : EdgeInsets.all(5),
                          color: Colors.grey[200],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                color: Colors.grey[400],
                                padding : EdgeInsets.all(5),
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(device.name, textAlign: TextAlign.left,),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex:1,
                                      child: Container(
                                          padding : EdgeInsets.all(5),
                                          child: Align(
                                            alignment:Alignment.centerLeft,
                                            child: Icon(Icons.bluetooth),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      flex:2,
                                      child: Container(
                                        padding : EdgeInsets.all(5),
                                        child: Text('${device.id}'),
                                      ),
                                    ),
                                    Expanded(
                                      flex:1,
                                      child: Container(
                                        padding : EdgeInsets.all(5),
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

  void _startScanning()async {
    _displaySnackBar(context, "Recherche en cours...");
    //
    await Future.delayed(new Duration(milliseconds: 2000));
    widget.startScan([]);
    //widget.startScan([Uuid.parse("0000fff0-0000-1000-8000-00805f9b34fb")]);
  }



  _displaySnackBar(BuildContext context, message) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Future<bool> requestLocationPermission() async {
    if (await Permission.location.isRestricted) {
      var granted = await Permission.location.request();
      if (granted != true) {
        requestLocationPermission();
      }
    }
  }
}
