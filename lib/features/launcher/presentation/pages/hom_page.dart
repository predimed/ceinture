import 'dart:async';
import 'package:ceinture/core/utils/colors.dart';
import 'package:ceinture/core/utils/translations_utils.dart';
import 'package:ceinture/features/launcher/presentation/pages/device_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: primaryColor,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }


}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: primaryColor,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String language = translationsUtils.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                  child: Container()

              ),
            ),
            Expanded(
                flex: 8,
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
      body: RefreshIndicator(
        onRefresh: () =>
        //FlutterBlue.instance.startScan(withDevices:[new Guid("0000fff0-0000-1000-8000-00805f9b34fb")],
        FlutterBlue.instance.startScan(
            timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: primaryColor,
          elevation: 10,
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices) ,
                initialData: [],
                builder: (c, snapshot) =>
                    Column(
                      children: snapshot.data.where((element) =>
                      (element.type == BluetoothDeviceType.le
                          //&& element.name?.toLowerCase()?.startsWith("j")
                      ))
                          .map((d) =>
                          GestureDetector(
                            onTap: () async {
                              //widget.stopScan();
                              await Navigator.push<void>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DeviceDetailPage(device: d)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectMenuColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    color: primaryColor,
                                    padding: EdgeInsets.all(5),
                                    height: 40,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        d.name,
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
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
                                                child: Icon(Icons.bluetooth_connected,
                                                  color: primaryColor,),

                                              )),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text('${d.id}}',
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(Icons.cloud_done,
                                              color: primaryColor,),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                          .toList(),
                    ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) =>
                    Column(
                      children: snapshot.data.where((element) =>
                      (element.device.type == BluetoothDeviceType.le
                          //&& element.device.name?.toLowerCase()?.startsWith("j")
                      ))
                          .map(
                            (r) {
                          print("the data ==========###################      ${r
                              .advertisementData.toString()
                              .toString()}");
                          return GestureDetector(
                            onTap: () async {
                              //widget.stopScan();
                              await Navigator.push<void>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DeviceDetailPage(device: r.device)));
                            },
                            child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  primaryColor,
                                  selectMenuColor
                                ]),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))
                              ),
                               child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12.0),
                                      decoration: new BoxDecoration(
                                          border: new Border(
                                              right: new BorderSide(width: 1.0, color: Colors.white24))),
                                      child: Icon(Icons.dock, color: Colors.white),
                                    ),
                                    title: Text(
                                      r.device.name,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(Icons.perm_device_information, color: Colors.yellowAccent),
                                        Text('${r.device.id}', style: TextStyle(color: Colors.white))
                                      ],
                                    ),
                                    trailing:
                                    Icon(Icons.bluetooth, color: Colors.white, size: 30.0)
                                ),
                            ),
                            ),
                          );
                        },
                      )
                          .toList(),
                    ),
              ),
            ],
          ),
        ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                backgroundColor: Colors.green,

                child: Icon(
                  Icons.search,
                  color: Colors.white
                ),
                onPressed: () =>
                    FlutterBlue.instance
                    //.startScan( withDevices:[new Guid("0000fff0-0000-1000-8000-00805f9b34fb")],
                        .startScan(
                        timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }





}

